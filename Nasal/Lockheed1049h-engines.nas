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

# Adjust the cooling factor of each engine as cowl flaps are opened or closed.

var adjust_cooling_factor = func (cowl_flaps_node) {
   var engine_number = cowl_flaps_node.getParent ().getIndex ();
   setprop ("/fdm/jsbsim/propulsion/engine[" ~ engine_number ~ "]/cooling-factor",
            0.6 + 0.3 * cowl_flaps_node.getValue ());
}

var cowl_flaps_listeners = [ 0, 0, 0, 0 ]; # prevents re-registering listeners on Shift+Esc

setlistener ("/sim/signals/fdm-initialized", func {
   for (var engine = 0; engine < 4; engine = engine + 1) {
      if (cowl_flaps_listeners [engine] == 0) {
         cowl_flaps_listeners [engine] =
           setlistener ("/controls/engines/engine[" ~ engine ~ "]/cowl-flaps-norm",
                        adjust_cooling_factor, 1, 0);
      }
      else {
         print ("FDM reinitialized; not re-registering cowl flap listeners.");
      }
   }
}, 0, 0);
