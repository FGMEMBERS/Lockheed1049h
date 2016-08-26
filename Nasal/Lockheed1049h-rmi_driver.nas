# RMI Driver
# Nasal code to calculate RMI needle deflections based on mode (VOR/ADF)
# and beacon range. Simplifies RMI animations.
#
# Reads two custom properties:
#   /instrumentation/rmi-needle[0]/mode		(values 'vor'|'adf', default 'vor')
#   /instrumentation/rmi-needle[1]/mode		(values 'vor'|'adf', default 'vor')
#
# These should be set by cockpit switches to control the two RMI needles.
#
# Function writes to two custom properties:
#  /instrumentation/rmi-needle[0]/value
#  /instrumentation/rmi-needle[1]/value
#
# These are read by the RMI instrument animations.
#
#
# Wolfram Gottfried aka 'Yakko'
# Gary Neely aka 'Buckaroo'


var updateRMI = func {

# Needle default 'off' or out-of-range positions:

  var needle1 = 90;
  var needle2 = 270;


# If RMI 1 set to ADF (mode 1):

  if (getprop("/instrumentation/rmi-needle[0]/mode")) {
    if (getprop("/instrumentation/adf[0]/in-range")) {
      needle1 = getprop("/instrumentation/adf[0]/indicated-bearing-deg");
    }
  }

# RMI 1 set to VOR (mode 0):

  else {
    if (getprop("/instrumentation/nav[0]/in-range") and !getprop("/instrumentation/nav[0]/has-gs")) {
      # Needle actual = needle bearing - magnetic heading
      needle1 = getprop("/instrumentation/nav[0]/heading-deg") - getprop("/orientation/heading-magnetic-deg"); 
    }
  }

# If RMI 2 set to ADF (mode 1):

  if (getprop("/instrumentation/rmi-needle[1]/mode")) {
    if (getprop("/instrumentation/adf[1]/in-range")) {
      needle2 = getprop("/instrumentation/adf[1]/indicated-bearing-deg");
    }
  }

# RMI 2 set to VOR (mode 0):

  else {
    if (getprop("/instrumentation/nav[1]/in-range") and !getprop("/instrumentation/nav[1]/has-gs")) {
      # Needle actual = needle bearing - magnetic heading
      needle2 = getprop("/instrumentation/nav[1]/heading-deg") - getprop("/orientation/heading-magnetic-deg"); 
    }
  }

# Save Needle settings

  setprop("/instrumentation/rmi-needle[0]/value", needle1);
  setprop("/instrumentation/rmi-needle[1]/value", needle2);

# RMI updated 8 times / sec

  settimer(updateRMI, .125);
}

updateRMI();
