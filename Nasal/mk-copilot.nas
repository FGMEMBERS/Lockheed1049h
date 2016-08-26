###############################################################################################
#		Lake of Constance Hangar :: M.Kraus
#		Honda-CBR1000RR for Flightgear September 2014
#		This file is licenced under the terms of the GNU General Public Licence V2 or later
############################################################################################### 
# some functions must be answered for the copilot
#
# M.Kraus, March 2012


toggle_reverse_lockout = func {
  print ("toggle_reverse_lockout() ... not for copilot!");
}

toggle_prop_reverse = func {
  print ("toggle_prop_reverse() ... not for copilot!");
}

# mk-agl-radar is not load in Lockheed1049h-copilot-set.xml
# so fake here the altitude-agl-ft for the terrain-warning lamps

setlistener("/position/gear-agl-ft", func(alt) {
    var alt = alt.getValue() + 7.63;
    setprop("/position/altitude-agl-ft", alt);
});
