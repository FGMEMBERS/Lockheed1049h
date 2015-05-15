###############################################################################
##  Nasal for dual control of the Common-Spruce CS 1 over the multiplayer network.
##
##  Copyright (C) 2007 - 2008  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license version 2 or later.
##
##  For the CS 1, written in January 2012 by Marc Kraus
##
###############################################################################

## Renaming (almost :)
var DCT = dual_control_tools;

## Pilot/copilot aircraft identifiers. Used by dual_control.
var pilot_type   = "Aircraft/Lockheed1049h/Models/Lockheed1049h.xml";
var copilot_type = "Aircraft/Lockheed1049h/Models/L1049h-Copilot.xml";

############################ PROPERTIES MP ###########################

#####
# pilot properties

var rpm              = ["engines/engine/rpm", 
                        "engines/engine[1]/rpm", 
                        "engines/engine[2]/rpm", 
                        "engines/engine[3]/rpm"];

# for the Sound
var gear              = ["gear/gear[0]/position-norm", 
                         "gear/gear[1]/position-norm", 
                         "gear/gear[2]/position-norm"];

var flap             = "surface-positions/flap-pos-norm";

var lights_mpp       = "sim/multiplay/generic/int[7]";
var TDM_mpp1         = "sim/multiplay/generic/string[0]";
var TDM_mpp2         = "sim/multiplay/generic/string[1]";
var TDM_mpp3         = "sim/multiplay/generic/string[2]";


######################################################################
# Useful instrument related property paths.

# Engine controls
var magnetos_cmd      = ["controls/engines/engine/magnetos", 
                         "controls/engines/engine[1]/magnetos", 
                         "controls/engines/engine[2]/magnetos", 
                         "controls/engines/engine[3]/magnetos"];

var volt_dc_cmd       = "controls/switches/volts-select-dc";
var batt_cart         = "controls/switches/battery-cart";
var batt_ship         = "controls/switches/battery-ship";
var eng_start         = "controls/switches/engine-start-select";
var gen_apu           = "controls/switches/gen-apu";
var gen_cmd           = ["controls/switches/generator/position", 
                         "controls/switches/generator[1]/position", 
                         "controls/switches/generator[2]/position", 
                         "controls/switches/generator[3]/position"];

var bmep_cmd          = ["engines/engine/bmep", 
                         "engines/engine[1]/bmep", 
                         "engines/engine[2]/bmep", 
                         "engines/engine[3]/bmep",
                         "engines/engine/mp-osi", 
                         "engines/engine[1]/mp-osi", 
                         "engines/engine[2]/mp-osi", 
                         "engines/engine[3]/mp-osi"];

var mixture_cmd       = ["controls/engines/engine/mixture", 
                         "controls/engines/engine[1]/mixture", 
                         "controls/engines/engine[2]/mixture", 
                         "controls/engines/engine[3]/mixture"];

var throttle_cmd      = ["controls/engines/engine/throttle", 
                         "controls/engines/engine[1]/throttle", 
                         "controls/engines/engine[2]/throttle", 
                         "controls/engines/engine[3]/throttle"];

# Sound
var gear_cmd          = ["gear/gear[0]/position-norm", 
                         "gear/gear[1]/position-norm", 
                         "gear/gear[2]/position-norm"];

var door_cmd          = "controls/door-crew/position-norm";

# Other controls
var comm_cmd          = ["instrumentation/comm/frequencies/selected-mhz", 
                         "instrumentation/comm/frequencies/standby-mhz",
                         "instrumentation/comm[1]/frequencies/selected-mhz", 
                         "instrumentation/comm[1]/frequencies/standby-mhz"];

var nav_cmd           = ["instrumentation/nav[0]/frequencies/selected-mhz", 
                         "instrumentation/nav[0]/frequencies/standby-mhz",
                         "instrumentation/nav[1]/frequencies/selected-mhz", 
                         "instrumentation/nav[1]/frequencies/standby-mhz"];

var adf_cmd           = ["instrumentation/adf/frequencies/selected-khz",
                         "instrumentation/adf/frequencies/standby-khz",
                         "instrumentation/adf[1]/frequencies/selected-khz", 
                         "instrumentation/adf[1]/frequencies/standby-khz"];

var tank_cmd          = ["consumables/fuel/tank/level-gal_us", 
                         "consumables/fuel/tank[1]/level-gal_us", 
                         "consumables/fuel/tank[2]/level-gal_us", 
                         "consumables/fuel/tank[3]/level-gal_us",
                         "consumables/fuel/tank[4]/level-gal_us", 
                         "consumables/fuel/tank[5]/level-gal_us", 
                         "consumables/fuel/tank[6]/level-gal_us", 
                         "consumables/fuel/tank[7]/level-gal_us", 
                         "consumables/fuel/tank[8]/level-gal_us", 
                         "consumables/fuel/tank[9]/level-gal_us", 
                         "consumables/fuel/tank[10]/level-gal_us", 
                         "consumables/fuel/tank[11]/level-gal_us"];

var light_cmd         = ["controls/lighting/panel-norm", 
                         "controls/lighting/chart", 
                         "controls/lighting/cabin"];

# ACHTUNG: bei naechster Gelegenheit die doppelte setting-inhg rausnehmen  +++++   :-)))))))))))))))

var instr_cmd         = ["instrumentation/nav[0]/radials/selected-deg",
                         "instrumentation/nav[1]/radials/selected-deg",
                         "instrumentation/altimeter/setting-inhg", 
                         "instrumentation/heading-indicator/offset-deg",
                         "instrumentation/altimeter/setting-inhg",
                         "autopilot/settings/target-speed-kt", 
                         "autopilot/settings/target-pitch-deg", 
                         "autopilot/settings/target-altitude-ft", 
                         "autopilot/settings/vertical-speed-fpm",
                         "autopilot/settings/heading-bug-deg"];


var agl_cmd           = ["position/gear-agl-ft", "position/gear-agl-ft"];

var batt_switch       = "controls/electric/battery-switch";
var nav_lights        = "controls/lighting/nav";
var tail_lights       = "controls/lighting/tail";
var beacon_lights     = "controls/lighting/beacon";
var taxi_lights       = "controls/lighting/taxi";
var battery_cart      = "controls/switches/battery-cart";
var battery_ship      = "controls/switches/battery-ship";
var gen_apu           = "controls/switches/gen-apu";

# Boolean properties
var running        = ["engines/engine[0]/running", 
                      "engines/engine[1]/running", 
                      "engines/engine[2]/running", 
                      "engines/engine[3]/running"];
var cranking       = ["engines/engine[0]/cranking", 
                      "engines/engine[1]/cranking", 
                      "engines/engine[2]/cranking", 
                      "engines/engine[3]/cranking"];

var brake_parking   = "controls/gear/brake-parking";

var reverser        = ["controls/engines/engine[0]/reverser", 
                      "controls/engines/engine[1]/reverser", 
                      "controls/engines/engine[2]/reverser", 
                      "controls/engines/engine[3]/reverser"];

var reverser_allow  = "controls/engines/reverser_allow";

var ap_switch      = ["autopilot/switches/alt",
                      "autopilot/switches/ap",
                      "autopilot/switches/selected-nav"];

var l_dual_control    = "dual-control/active";

######################################################################
###### Used by dual_control to set up the mappings for the pilot #####
######################## PILOT TO COPILOT ############################
######################################################################

var pilot_connect_copilot = func (copilot) {
  # Make sure dual-control is activated in the FDM FCS.
  print("Pilot section");
  setprop(l_dual_control, 1);

  return [
      ##################################################
      # Map copilot properties to buffer properties

      # copilot to pilot

      DCT.TDMEncoder.new
        ([
          props.globals.getNode(magnetos_cmd[0]),
          props.globals.getNode(magnetos_cmd[1]),
          props.globals.getNode(magnetos_cmd[2]),
          props.globals.getNode(magnetos_cmd[3]),
          props.globals.getNode(volt_dc_cmd),
          props.globals.getNode(batt_cart),
          props.globals.getNode(batt_ship),
          props.globals.getNode(eng_start),
          props.globals.getNode(gen_apu),
          props.globals.getNode(nav_cmd[0]),
          props.globals.getNode(nav_cmd[1]),
          props.globals.getNode(nav_cmd[2]),
          props.globals.getNode(nav_cmd[3]),
          props.globals.getNode(comm_cmd[0]),
          props.globals.getNode(comm_cmd[1]),
          props.globals.getNode(comm_cmd[2]),
          props.globals.getNode(comm_cmd[3]),
          props.globals.getNode(adf_cmd[0]),
          props.globals.getNode(adf_cmd[1]),
          props.globals.getNode(adf_cmd[2]),
          props.globals.getNode(adf_cmd[3]),
          props.globals.getNode(instr_cmd[0]),
          props.globals.getNode(instr_cmd[1]),
          props.globals.getNode(instr_cmd[2]),
          props.globals.getNode(instr_cmd[3]),
          props.globals.getNode(instr_cmd[4]),
          props.globals.getNode(instr_cmd[5]),
          props.globals.getNode(instr_cmd[6]),
          props.globals.getNode(instr_cmd[7]),
          props.globals.getNode(instr_cmd[8]),
          props.globals.getNode(instr_cmd[9]),
         ], props.globals.getNode(TDM_mpp1)),      
      DCT.TDMEncoder.new
        ([
          props.globals.getNode(light_cmd[0]),
          props.globals.getNode(light_cmd[1]),
          props.globals.getNode(light_cmd[2]),
          props.globals.getNode(gen_cmd[0]),
          props.globals.getNode(gen_cmd[1]),
          props.globals.getNode(gen_cmd[2]),
          props.globals.getNode(gen_cmd[3]),
          props.globals.getNode(tank_cmd[0]),
          props.globals.getNode(tank_cmd[1]),
          props.globals.getNode(tank_cmd[2]),
          props.globals.getNode(tank_cmd[3]),
          props.globals.getNode(tank_cmd[4]),
          props.globals.getNode(tank_cmd[5]),
          props.globals.getNode(tank_cmd[6]),
          props.globals.getNode(tank_cmd[7]),
          props.globals.getNode(tank_cmd[8]),
          props.globals.getNode(tank_cmd[9]),
          props.globals.getNode(tank_cmd[10]),
          props.globals.getNode(tank_cmd[11]),
          props.globals.getNode(bmep_cmd[0]),
          props.globals.getNode(bmep_cmd[1]),
          props.globals.getNode(bmep_cmd[2]),
          props.globals.getNode(bmep_cmd[3]),
          props.globals.getNode(bmep_cmd[4]),
          props.globals.getNode(bmep_cmd[5]),
          props.globals.getNode(bmep_cmd[6]),
          props.globals.getNode(bmep_cmd[7]),
          props.globals.getNode(agl_cmd[0]),
          props.globals.getNode(agl_cmd[1])
         ], props.globals.getNode(TDM_mpp2)),
      DCT.TDMEncoder.new
        ([
          props.globals.getNode(mixture_cmd[0]),
          props.globals.getNode(mixture_cmd[1]),
          props.globals.getNode(mixture_cmd[2]),
          props.globals.getNode(mixture_cmd[3]),
          props.globals.getNode(throttle_cmd[0]),
          props.globals.getNode(throttle_cmd[1]),
          props.globals.getNode(throttle_cmd[2]),
          props.globals.getNode(throttle_cmd[3]),
          props.globals.getNode(door_cmd)
         ], props.globals.getNode(TDM_mpp3)),
      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(batt_switch),
          props.globals.getNode(nav_lights),
          props.globals.getNode(tail_lights),
          props.globals.getNode(beacon_lights),
          props.globals.getNode(taxi_lights),
          props.globals.getNode(running[0]),
          props.globals.getNode(running[1]),
          props.globals.getNode(running[2]),
          props.globals.getNode(running[3]),
          props.globals.getNode(cranking[0]),
          props.globals.getNode(cranking[1]),
          props.globals.getNode(cranking[2]),
          props.globals.getNode(cranking[3]),
          props.globals.getNode(reverser[0]),
          props.globals.getNode(reverser[1]),
          props.globals.getNode(reverser[2]),
          props.globals.getNode(reverser[3]),
          props.globals.getNode(ap_switch[0]),
          props.globals.getNode(ap_switch[1]),
          props.globals.getNode(ap_switch[2]),
          props.globals.getNode(reverser_allow),
          props.globals.getNode(brake_parking)
         ], props.globals.getNode(lights_mpp)),

  ];
}

##############
var pilot_disconnect_copilot = func {
  setprop(l_dual_control, 0);
}

######################################################################
##### Used by dual_control to set up the mappings for the copilot ####
######################## COPILOT TO PILOT ############################
######################################################################

var copilot_connect_pilot = func (pilot) {
  # Make sure dual-control is activated in the FDM FCS.
  print("Copilot section");
  setprop(l_dual_control, 1);

  return [

      ##################################################
      # Map pilot properties to buffer properties

      DCT.Translator.new(pilot.getNode(rpm[0]), props.globals.getNode(rpm[0], 1)),
      DCT.Translator.new(pilot.getNode(rpm[1]), props.globals.getNode(rpm[1], 1)),
      DCT.Translator.new(pilot.getNode(rpm[2]), props.globals.getNode(rpm[2], 1)),
      DCT.Translator.new(pilot.getNode(rpm[3]), props.globals.getNode(rpm[3], 1)),
      DCT.Translator.new(pilot.getNode(gear[0]), props.globals.getNode(gear[0], 1)),
      DCT.Translator.new(pilot.getNode(gear[1]), props.globals.getNode(gear[1], 1)),
      DCT.Translator.new(pilot.getNode(gear[2]), props.globals.getNode(gear[2], 1)),
      DCT.Translator.new(pilot.getNode(flap), props.globals.getNode(flap, 1)),

      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[8]"),
                         props.globals.getNode("/controls/flight/elevator", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[9]"),
                         props.globals.getNode("/controls/flight/aileron", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[10]"),
                         props.globals.getNode("/controls/flight/rudder", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[11]"),
                         props.globals.getNode("/instrumentation/slip-skid-ball/indicated-slip-skid", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[12]"),
                         props.globals.getNode("/instrumentation/turn-indicator/indicated-turn-rate", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[13]"),
                         props.globals.getNode("/controls/flight/elevator-trim", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[14]"),
                         props.globals.getNode("/controls/flight/aileron-trim", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[15]"),
                         props.globals.getNode("/controls/flight/rudder-trim", 1)),



      ##################################################
      # Map pilot properties to buffer properties
      DCT.TDMDecoder.new
        (pilot.getNode(TDM_mpp1), 
        [func(v){pilot.getNode(magnetos_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~magnetos_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(magnetos_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~magnetos_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(magnetos_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~magnetos_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(magnetos_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~magnetos_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(volt_dc_cmd, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~volt_dc_cmd, 1).setValue(v);},
         func(v){pilot.getNode(batt_cart, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~batt_cart, 1).setValue(v);},
         func(v){pilot.getNode(batt_ship, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~batt_ship, 1).setValue(v);},
         func(v){pilot.getNode(eng_start, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~eng_start, 1).setValue(v);},
         func(v){pilot.getNode(gen_apu, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~gen_apu, 1).setValue(v);},
         func(v){pilot.getNode(nav_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(nav_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(nav_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(nav_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(comm_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(comm_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(comm_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(comm_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(adf_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(adf_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(adf_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(adf_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[4], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[4], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[5], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[5], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[6], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[6], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[7], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[7], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[8], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[8], 1).setValue(v);},
         func(v){pilot.getNode(instr_cmd[9], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~instr_cmd[9], 1).setValue(v);},
        ]),

      DCT.TDMDecoder.new
        (pilot.getNode(TDM_mpp2), 
        [func(v){pilot.getNode(light_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~light_cmd[0], 1).setValue(v);},
        func(v){pilot.getNode(light_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~light_cmd[1], 1).setValue(v);},
        func(v){pilot.getNode(light_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~light_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(gen_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~gen_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(gen_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~gen_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(gen_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~gen_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(gen_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~gen_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[4], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[4], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[5], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[5], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[6], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[6], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[7], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[7], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[8], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[8], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[9], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[9], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[10], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[10], 1).setValue(v);},
         func(v){pilot.getNode(tank_cmd[11], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank_cmd[11], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[4], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[4], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[5], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[5], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[6], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[6], 1).setValue(v);},
         func(v){pilot.getNode(bmep_cmd[7], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~bmep_cmd[7], 1).setValue(v);},
         func(v){pilot.getNode(agl_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~agl_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(agl_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~agl_cmd[1], 1).setValue(v);},
        ]),

      DCT.TDMDecoder.new
        (pilot.getNode(TDM_mpp3), 
        [
         func(v){pilot.getNode(mixture_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~mixture_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(mixture_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~mixture_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(mixture_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~mixture_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(mixture_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~mixture_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(throttle_cmd[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~throttle_cmd[0], 1).setValue(v);},
         func(v){pilot.getNode(throttle_cmd[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~throttle_cmd[1], 1).setValue(v);},
         func(v){pilot.getNode(throttle_cmd[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~throttle_cmd[2], 1).setValue(v);},
         func(v){pilot.getNode(throttle_cmd[3], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~throttle_cmd[3], 1).setValue(v);},
         func(v){pilot.getNode(door_cmd, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~door_cmd, 1).setValue(v);},
        ]),

      DCT.SwitchDecoder.new
        (pilot.getNode(lights_mpp),
        [func(b){props.globals.getNode(batt_switch).setValue(b);},
         func(b){props.globals.getNode(nav_lights).setValue(b);},
         func(b){props.globals.getNode(tail_lights).setValue(b);},
         func(b){props.globals.getNode(beacon_lights).setValue(b);},
         func(b){props.globals.getNode(taxi_lights).setValue(b);},
         func(b){props.globals.getNode(running[0]).setValue(b);},
         func(b){props.globals.getNode(running[1]).setValue(b);},
         func(b){props.globals.getNode(running[2]).setValue(b);},
         func(b){props.globals.getNode(running[3]).setValue(b);},
         func(b){props.globals.getNode(cranking[0]).setValue(b);},
         func(b){props.globals.getNode(cranking[1]).setValue(b);},
         func(b){props.globals.getNode(cranking[2]).setValue(b);},
         func(b){props.globals.getNode(cranking[3]).setValue(b);},
         func(b){props.globals.getNode(reverser[0]).setValue(b);},
         func(b){props.globals.getNode(reverser[1]).setValue(b);},
         func(b){props.globals.getNode(reverser[2]).setValue(b);},
         func(b){props.globals.getNode(reverser[3]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[0]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[1]).setValue(b);},
         func(b){props.globals.getNode(ap_switch[2]).setValue(b);},
         func(b){props.globals.getNode(reverser_allow).setValue(b);},
         func(b){props.globals.getNode(brake_parking).setValue(b);},
        ]),

      ##################################################
      # Animation of the knobs and more
      
      # copilot to pilot

      # lights_mpp
      DCT.Translator.new(props.globals.getNode(batt_switch, 1), pilot.getNode("/"~batt_switch)),
      DCT.Translator.new(props.globals.getNode(nav_lights, 1), pilot.getNode("/"~nav_lights)),
      DCT.Translator.new(props.globals.getNode(tail_lights, 1), pilot.getNode("/"~tail_lights)),
      DCT.Translator.new(props.globals.getNode(beacon_lights, 1), pilot.getNode("/"~beacon_lights)),
      DCT.Translator.new(props.globals.getNode(taxi_lights, 1), pilot.getNode("/"~taxi_lights)),
      DCT.Translator.new(props.globals.getNode(running[0], 1), pilot.getNode("/"~running[0])),
      DCT.Translator.new(props.globals.getNode(running[1], 1), pilot.getNode("/"~running[1])),
      DCT.Translator.new(props.globals.getNode(running[2], 1), pilot.getNode("/"~running[2])),
      DCT.Translator.new(props.globals.getNode(running[3], 1), pilot.getNode("/"~running[3])),
      DCT.Translator.new(props.globals.getNode(cranking[0], 1), pilot.getNode("/"~cranking[0])),
      DCT.Translator.new(props.globals.getNode(cranking[1], 1), pilot.getNode("/"~cranking[1])),
      DCT.Translator.new(props.globals.getNode(cranking[2], 1), pilot.getNode("/"~cranking[2])),
      DCT.Translator.new(props.globals.getNode(cranking[3], 1), pilot.getNode("/"~cranking[3])),
      DCT.Translator.new(props.globals.getNode(reverser[0], 1), pilot.getNode("/"~reverser[0])),
      DCT.Translator.new(props.globals.getNode(reverser[1], 1), pilot.getNode("/"~reverser[1])),
      DCT.Translator.new(props.globals.getNode(reverser[2], 1), pilot.getNode("/"~reverser[2])),
      DCT.Translator.new(props.globals.getNode(reverser[3], 1), pilot.getNode("/"~reverser[3])),
      DCT.Translator.new(props.globals.getNode(ap_switch[0], 1), pilot.getNode("/"~ap_switch[0])),
      DCT.Translator.new(props.globals.getNode(ap_switch[1], 1), pilot.getNode("/"~ap_switch[1])),
      DCT.Translator.new(props.globals.getNode(ap_switch[2], 1), pilot.getNode("/"~ap_switch[2])),
      DCT.Translator.new(props.globals.getNode(reverser_allow, 1), pilot.getNode("/"~reverser_allow)),
      DCT.Translator.new(props.globals.getNode(brake_parking, 1), pilot.getNode("/"~brake_parking)),
      # TDM_mpp1
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~magnetos_cmd[0], 1), props.globals.getNode(magnetos_cmd[0]), props.globals.getNode(magnetos_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~magnetos_cmd[1], 1), props.globals.getNode(magnetos_cmd[1]), props.globals.getNode(magnetos_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~magnetos_cmd[2], 1), props.globals.getNode(magnetos_cmd[2]), props.globals.getNode(magnetos_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~magnetos_cmd[3], 1), props.globals.getNode(magnetos_cmd[3]), props.globals.getNode(magnetos_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~volt_dc_cmd, 1), props.globals.getNode(volt_dc_cmd), props.globals.getNode(volt_dc_cmd), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~batt_cart, 1), props.globals.getNode(batt_cart), props.globals.getNode(batt_cart), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~batt_ship, 1), props.globals.getNode(batt_ship), props.globals.getNode(batt_ship), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~eng_start, 1), props.globals.getNode(eng_start), props.globals.getNode(eng_start), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~gen_apu, 1), props.globals.getNode(gen_apu), props.globals.getNode(gen_apu), 0.1),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav_cmd[0], 1), props.globals.getNode(nav_cmd[0]), props.globals.getNode(nav_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav_cmd[1], 1), props.globals.getNode(nav_cmd[1]), props.globals.getNode(nav_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav_cmd[2], 1), props.globals.getNode(nav_cmd[2]), props.globals.getNode(nav_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav_cmd[3], 1), props.globals.getNode(nav_cmd[3]), props.globals.getNode(nav_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm_cmd[0], 1), props.globals.getNode(comm_cmd[0]), props.globals.getNode(comm_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm_cmd[1], 1), props.globals.getNode(comm_cmd[1]), props.globals.getNode(comm_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm_cmd[2], 1), props.globals.getNode(comm_cmd[2]), props.globals.getNode(comm_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm_cmd[3], 1), props.globals.getNode(comm_cmd[3]), props.globals.getNode(comm_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf_cmd[0], 1), props.globals.getNode(adf_cmd[0]), props.globals.getNode(adf_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf_cmd[1], 1), props.globals.getNode(adf_cmd[1]), props.globals.getNode(adf_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf_cmd[2], 1), props.globals.getNode(adf_cmd[2]), props.globals.getNode(adf_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf_cmd[3], 1), props.globals.getNode(adf_cmd[3]), props.globals.getNode(adf_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[0], 1), props.globals.getNode(instr_cmd[0]), props.globals.getNode(instr_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[1], 1), props.globals.getNode(instr_cmd[1]), props.globals.getNode(instr_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[2], 1), props.globals.getNode(instr_cmd[2]), props.globals.getNode(instr_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[3], 1), props.globals.getNode(instr_cmd[3]), props.globals.getNode(instr_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[4], 1), props.globals.getNode(instr_cmd[4]), props.globals.getNode(instr_cmd[4]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[5], 1), props.globals.getNode(instr_cmd[5]), props.globals.getNode(instr_cmd[5]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[6], 1), props.globals.getNode(instr_cmd[6]), props.globals.getNode(instr_cmd[6]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[7], 1), props.globals.getNode(instr_cmd[7]), props.globals.getNode(instr_cmd[7]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[8], 1), props.globals.getNode(instr_cmd[8]), props.globals.getNode(instr_cmd[8]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~instr_cmd[9], 1), props.globals.getNode(instr_cmd[9]), props.globals.getNode(instr_cmd[9]), 0.01),
      # TDM_mpp2
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~light_cmd[0], 1), props.globals.getNode(light_cmd[0]), props.globals.getNode(light_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~light_cmd[1], 1), props.globals.getNode(light_cmd[1]), props.globals.getNode(light_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~light_cmd[2], 1), props.globals.getNode(light_cmd[2]), props.globals.getNode(light_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~gen_cmd[0], 1), props.globals.getNode(gen_cmd[0]), props.globals.getNode(gen_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~gen_cmd[1], 1), props.globals.getNode(gen_cmd[1]), props.globals.getNode(gen_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~gen_cmd[2], 1), props.globals.getNode(gen_cmd[2]), props.globals.getNode(gen_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~gen_cmd[3], 1), props.globals.getNode(gen_cmd[3]), props.globals.getNode(gen_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[0], 1), props.globals.getNode(tank_cmd[0]), props.globals.getNode(tank_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[1], 1), props.globals.getNode(tank_cmd[1]), props.globals.getNode(tank_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[2], 1), props.globals.getNode(tank_cmd[2]), props.globals.getNode(tank_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[3], 1), props.globals.getNode(tank_cmd[3]), props.globals.getNode(tank_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[4], 1), props.globals.getNode(tank_cmd[4]), props.globals.getNode(tank_cmd[4]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[5], 1), props.globals.getNode(tank_cmd[5]), props.globals.getNode(tank_cmd[5]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[6], 1), props.globals.getNode(tank_cmd[6]), props.globals.getNode(tank_cmd[6]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[7], 1), props.globals.getNode(tank_cmd[7]), props.globals.getNode(tank_cmd[7]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[8], 1), props.globals.getNode(tank_cmd[8]), props.globals.getNode(tank_cmd[8]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[9], 1), props.globals.getNode(tank_cmd[9]), props.globals.getNode(tank_cmd[9]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[10], 1), props.globals.getNode(tank_cmd[10]), props.globals.getNode(tank_cmd[10]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank_cmd[11], 1), props.globals.getNode(tank_cmd[11]), props.globals.getNode(tank_cmd[11]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[0], 1), props.globals.getNode(bmep_cmd[0]), props.globals.getNode(bmep_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[1], 1), props.globals.getNode(bmep_cmd[1]), props.globals.getNode(bmep_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[2], 1), props.globals.getNode(bmep_cmd[2]), props.globals.getNode(bmep_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[3], 1), props.globals.getNode(bmep_cmd[3]), props.globals.getNode(bmep_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[4], 1), props.globals.getNode(bmep_cmd[4]), props.globals.getNode(bmep_cmd[4]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[5], 1), props.globals.getNode(bmep_cmd[5]), props.globals.getNode(bmep_cmd[5]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[6], 1), props.globals.getNode(bmep_cmd[6]), props.globals.getNode(bmep_cmd[6]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~bmep_cmd[7], 1), props.globals.getNode(bmep_cmd[7]), props.globals.getNode(bmep_cmd[7]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~agl_cmd[0], 1), props.globals.getNode(agl_cmd[0]), props.globals.getNode(agl_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~agl_cmd[1], 1), props.globals.getNode(agl_cmd[1]), props.globals.getNode(agl_cmd[1]), 0.01),
      # TDM_mpp3
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~mixture_cmd[0], 1), props.globals.getNode(mixture_cmd[0]), props.globals.getNode(mixture_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~mixture_cmd[1], 1), props.globals.getNode(mixture_cmd[1]), props.globals.getNode(mixture_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~mixture_cmd[2], 1), props.globals.getNode(mixture_cmd[2]), props.globals.getNode(mixture_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~mixture_cmd[3], 1), props.globals.getNode(mixture_cmd[3]), props.globals.getNode(mixture_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~throttle_cmd[0], 1), props.globals.getNode(throttle_cmd[0]), props.globals.getNode(throttle_cmd[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~throttle_cmd[1], 1), props.globals.getNode(throttle_cmd[1]), props.globals.getNode(throttle_cmd[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~throttle_cmd[2], 1), props.globals.getNode(throttle_cmd[2]), props.globals.getNode(throttle_cmd[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~throttle_cmd[3], 1), props.globals.getNode(throttle_cmd[3]), props.globals.getNode(throttle_cmd[3]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~door_cmd, 1), props.globals.getNode(door_cmd), props.globals.getNode(door_cmd), 0.01),
  ];

}

var copilot_disconnect_pilot = func {
  setprop(l_dual_control, 0);
}
