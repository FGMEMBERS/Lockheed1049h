###############################################################################################
#		Lake of Constance Hangar :: M.Kraus
#		Honda-CBR1000RR for Flightgear September 2014
#		This file is licenced under the terms of the GNU General Public Licence V2 or later
############################################################################################### 
# changings from the Radio-Panel or Instruments inside the Aircraft
setlistener("/instrumentation/nav[2]/frequencies/selected-mhz", func{
    actualize_selected_frequency();
});

setlistener("/instrumentation/nav[3]/frequencies/selected-mhz", func{
    actualize_selected_frequency();
});

setlistener("/instrumentation/nav[2]/frequencies/standby-mhz", func{
    actualize_selected_frequency();
});

setlistener("/instrumentation/nav[3]/frequencies/standby-mhz", func{
    actualize_selected_frequency();
});

setlistener("/instrumentation/nav[2]/radials/selected-deg", func{
    actualize_selected_frequency();
});

setlistener("/instrumentation/nav[3]/radials/selected-deg", func{
    actualize_selected_frequency();
});

setlistener("/autopilot/switches/selected-nav", func{
    actualize_selected_frequency();
});


var actualize_selected_frequency = func{

    var ap_state = getprop("/autopilot/switches/selected-nav") or 0;
    if (ap_state == 1){

      setprop("/instrumentation/nav/frequencies/selected-mhz", getprop("/instrumentation/nav[2]/frequencies/selected-mhz" ) or 0);
      setprop("/instrumentation/nav/frequencies/standby-mhz", getprop("/instrumentation/nav[2]/frequencies/standby-mhz" ) or 0);
      setprop("/instrumentation/nav/radials/selected-deg", getprop("/instrumentation/nav[2]/radials/selected-deg" ) or 0);
      setprop("/instrumentation/nav[1]/frequencies/selected-mhz", getprop("/instrumentation/nav[3]/frequencies/selected-mhz" ) or 0);
      setprop("/instrumentation/nav[1]/frequencies/standby-mhz", getprop("/instrumentation/nav[3]/frequencies/standby-mhz" ) or 0);
      setprop("/instrumentation/nav[1]/radials/selected-deg", getprop("/instrumentation/nav[3]/radials/selected-deg" ) or 0);

    }else{

      setprop("/instrumentation/nav/frequencies/selected-mhz", getprop("/instrumentation/nav[3]/frequencies/selected-mhz") or 0);
      setprop("/instrumentation/nav/frequencies/standby-mhz", getprop("/instrumentation/nav[3]/frequencies/standby-mhz") or 0);
      setprop("/instrumentation/nav/radials/selected-deg", getprop("/instrumentation/nav[3]/radials/selected-deg" ) or 0);
      setprop("/instrumentation/nav[1]/frequencies/selected-mhz", getprop("/instrumentation/nav[2]/frequencies/selected-mhz" ) or 0);
      setprop("/instrumentation/nav[1]/frequencies/standby-mhz", getprop("/instrumentation/nav[2]/frequencies/standby-mhz" ) or 0);
      setprop("/instrumentation/nav[1]/radials/selected-deg", getprop("/instrumentation/nav[2]/radials/selected-deg" ) or 0);
    }

};


# changings from the F11 Menu overwrite always the cockpit setting
# so the way here is:
# pilot change the frequency on the instrument - setlistener write it to nav[0] or nav[1]
# setlistener  nav[0] or nav[1] write back this frequency to  nav[2] or nav[3]
# so its sure, we have synchron frequency at every time on every case.

setlistener("/instrumentation/nav[0]/frequencies/selected-mhz", func(freq){
    var freq  = freq.getValue();
    var ap_state = getprop("/autopilot/switches/selected-nav") or 0;

    if (ap_state == 1){
      setprop("/instrumentation/nav[2]/frequencies/selected-mhz", getprop("/instrumentation/nav[0]/frequencies/selected-mhz" ) or 0);
    }else{
      setprop("/instrumentation/nav[3]/frequencies/selected-mhz", getprop("/instrumentation/nav[0]/frequencies/selected-mhz" ) or 0);
    }

});

setlistener("/instrumentation/nav[0]/frequencies/standby-mhz", func(freq){
    var freq  = freq.getValue();
    var ap_state = getprop("/autopilot/switches/selected-nav") or 0;

    if (ap_state == 1){
      setprop("/instrumentation/nav[2]/frequencies/standby-mhz", getprop("/instrumentation/nav[0]/frequencies/standby-mhz" ) or 0);
    }else{
      setprop("/instrumentation/nav[3]/frequencies/standby-mhz", getprop("/instrumentation/nav[0]/frequencies/standby-mhz" ) or 0);
    }

});

setlistener("/instrumentation/nav[0]/radials/selected-deg", func(freq){
    var freq  = freq.getValue();
    var ap_state = getprop("/autopilot/switches/selected-nav") or 0;

    if (ap_state == 1){
      setprop("/instrumentation/nav[2]/radials/selected-deg", getprop("/instrumentation/nav[0]/radials/selected-deg" ) or 0);
    }else{
      setprop("/instrumentation/nav[3]/radials/selected-deg", getprop("/instrumentation/nav[0]/radials/selected-deg" ) or 0);
    }

});


setlistener("/instrumentation/nav[1]/frequencies/selected-mhz", func(freq){
    var freq  = freq.getValue();
    var ap_state = getprop("/autopilot/switches/selected-nav") or 0;

    if (ap_state == 1){
      setprop("/instrumentation/nav[3]/frequencies/selected-mhz", getprop("/instrumentation/nav[1]/frequencies/selected-mhz" ) or 0);
    }else{
      setprop("/instrumentation/nav[2]/frequencies/selected-mhz", getprop("/instrumentation/nav[1]/frequencies/selected-mhz" ) or 0);
    }

});

setlistener("/instrumentation/nav[1]/frequencies/standby-mhz", func(freq){
    var freq  = freq.getValue();
    var ap_state = getprop("/autopilot/switches/selected-nav") or 0;

    if (ap_state == 1){
      setprop("/instrumentation/nav[3]/frequencies/standby-mhz", getprop("/instrumentation/nav[1]/frequencies/standby-mhz" ) or 0);
    }else{
      setprop("/instrumentation/nav[2]/frequencies/standby-mhz", getprop("/instrumentation/nav[1]/frequencies/standby-mhz" ) or 0);
    }

});

setlistener("/instrumentation/nav[1]/radials/selected-deg", func(freq){
    var freq  = freq.getValue();
    var ap_state = getprop("/autopilot/switches/selected-nav") or 0;

    if (ap_state == 1){
      setprop("/instrumentation/nav[3]/radials/selected-deg", getprop("/instrumentation/nav[1]/radials/selected-deg" ) or 0);
    }else{
      setprop("/instrumentation/nav[2]/radials/selected-deg", getprop("/instrumentation/nav[1]/radials/selected-deg" ) or 0);
    }

});



