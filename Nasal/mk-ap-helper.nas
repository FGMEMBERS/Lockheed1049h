#=======================================================================
# In copilot mode the value of autopilot kill all pilot - copilot action
# so pilot settings better be written to switch boolean values
#=======================================================================

setlistener("/sim/signals/fdm-initialized", func {
      setprop("autopilot/locks/altitude", "");
      setprop("autopilot/locks/heading", "");
      setprop("autopilot/locks/speed", "");
      setprop("autopilot/switches/ap", 0);
      setprop("autopilot/switches/alt", 0);
}, 0, 0);

setlistener("/autopilot/switches/ap", func (ap) {
    set_flightpath (props.globals.getNode ("/controls/special/flightpath-switch"));
    var ap = ap.getBoolValue();
    if (ap == 1) {
      if (getprop("autopilot/switches/alt")) {
         setprop("autopilot/locks/altitude", "altitude-hold");
         setprop("autopilot/settings/target-altitude-ft",
                 getprop ("position/altitude-ft"));
      } else {
         setprop("autopilot/locks/altitude", "pitch-hold");
         setprop("autopilot/settings/target-pitch-deg",
                 getprop ("orientation/pitch-deg"));
      }
    } else {
      setprop("autopilot/locks/altitude", "");
    }
}, 0, 0);

setlistener("autopilot/switches/alt", func (alt){
    var alt = alt.getBoolValue();
    if (alt == 1){
      setprop("autopilot/locks/altitude", "altitude-hold");
    } else if (getprop ("autopilot/switches/ap")) {
        setprop("autopilot/locks/altitude", "pitch-hold");
        setprop("autopilot/settings/target-pitch-deg", 
                      getprop("orientation/pitch-deg"));
    } else {    
      setprop("autopilot/locks/altitude", "");
    }
}, 0, 0);

# If trim wheels are not on 0 and you click the center of this wheel
var trimBackTime = 2.0;
var applyTrimWheels = func(v, which = 0) {
    if (which == 0) { interpolate("controls/flight/elevator-trim", v, trimBackTime); }
    if (which == 1) { interpolate("controls/flight/rudder-trim", v, trimBackTime); }
    if (which == 2) { interpolate("controls/flight/aileron-trim", v, trimBackTime); }
}

# if somebody sets the property not in cockpit but in the menu, switch must also follow
# this action
setlistener("autopilot/locks/heading", func (h){
		var h = h.getValue();
		var s = getprop("autopilot/switches/ap", 1);
		if (h and !s) setprop("autopilot/switches/ap", 1);
});

# if somebody set the property at the original Autopilot between Pilot and Copilot,
# switch must also follow this action
var heading_lock = [ "wing-leveler", "nav1-hold", "nav1-hold" ];
var set_flightpath = func (flightpath_switch_node) {
   if (getprop("autopilot/switches/ap")) {
      setprop ("autopilot/locks/heading",
               heading_lock [ flightpath_switch_node.getValue() ]);
   } else {
      setprop("autopilot/locks/heading", "");
   }
}
setlistener("controls/special/flightpath-switch", set_flightpath, 0, 0);


################## Little Help Window on bottom of screen #################
var help_win = screen.window.new( 0, 0, 1, 5 );
help_win.fg = [1,1,1,1];

print("Help infosystem started");

var h_altimeter = func {
	var press_inhg = getprop("instrumentation/altimeter/setting-inhg");
	var press_qnh = getprop("instrumentation/altimeter/setting-hpa");
	if(  press_inhg == nil ) press_inhg = 0.0;
	if(  press_qnh == nil ) press_qnh = 0.0;
	help_win.write(sprintf("Baro alt pressure: %.0f hpa %.2f inhg ", press_qnh, press_inhg) );
}

var h_heading = func {
	var press_hdg = getprop("autopilot/settings/heading-bug-deg");
	var mv = getprop("environment/magnetic-variation-deg") or 0;
	if(  press_hdg == nil ) press_hdg = 0.0;
	help_win.write(sprintf("Target heading: %.0f , magnetic variation: %.0f", press_hdg, mv) );
}

var h_course = func {
	var press_course = getprop("instrumentation/nav[2]/radials/selected-deg");
	if(  press_course == nil ) press_course = 0.0;
	help_win.write(sprintf("Selected course is: %.0f ", press_course) );
}

var h_course_two = func {
	var press_course_two = getprop("instrumentation/nav[3]/radials/selected-deg");
	if(  press_course_two == nil ) press_course_two = 0.0;
	help_win.write(sprintf("Selected course is: %.0f ", press_course_two) );
}

var h_vs = func {
	var press_vs = getprop("autopilot/settings/vertical-speed-fpm");
	if(  press_vs == nil ) press_vs = 0.0;
	help_win.write(sprintf("Vertical speed: %.0f ", press_vs) );
}

var h_mis = func {
	var press_mis = getprop("instrumentation/rmi/face-offset");
	if(  press_mis == nil ) press_mis = 0.0;
	help_win.write(sprintf("%.0f degrees", press_mis) );
}

setlistener( "instrumentation/altimeter/setting-inhg", h_altimeter );
setlistener( "autopilot/settings/heading-bug-deg", h_heading );
setlistener( "instrumentation/nav/radials/selected-deg", h_course );
setlistener( "instrumentation/nav[1]/radials/selected-deg", h_course_two );
setlistener( "autopilot/settings/vertical-speed-fpm", h_vs);
setlistener( "instrumentation/rmi/face-offset", h_mis);

################################  funny sound action for the old elevator trim wheel #################### 
var lastTrimValue  = props.globals.initNode("autopilot/trim/last-elev-trim-turn", 0,"DOUBLE");

setlistener("controls/flight/elevator-trim", func(et){
	var et = et.getValue();
	var ap = getprop("autopilot/switches/ap") or 0;
	if (!ap) {
		setprop("autopilot/trim/elevator-trim-turn", et);
		lastTrimValue.setValue(et);
	}
},0,0);

var trim_loop = func{
	var et = getprop("controls/flight/elevator-trim") or 0;
	var ap = getprop("autopilot/switches/ap") or 0;
	var diff = abs(lastTrimValue.getValue() - et);
	#print("Differenz: "~diff);
	if(ap and diff > 0.002){
			if(diff < 0.05 ){
				interpolate("autopilot/trim/elevator-trim-turn", et, 2); 
			}elsif(diff >= 0.05 and diff < 0.3){
				interpolate("autopilot/trim/elevator-trim-turn", et, 4); 			
			}else{
				interpolate("autopilot/trim/elevator-trim-turn", et, 6); 			
			}
			lastTrimValue.setValue(et); # but we need the correct value
	}
	
	settimer(trim_loop, 8.2);
}

trim_loop();  # fire it up

