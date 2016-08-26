# Lockheed 1049H
#
# Custom 1049H routines for fuel tanks and routing support
#
# Gary Neely aka 'Buckaroo'
#
# Special thanks to 'smoki' for pointing out additional problems with JSB level-lb/lbs issue in CVS Flightgear
# and suggesting code changes, incorporated below.
#
# General physical tank location schematic:
# Engines:          1   2     3   4
#             ----------------------------
# Tanks:    1A  2A  1   2  5  3   4   3A  4A
#
# The actual tank feed situation looks something like this:
# Engines:      1     2         3     4
#               |     |         |     |
#              ev1   ev2       ev3   ev4   :emergency engine cut-off valves
#               |     |         |     |
#              cv1...cv2...+...cv3...cv4   :cross-feed valves
#               |    |    |     |
#              tv1   tv2  tv5  tv3   tv4   :tank selector valves
#               |     |    |    |     |
# Tanks:      1/1A   2/2A  5   3/3A  4/4A 
#
# The tank selector valves can be set to off or select the primary or secondary tank. Currently only
# 2 and 3 have secondaries (2A, 3A), but if wing-tip tanks are installed they are secondaries for
# tanks 1 and 4. The center tank 5 has no secondary.
#
# Cross-feed valves allow an engine to draw from all selected tanks rather than just their standard
# tank. For example, engine 1 normally draws from tank 1, but if the engine 1 cross-feed is open, it
# will draw evenly from all open tanks.
#
# Wing-tip tanks 1A and 4A are currently not used in the 1049H model, but provisions are built into 
# the fuel system to add them relatively easily.
#
# Tank Indexes and corresponding tanks:
# [ 0,  1,  2,  3, 4, 5, 6, 7, 8,  9, 10, 11, 12]
#  B1, B2, B3, B4, 1, 2, 3, 4, 5, 1A, 2A, 3A, 4A
#  +------------+  +---------------------------+
#   Line Buffers             True Tanks
#
# The system works by having engines draw from small fuel line buffer tanks which are replenished from
# the true tanks via nasal script according to tank and cross-feed valve settings. Engines never draw
# directly from true tanks, though true tanks are described in the FDM so their weight affects the flight
# parameters as expected.
#
# Fuel is calculated based on lbs used. Max lbs is related to the max tank capacity in gallons by the
# 6.0 lbs/gallon standard, but for some reason JSBsim uses 6.6 lbs/gallon. The level-lb value is correct,
# but level-gal_us is based on the 6.6 value. This wouldn't be a problem, except that the level-lb value
# can't be written to, only level-gal_us. So we have to do some weirdness to make sure level-gal_us agrees
# with level-lb. But as long as MAX_LBS is set to whatever the capacity in gallons * 6.0 is, we should be OK.
#
# Emergency shut-off valves (located overhead) have 4 possible values:
#   0 - all open
#   1 - off: hydraulic oil
#   2 - off: hydraulic oil, fuel, blast air
#   3 - off: hydraulic oil, fuel, blast air, engine oil
# Currently only fuel is simulated, so positions 0 & 1, and 2 & 3 are the same. Effectively, 2+ cuts off fuel
# to the given engine.


var MAX_LBS				= 10;   #12 original			# Fuel line buffer max level in 6.0/gallon pounds
var GALUSTOLBS		= 6.6;						# JSBsim fixed lbs/gallon value

									# Set up tank and valve vars:
var tanks		= props.globals.getNode("/consumables/fuel").getChildren("tank");
var cross_valves	= props.globals.getNode("/controls/fuel").getChildren("crossfeedvalves");
var tank_valves		= props.globals.getNode("/controls/fuel").getChildren("tankvalves");
var engine_valves	= props.globals.getNode("/controls/fuel").getChildren("enginevalves");
var fuel_totals		= props.globals.getNode("/consumables/fuel/total-fuel-lbs");
									# Set up fuel preset lists:
var fuel_presets	= props.globals.getNode("/systems/fuel/tanks").getChildren("fuel_preset");


#
# Main Fuel Cycle
#

var fuel_update = func {
  for (var engine=0; engine<4; engine+=1) {				# For each engine:
    if (engine_valves[engine].getChild("valve").getValue() > 1)		# Engine fuel valve not open, no eating here today
      { continue; }
    if (get_lbs(engine) >= MAX_LBS)					# Check engine buffer tank level
      { continue; }							# No change in fuel level, engine probably off, go to next engine
    var fuel_used = MAX_LBS - get_lbs(engine);				# How much fuel used in this cycle?

    if (cross_valves[engine].getChild("valve").getValue() > 0) {	# Cross-feed tank draw:
  									# Find number of tanks open and with fuel >= fuel_used
  									# For simplicity, ignore those having too little fuel to matter
      var xfeed_list = [];
      for (var tank=4; tank<=8; tank+=1) {				# For each primary tank + center tank (indexes 4-8)
        var tank_index = tank_status(tank,fuel_used);			# 0 if closed or not enough fuel, else is delivering tank's index
        if (tank_index > 0) {						# Add delivery-capable tank to cross-feeding tank list
          append(xfeed_list, tank_index);
        }
      }
  									# Distribute fuel draw between cross-feeding capable tanks
      if (size(xfeed_list) > 0) {					# Do we have any delivery-capable tanks?
        var fuel_portion = fuel_used / size(xfeed_list);		# Split fuel request evenly between all cross-feeding tanks
        foreach(var x_tank; xfeed_list) {
          transfer_fuel(engine,x_tank,fuel_portion);
        }
      }
    }
  
    else {								# Standard tank draw:
      if (tank_valves[engine].getChild("valve").getValue() == 1)	# 1: Draw from primary tank
        { transfer_fuel(engine,engine+4,fuel_used); }
      elsif (tank_valves[engine].getChild("valve").getValue() == 2)	# 2: Draw from secondary tank (2A,3A or wing-tip tanks 1A,2A if provided)
        { transfer_fuel(engine,engine+9,fuel_used); }
    }
  }
  settimer(fuel_update,2);						# Schedule the next run in 2 secs
}


#
# Fuel Totalizer Cycle
#

var fuel_totalizer = func{
  var total_lbs = 0;
  for (var tank=4; tank<=12; tank+=1) {					# For each true tank (indexes 4-12)
    total_lbs += get_lbs(tank);						# Sum tank levels
  }
  fuel_totals.setValue(total_lbs);					# Set master fuel totals
  settimer(fuel_totalizer,10);						# Schedule the next run in 10 secs
}


#
# Initialize fuel system
# Update fuel every 2 seconds
# Update fuel totalizer every 10 seconds (after initial run)
#

var fuel_update_init = func {
  preset_fetch();							# Load preset fuel configuration
  settimer(fuel_update,2);						# Startup fuel system
  settimer(fuel_totalizer,2);						# Startup fuel totalizer
}

settimer(fuel_update_init,1);


#
# Helper Functions
#

#var get_lbs = func(tank_index) {
#  var lbs = 0;
#  if (tanks[tank_index].getChild("level-lb") == nil) {			# Hack to deal with renaming of level-lb
#    lbs = tanks[tank_index].getChild("level-lbs").getValue();		# to level-lbs in JBSsim
#  }
#  else {
#    lbs = tanks[tank_index].getChild("level-lb").getValue();
#  }
#  if (lbs==nil) { lbs = 0; }
#  return lbs;
#}

#var get_lbs = func(tank_index) {					# FG <= 1.9x version
#  return tanks[tank_index].getChild("level-lb").getValue();
#}

var get_lbs = func(tank_index) {					# FG > 1.9x version
  return tanks[tank_index].getChild("level-lbs").getValue();
}

var get_gals = func(tank_index) {
  tanks[tank_index].getChild("level-gal_us").getValue();
}
var set_gals = func(tank_index,gallons) {
  tanks[tank_index].getChild("level-gal_us").setValue(gallons);
}
var get_capacity = func(tank_index) {
  tanks[tank_index].getChild("capacity-gal_us").getValue();
}
var set_tank_valve = func(valve_index,setting) {
  tank_valves[valve_index].getChild("valve").setValue(setting);
}
var set_xfeed_valve = func(xfeed_index,setting) {
  cross_valves[xfeed_index].getChild("valve").setValue(setting);
}

									# Move requested fuel from tank[tank_index] to
									# buffer tank[engine_index]. Note that this system was devised
									# to return fuel amounts not delivered due to too little fuel in
									# tank, but this feature is not used due to simplified cross-feeding.
									
var transfer_fuel = func(engine_index, tank_index, request_lbs) {
  if (request_lbs == 0) { return 0 }
  request_gals = request_lbs / GALUSTOLBS;				# Have to work in gallons-- can't set lbs
  var buffer_gals = get_gals(engine_index);				# Fetch quantity in engine fuel buffer
  var tank_gals = get_gals(tank_index);					# Get amount of fuel in tank
  if (tank_gals == 0) { return request_lbs }				# If no fuel, return total fuel requested as unfilled
  if (tank_gals < request_gals) {					# Fuel exists, but not enough to fill request
    set_gals(engine_index,buffer_gals+tank_gals);			# Move what's left in tank
    set_gals(tank_index,0);						# Mark tank as empty
    return (request_gals-tank_gals)*GALUSTOLBS;				# Return unfilled fuel request in lbs
  }
  set_gals(engine_index,buffer_gals+request_gals);			# Transfer total request
  set_gals(tank_index,tank_gals-request_gals);				# Subtract request from tank
  return 0;								# Return, total fuel request filled, no remainder
}


									# Determine if a tank system can deliver the required fuel,
									# if so return the delivering tank's index (primary or secondary).
									# Note that for purposes of this helper function, tank 5 can be
									# considered a 'system', though it will never have a secondary tank.
var tank_status = func(tank_index,request_lbs) {
  if (tank_valves[tank_index-4].getChild("valve").getValue() == 0)	# Tank system off-line
    { return 0 }
  if (tank_valves[tank_index-4].getChild("valve").getValue() == 1) {	# Tank valve set to primary
    var tank_lbs = get_lbs(tank_index);
    if (tank_lbs < request_lbs)
      { return 0; }
    else
      { return tank_index; }
  }
  else {								# Tank valve set to secondary
									# Note: tank 5 should never have a secondary
    var tank_lbs = get_lbs(tank_index+5);
    if (tank_lbs < request_lbs)
      { return 0; }
    else
      { return tank_index+5; }
  }
  return 0;								# Should never see this
}


#
# Fuel preset functions:
#

									# This function is called when user chooses a
									# fuel preset from the 1049H dialog menu:
var preset_select = func {
  value = getprop("/systems/fuel/tanks/dialog-preset");			# Get name of preset selected via dialog
									# Look for preset that matches selection
  for(preset_index=0; preset_index<size(fuel_presets); preset_index+=1) {
    if(value == fuel_presets[preset_index].getChild("preset_name").getValue()) {
      preset_load(preset_index);					# Load preset fuel and valve settings
      setprop("/sim/presets/fuel",preset_index);			# Save user's choice for FG exit preferences save
      break;
    }
  }
}

									# Fetch a fuel configuration:
var preset_fetch = func {
  preset_index = getprop("/sim/presets/fuel");				# Try to get a preset selection from FG saved preferences
  if(preset_index == nil or
     preset_index < 0 or
     preset_index >= size(fuel_presets)) {
    preset_index = 0;							# If missing or invalid saved preset, default to preset 0
  }
									# Copy preset choice to 1049H dialog menu selection
  var dialog_preset = getprop("/systems/fuel/tanks/dialog-preset");
  if(dialog_preset == nil or dialog_preset == "") {			# Populate 1049H dialog menu fuel preset selection
    var preset_name = fuel_presets[preset_index].getChild("preset_name").getValue();
    setprop("/systems/fuel/tanks/dialog-preset", preset_name);
  }
  preset_load(preset_index);						# Load preset fuel and valve settings
}

									# Populate fuel and valve settings from a fuel preset:
var preset_load = func(preset_index) {
  preset_tanks  = fuel_presets[preset_index].getChildren("tank");		# Get preset's tank levels
  preset_valves = fuel_presets[preset_index].getChildren("tankvalves");		# Get preset's tank valve settings
  preset_xfeeds = fuel_presets[preset_index].getChildren("crossfeedvalves");	# Get preset's cross-feed valve settings
  for( i=0; i<size(preset_tanks); i=i+1 ) {					# For each preset tank i:
    var tank = preset_tanks[i].getChild("level-gal_us");
    if(tank != nil) { set_gals(i,tank.getValue()) }			# Set tank gallons to preset
    else	    { set_gals(i,get_capacity(i)) }			# Preset had no value, default to maximum
  } 
  for( i=0; i<size(preset_valves); i=i+1 ) {				# For each preset tank valve i:
    var valve = preset_valves[i].getChild("valve");
    if(valve != nil) { set_tank_valve(i,valve.getValue()) }		# Set tank valve to preset
    else {								# Preset had no value, use defaults:
      if(i < 4)	{ set_tank_valve(i,1) }					# Tanks 1-4 default to primary on
      else	{ set_tank_valve(i,0) }					# Other tanks default to off
    }
  } 
  for( i=0; i<size(preset_xfeeds); i=i+1 ) {				# For each preset cross-feed valve i:
    var valve = preset_xfeeds[i].getChild("valve");
    if(valve != nil) { set_xfeed_valve(i,valve.getValue()) }		# Set tank valve to preset
    else	     { set_xfeed_valve(i,0) }				# Preset had no value, defaults to off
  } 
}

##################################### jettison the tanks #################################################

setlistener("/controls/fuel/jettison[0]/valve", func(v) {
   var tank4 	= getprop("/consumables/fuel/tank[4]/level-lbs") or 0; 	# aussen links
   var tank5 	= getprop("/consumables/fuel/tank[5]/level-lbs") or 0; 	# innen links
   var tank8 	= getprop("/consumables/fuel/tank[8]/level-lbs") or 0; 	# mitte
   var tank10 = getprop("/consumables/fuel/tank[10]/level-lbs") or 0; # links
   
   setprop("sim/multiplay/generic/int[9]", 0);   # fuel-spray for multiplayer
   
		# stop jettison, if pilot push back the valve
		interpolate("/consumables/fuel/tank[4]/level-lbs", tank4, 0);   
		interpolate("/consumables/fuel/tank[5]/level-lbs", tank5, 0);        	
		interpolate("/consumables/fuel/tank[8]/level-lbs", tank8, 0); 
		interpolate("/consumables/fuel/tank[10]/level-lbs", tank10, 0);

    if(v.getValue() == 1){   
        	 
        if (tank4 > 3200){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[4]/level-lbs", 3000, 3);
       	}
       	if (tank5 > 2200){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[5]/level-lbs", 2000, 3);
       	}
       	if (tank8 > 2000){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[8]/level-lbs", 1800, 3);
       	}
       	if (tank10 > 1700){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[10]/level-lbs", 1500, 3);
       	}
       	
       	settimer( func{ setprop("sim/multiplay/generic/int[9]", 0);}, 3);
       	
    }elsif(v.getValue() == 2){
    		
    		if (tank4 > 1000){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[4]/level-lbs", 930, 2);
       	}
       	if (tank5 > 500){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[5]/level-lbs", 470, 2);
       	}
       	if (tank8 > 460){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[8]/level-lbs", 430, 2);
       	}
       	if (tank10 > 400){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[10]/level-lbs", 330, 2);
       	}
       	
       	settimer( func{ setprop("sim/multiplay/generic/int[9]", 0);}, 2);
       	
    }elsif(v.getValue() == 3){

    		if (tank4 > 220){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[4]/level-lbs", 200, 1);
       	}
       	if (tank5 > 220){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[5]/level-lbs", 200, 1);
       	}
       	if (tank8 > 220){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[8]/level-lbs", 200, 1);
       	}
       	if (tank10 > 220){
          setprop("sim/multiplay/generic/int[9]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[10]/level-lbs", 200, 1);
       	}
       	
       	settimer( func{ setprop("sim/multiplay/generic/int[9]", 0);}, 1);
       	
		}else{
        setprop("sim/multiplay/generic/int[9]", 0);   # fuel-spray for multiplayer
				interpolate("/consumables/fuel/tank[4]/level-lbs", tank4, 0);   
				interpolate("/consumables/fuel/tank[5]/level-lbs", tank5, 0);        	
				interpolate("/consumables/fuel/tank[8]/level-lbs", tank8, 0); 
				interpolate("/consumables/fuel/tank[10]/level-lbs", tank10, 0);
		}
}, 1, 0);


setlistener("/controls/fuel/jettison[1]/valve", func(v) {
   var tank6 	= getprop("/consumables/fuel/tank[6]/level-lbs") or 0; 	# innen rechts
   var tank7 	= getprop("/consumables/fuel/tank[7]/level-lbs") or 0; 	# aussen rechts
   var tank11 = getprop("/consumables/fuel/tank[11]/level-lbs") or 0; # rechts
   
   setprop("sim/multiplay/generic/int[10]", 0);   # fuel-spray for multiplayer
   
    if(v.getValue() == 1){       	 
	
        if (tank7 > 3200){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[7]/level-lbs", 3000, 3);
       	}
       	if (tank6 > 2200){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[6]/level-lbs", 2000, 3);
       	}
       	if (tank11 > 1700){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[11]/level-lbs", 1500, 3);
       	}
       	
       	settimer( func{ setprop("sim/multiplay/generic/int[10]", 0);}, 3);
       	
    }elsif(v.getValue() == 2){
    		
    		if (tank7 > 1000){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[7]/level-lbs", 930, 2);
       	}
       	if (tank6 > 500){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[6]/level-lbs", 470, 2);
       	}
       	if (tank11 > 400){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[11]/level-lbs", 330, 2);
       	}
       	
       	settimer( func{ setprop("sim/multiplay/generic/int[10]", 0);}, 2);
       	
    }elsif(v.getValue() == 3){

    		if (tank7 > 220){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[7]/level-lbs", 200, 1);
       	}
       	if (tank6 > 220){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[6]/level-lbs", 200, 1);
       	}
       	if (tank11 > 220){
          setprop("sim/multiplay/generic/int[10]", 1);   # fuel-spray for multiplayer
        	interpolate("/consumables/fuel/tank[11]/level-lbs", 200, 1);
       	}
       	
       	settimer( func{ setprop("sim/multiplay/generic/int[10]", 0);}, 1);
       	
		}else{
        setprop("sim/multiplay/generic/int[10]", 0);   # fuel-spray for multiplayer
				interpolate("/consumables/fuel/tank[7]/level-lbs", tank7, 0);   
				interpolate("/consumables/fuel/tank[6]/level-lbs", tank6, 0);  
				interpolate("/consumables/fuel/tank[11]/level-lbs", tank11, 0);
		}
}, 1, 0);


