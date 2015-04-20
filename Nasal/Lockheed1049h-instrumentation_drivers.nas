# Lockheed 1049H Constellation
#
# Instrumentation and Related Drivers
#
# Code by Gary Neely aka 'Buckaroo' except as otherwise noted
#
# Support for backup Attitude Indicators
# Support for Autopilot Active indicator
# Switch throw animation support
# Support for nav freq decimal digits
#



#
# Support for the backup Attitude Indicators
#
# The backup AI presumably relies on either vacuum or electrically powered gyros which must
# be kept spinning to function. Some part of FG decrements the spin value, and some part
# increments it, but it seems to rely on an engine #1 setting (RPM) that is not reliable or perhaps
# reasonable in the case of YASim jet engine models. Therefore I power it here by updating it
# every 5 seconds if the dc bus is active. In time this might become part of the electrical system.
#

var bus_dc	= props.globals.getNode("/systems/electrical/bus-dc");
var ai_spin	= props.globals.getNode("/instrumentation/attitude-indicator/spin");

var update_ai = func {
  if (bus_dc.getNode("volts").getValue() > 23) {
    #ai_spin.setValue(1);
    interpolate(ai_spin, 1, 9);					# Spin up the backup AI gyro
  }
  settimer(update_ai, 10);
}



#
# Manages the operation of the Autopilot light.
# If any AP functions active (the lock has some non-zero-length string value), set ap-warn,
# which drives the light animation.
#

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



#
# A little setup for simulating short switch throws:
#
var switch_ani = func(i,j) {
  setprop("/systems/switch-throw["~i~"]/value",j);
  # Switch resets after 0.5 secs
  settimer(func { setprop("/systems/switch-throw["~i~"]/value",0); },
           0.5);
}

#
# Round-off errors screw-up the textranslate animation used to display digits. This is a problem
# for the NAV and COMM freq display. This seems to affect only decimal place digits. So here I'm using
# a listener to copy the MHz and KHz portions of a freq string to a separate integer values
# that are used by the animations.
#

var nav1selstr	= props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz-fmt");
var nav1selmhz	= props.globals.getNode("/instrumentation/nav[0]/frequencies/display-sel-mhz");
var nav1selkhz	= props.globals.getNode("/instrumentation/nav[0]/frequencies/display-sel-khz");
var nav2selstr	= props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz-fmt");
var nav2selmhz	= props.globals.getNode("/instrumentation/nav[1]/frequencies/display-sel-mhz");
var nav2selkhz	= props.globals.getNode("/instrumentation/nav[1]/frequencies/display-sel-khz");
var nav1sbystr	= props.globals.getNode("/instrumentation/nav[0]/frequencies/standby-mhz-fmt");
var nav1sbymhz	= props.globals.getNode("/instrumentation/nav[0]/frequencies/display-sby-mhz");
var nav1sbykhz	= props.globals.getNode("/instrumentation/nav[0]/frequencies/display-sby-khz");
var nav2sbystr	= props.globals.getNode("/instrumentation/nav[1]/frequencies/standby-mhz-fmt");
var nav2sbymhz	= props.globals.getNode("/instrumentation/nav[1]/frequencies/display-sby-mhz");
var nav2sbykhz	= props.globals.getNode("/instrumentation/nav[1]/frequencies/display-sby-khz");

							# This initializes the values
var navtemp = split(".",nav1selstr.getValue());
nav1selmhz.setValue(navtemp[0]);
nav1selkhz.setValue(navtemp[1]);
navtemp = split(".",nav2selstr.getValue());
nav2selmhz.setValue(navtemp[0]);
nav2selkhz.setValue(navtemp[1]);
navtemp = split(".",nav1sbystr.getValue());
nav1sbymhz.setValue(navtemp[0]);
nav1sbykhz.setValue(navtemp[1]);
navtemp = split(".",nav2sbystr.getValue());
nav2sbymhz.setValue(navtemp[0]);
nav2sbykhz.setValue(navtemp[1]);
							# And these make sure they're updated
setlistener(nav1selstr, func {
  var navtemp = split(".",nav1selstr.getValue());
  nav1selmhz.setValue(navtemp[0]);
  nav1selkhz.setValue(navtemp[1]);
});
setlistener(nav2selstr, func {
  var navtemp = split(".",nav2selstr.getValue());
  nav2selmhz.setValue(navtemp[0]);
  nav2selkhz.setValue(navtemp[1]);
});
setlistener(nav1sbystr, func {
  var navtemp = split(".",nav1sbystr.getValue());
  nav1sbymhz.setValue(navtemp[0]);
  nav1sbykhz.setValue(navtemp[1]);
});
setlistener(nav2sbystr, func {
  var navtemp = split(".",nav2sbystr.getValue());
  nav2sbymhz.setValue(navtemp[0]);
  nav2sbykhz.setValue(navtemp[1]);
});


var comm1sel	= props.globals.getNode("/instrumentation/comm[0]/frequencies/selected-mhz");
var comm1sby	= props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz");
var comm1selstr	= props.globals.getNode("/instrumentation/comm[0]/frequencies/selected-mhz-fmt");
var comm1sbystr	= props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz-fmt");
var comm1selmhz= props.globals.getNode("/instrumentation/comm[0]/frequencies/display-sel-mhz");
var comm1selkhz= props.globals.getNode("/instrumentation/comm[0]/frequencies/display-sel-khz");
var comm1sbymhz= props.globals.getNode("/instrumentation/comm[0]/frequencies/display-sby-mhz");
var comm1sbykhz= props.globals.getNode("/instrumentation/comm[0]/frequencies/display-sby-khz");

var comm2sel	= props.globals.getNode("/instrumentation/comm[1]/frequencies/selected-mhz");
var comm2sby	= props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz");
var comm2selstr	= props.globals.getNode("/instrumentation/comm[1]/frequencies/selected-mhz-fmt");
var comm2sbystr	= props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz-fmt");
var comm2selmhz= props.globals.getNode("/instrumentation/comm[1]/frequencies/display-sel-mhz");
var comm2selkhz= props.globals.getNode("/instrumentation/comm[1]/frequencies/display-sel-khz");
var comm2sbymhz= props.globals.getNode("/instrumentation/comm[1]/frequencies/display-sby-mhz");
var comm2sbykhz= props.globals.getNode("/instrumentation/comm[1]/frequencies/display-sby-khz");

							# Update support vars on comm change
setlistener(comm1sel, func {
  var commstr = sprintf("%.2f",comm1sel.getValue());	# String conversion
  var commtemp = split(".",commstr);			# Split into MHz and KHz
  comm1selmhz.setValue(commtemp[0]);
  comm1selkhz.setValue(commtemp[1]);
});
setlistener(comm1sby, func {
  var commstr = sprintf("%.2f",comm1sby.getValue());
  var commtemp = split(".",commstr);
  comm1sbymhz.setValue(commtemp[0]);
  comm1sbykhz.setValue(commtemp[1]);
});
setlistener(comm2sel, func {
  var commstr = sprintf("%.2f",comm2sel.getValue());
  var commtemp = split(".",commstr);
  comm2selmhz.setValue(commtemp[0]);
  comm2selkhz.setValue(commtemp[1]);
});
setlistener(comm2sby, func {
  var commstr = sprintf("%.2f",comm2sby.getValue());
  var commtemp = split(".",commstr);
  comm2sbymhz.setValue(commtemp[0]);
  comm2sbykhz.setValue(commtemp[1]);
});

							# Set comm support vars to startups
var update_comms = func {
  var commstr = "";
  var commtemp = 0;

  commstr = sprintf("%.2f",comm1sel.getValue());
  commtemp = split(".",commstr);
  comm1selmhz.setValue(commtemp[0]);
  comm1selkhz.setValue(commtemp[1]);
  commstr = sprintf("%.2f",comm1sby.getValue());
  commtemp = split(".",commstr);
  comm1sbymhz.setValue(commtemp[0]);
  comm1sbykhz.setValue(commtemp[1]);

  commstr = sprintf("%.2f",comm2sel.getValue());
  commtemp = split(".",commstr);
  comm2selmhz.setValue(commtemp[0]);
  comm2selkhz.setValue(commtemp[1]);
  commstr = sprintf("%.2f",comm2sby.getValue());
  commtemp = split(".",commstr);
  comm2sbymhz.setValue(commtemp[0]);
  comm2sbykhz.setValue(commtemp[1]);
}


var InstrumentationInit = func {
  settimer(update_comms, 2);				# Delay startup a bit to allow things to initialize
  settimer(update_apwarn, 2);				# Delay startup a bit to allow things to initialize
  #interpolate(ai_spin, 1, 15);				# Spin up the backup AI gyro
  settimer(update_ai, 20);				# Maintain spin on backup AI
}
