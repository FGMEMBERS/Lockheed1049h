# Lockheed 1049H
#
# Custom 1049H routines for door support
#
# Gary Neely aka 'Buckaroo'
#
# Like lights, doors are rigged for multiplayer viewing, so the property used for animation
# is a generic MP property rather than the control prop setup by the aircraft.door function.
# A listener watches for changes the control property and copies that to the MP prop for
# the actual animation. A better method to do this stuff is always welcome.


var door_crew = aircraft.door.new("/controls/door-crew", 2);

var L1049H_door_crew	= props.globals.getNode("/controls/door-crew/position-norm");
var L1049H_MP_door_crew	= props.globals.getNode("/sim/multiplay/generic/float[4]");

setlistener(L1049H_door_crew, func {
  L1049H_MP_door_crew.setValue(L1049H_door_crew.getValue())
});
