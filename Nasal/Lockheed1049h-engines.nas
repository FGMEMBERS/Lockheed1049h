# Lockheed 1049H
#
# Custom 1049H routines for engine support
#
# Copyright (c) 2011 Gary Neely aka 'Buckaroo'
# Copyright (c) 2015 Ludovic Brenta
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# These vars declared in electrical.nas:
# MIN_VOLTS, bus_dc

# Starter button pressed:
var engine_starter = func {
   if (bus_dc.getNode("volts").getValue() <= MIN_VOLTS) { # Insufficient volts on bus
      return 0;
   }
   var engine = getprop ("/controls/switches/engine-start-select");
   if (engine == 0) { return 0; } # No engine selected
   setprop ("/controls/engines/engine[" ~ (engine - 1) ~ "]/starter", 1);
}

# Adjust the cooling factor of each engine as cowl flaps are opened or closed.

var adjust_cooling_factor = func (cowl_flaps_node) {
   var engine_number = cowl_flaps_node.getParent ().getIndex ();
   setprop ("/fdm/jsbsim/propulsion/engine[" ~ engine_number ~ "]/cooling-factor",
            0.30 + 0.15 * cowl_flaps_node.getValue ());
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
