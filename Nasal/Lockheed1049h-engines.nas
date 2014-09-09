# Lockheed 1049H
#
# Custom 1049H routines for engine support
#
# Gary Neely aka 'Buckaroo'
#
# Note that the starter selector sequence is based on the book checklist sequence of 3-4-2-1.

									# These vars declared in electrical.nas:
# MIN_VOLTS, bus_dc
									# Map selector numbers to engines:
									# If starter selector is 0, next is 3
									# If starter selector is 3, next is 4, etc.
var start_sequence	= {	0 : 3,
				1 : 0,
				2 : 1,
				3 : 4,
				4 : 2
		  	  };
var engine_start_select	= props.globals.getNode("/controls/switches/engine-start-select");
var engine_controls	= props.globals.getNode("/controls/engines").getChildren("engine");
var engines		= props.globals.getNode("/engines").getChildren("engine");


									# Starter button pressed:
var engine_starter = func {
  if (bus_dc.getNode("volts").getValue() <= MIN_VOLTS) { return 0 }	# Insufficient volts on bus
  var engine = engine_start_select.getValue();				# Get selected engine
  if (engine == 0) { return 0 }						# No engine selected
  engine -= 1;								# Translate 1-4 to 0-3
  engine_controls[engine].getNode("starter").setBoolValue(1);		# Engage engine starter
}

									# Increment starter selector sequencer:
var engine_starter_sel = func {
  engine_start_select.setValue(start_sequence[engine_start_select.getValue()]);
}


									# Monitor for engine functions
#var engine_monit = func {
#  for(var i=0; i<size(engines); i+=1) {					# if an engine is on, make sure starter is off
#    if (engines[i].getNode("running").getValue()) {
#      engine_controls[i].getNode("starter").setBoolValue(0);
#    }
#  }
#  settimer(engine_monit,5);
#}


