# Lockheed 1049H Constellation
#
# Miscellaneous instrumentation support
#
# Gary Neely aka 'Buckaroo'


								# Manages the operation of the Autopilot light.
								# If any AP functions active, sets ap-warn, which
								# drives the light animation.

var UPDATE_PERIOD	= 1;					# How often to update in seconds (0 = framerate)

var ap_hdg	= props.globals.getNode("/autopilot/locks/heading",1);
var ap_alt	= props.globals.getNode("/autopilot/locks/altitude",1);
var ap_spd	= props.globals.getNode("/autopilot/locks/speed",1);
var ap_warn	= props.globals.getNode("/systems/autopilot/ap-warn",1);


var update_apwarn = func {
  if (ap_hdg.getType() == "STRING") {				# Check if values initialized
    if (size(ap_hdg.getValue()) > 0 or size(ap_alt.getValue()) > 0 or size(ap_spd.getValue()) > 0)
      { ap_warn.setValue(1); }
    else { ap_warn.setValue(0); }
  }

  settimer(update_apwarn, UPDATE_PERIOD);
}

settimer(update_apwarn, 2);					# Delay startup a bit to allow things to initialize
