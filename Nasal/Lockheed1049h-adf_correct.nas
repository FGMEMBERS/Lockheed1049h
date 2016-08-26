# Nasal code to push FALSE values into the adf[0] and adf[1] in-range properties
# on a 4 second interval - this is a bash to make ADF work correctly since there
# is an issue where the in-range does not go back to FALSE on its own.  If you
# truly ARE in range it will flip back to TRUE instantly on its own, but will stay
# at FALSE if you are indeed out of range
#
# Wolfram Gottfried aka 'Yakko'

var adf_false_tick = func {
  setprop("/instrumentation/adf[0]/in-range", 0);
  setprop("/instrumentation/adf[1]/in-range", 0);
  settimer(adf_false_tick, 4);
}
adf_false_tick();
