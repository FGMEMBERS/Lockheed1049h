# Lockheed 1049H
#
# Custom 1049H routines for lighting support
#
# Gary Neely aka 'Buckaroo'


# Initialize timed beacon (anti-collision) lighting
# Uses an MP prop for the timed beacon functionality, though control is maintained
# via /controls/lighting/beacon prop.

beacon_switch = props.globals.getNode("sim/multiplay/generic/float[1]", 1);
beacon_switch.setBoolValue(0);
aircraft.light.new("sim/model/Lockheed1049H/lighting/beacon", [0.2, 2], beacon_switch);


# Handles for light control props:

var L1049H_LightNav	= props.globals.getNode("/controls/lighting/nav");
var L1049H_LightTail	= props.globals.getNode("/controls/lighting/tail");
var L1049H_LightTaxi	= props.globals.getNode("/controls/lighting/taxi");
var L1049H_LightLL	= props.globals.getNode("/controls/lighting/landing-left");
var L1049H_LightLR	= props.globals.getNode("/controls/lighting/landing-right");
var L1049H_LightLXL	= props.globals.getNode("/controls/lighting/landing-extend-left");
var L1049H_LightLXR	= props.globals.getNode("/controls/lighting/landing-extend-right");
var L1049H_LightCabin	= props.globals.getNode("/controls/lighting/cabin");
var L1049H_LightBeacon	= props.globals.getNode("/controls/lighting/beacon");

var L1049H_BeaconState	= props.globals.getNode("sim/model/Lockheed1049H/lighting/beacon/state[0]");

# Handles for light MP props:

var L1049H_MPNav	= props.globals.getNode("/sim/multiplay/generic/int[0]");
var L1049H_MPTail	= props.globals.getNode("/sim/multiplay/generic/int[1]");
var L1049H_MPTaxi	= props.globals.getNode("/sim/multiplay/generic/int[2]");
var L1049H_MPLL		= props.globals.getNode("/sim/multiplay/generic/int[3]");
var L1049H_MPLR		= props.globals.getNode("/sim/multiplay/generic/int[4]");
var L1049H_MPLXL	= props.globals.getNode("/sim/multiplay/generic/int[5]");
var L1049H_MPLXR	= props.globals.getNode("/sim/multiplay/generic/int[6]");
var L1049H_MPCabin	= props.globals.getNode("/sim/multiplay/generic/float[0]");
var L1049H_MPBeacon	= props.globals.getNode("/sim/multiplay/generic/float[1]");
var L1049H_MPBeaconState= props.globals.getNode("/sim/multiplay/generic/float[2]");

# Echo lighting settings to properties that will be passed over Multiplayer,
# Make sure values expected to be integers really are integers.

setlistener(L1049H_LightNav, func {
  if (L1049H_LightNav.getValue() > 0)	{ L1049H_MPNav.setValue(1) }
  else					{ L1049H_MPNav.setValue(0) }
});
setlistener(L1049H_LightTail, func {
  if (L1049H_LightTail.getValue() > 0)	{ L1049H_MPTail.setValue(1) }
  else					{ L1049H_MPTail.setValue(0) }
});
setlistener(L1049H_LightTaxi, func {
  if (L1049H_LightTaxi.getValue() > 0)	{ L1049H_MPTaxi.setValue(1) }
  else					{ L1049H_MPTaxi.setValue(0) }
});
setlistener(L1049H_LightLL, func {
  if (L1049H_LightLL.getValue() > 0)	{ L1049H_MPLL.setValue(1) }
  else					{ L1049H_MPLL.setValue(0) }
});
setlistener(L1049H_LightLR, func {
  if (L1049H_LightLR.getValue() > 0)	{ L1049H_MPLR.setValue(1) }
  else					{ L1049H_MPLR.setValue(0) }
});
setlistener(L1049H_LightLXL, func {
  if (L1049H_LightLXL.getValue() > 0)	{ L1049H_MPLXL.setValue(1) }
  else					{ L1049H_MPLXL.setValue(0) }
});
setlistener(L1049H_LightLXR, func {
  if (L1049H_LightLXR.getValue() > 0)	{ L1049H_MPLXR.setValue(1) }
  else					{ L1049H_MPLXR.setValue(0) }
});
setlistener(L1049H_LightCabin, func {
  L1049H_MPCabin.setValue(L1049H_LightCabin.getValue())
});
setlistener(L1049H_LightBeacon, func {
  if (L1049H_LightBeacon.getValue() > 0)	{ L1049H_MPBeacon.setValue(1) }
  else						{ L1049H_MPBeacon.setValue(0) }
});
setlistener(L1049H_BeaconState, func {
  if (L1049H_BeaconState.getValue() > 0)	{ L1049H_MPBeaconState.setValue(1) }
  else						{ L1049H_MPBeaconState.setValue(0) }
});

# the fire-warning blink
var fire_prop = func(){
  var fw = props.globals.getNode("/controls/special/fire-warning", 1);
  if(fw.getValue() == 1){
  		fw.setValue(0);
  }else{
  		fw.setValue(1);
  }
  settimer(fire_prop, 0.5);
}

fire_prop();

# Ordinance Signs

var command_bell = "controls/switches/command-bell";
var no_smoking = "controls/switches/no-smoking-signs";
var seat_belts = "controls/switches/seat-belt-signs";

var ring_command_bell = func 
{
    setprop(command_bell, 1);
    settimer(func {setprop(command_bell, 0);}, 1.0);
}

setlistener(no_smoking, func {
    ring_command_bell();
}, startup = 0, runtime = 0);

setlistener(seat_belts, func {
    ring_command_bell();
}, startup = 0, runtime = 0);

