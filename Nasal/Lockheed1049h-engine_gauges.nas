# Nasal code to derive believable engine performance values.eoilt4

# This is a bash to drive the engine temp and oil pressure gauges since
# JSBSIM, in its current incarnation, does not handle large displacement
# piston engines correctly in terms of temperature.  The JSBSIM cylinder 
# head temp will easily go to almost 20,000 degrees if left in full power 
# mode long enough, which is about equal to the surface of the sun.  
# Since oil pressure is calculated through JSBSIM based on RPM and temp., 
# we get negative values for oil pressure through JSBSIM as well. 
#
# Exhaust Gas Temperature stays in believable ranges, so that is what we 
# will use to derive our values from.  We won't get completely accurate
# warm up and cool down effect deriving everything from EGT, but we will
# get reasonably sane values and some time lag can be introduced on the
# estimated cylinder head temp to emulate warm up and cool down.
# Also Exhaust Gas Temp factors ambient air temp into its calculation, so
# it should give some fluctuation with air temp as well.
#
# And since we need to do a calculation in order to drive the torque
# BMEP gauges, we might as well do that here also.
#
# Wolfram Gottfried aka 'Yakko'
#
# Modified:
#	20090518 G.Neely: Added hack to drive simulate pressure gauges until
#		something more real can be developed.

var engine_props	= props.globals.getNode("/engines").getChildren("engine");

var engine_values = func {
#
# Since we use egt, estimated cht and rpm values more than once, might as well 
# retreive and calc once instead of repeating getprop which may be slower.
#
  var rev0 = getprop("/engines/engine[0]/rpm");
  var rev1 = getprop("/engines/engine[1]/rpm");
  var rev2 = getprop("/engines/engine[2]/rpm");
  var rev3 = getprop("/engines/engine[3]/rpm");
  var egt0 = getprop("/engines/engine[0]/egt-degf")*(.95-getprop("/controls/engines/engine[0]/cowl-flaps-norm")*.235);
  var egt1 = getprop("/engines/engine[1]/egt-degf")*(.95-getprop("/controls/engines/engine[1]/cowl-flaps-norm")*.235);
  var egt2 = getprop("/engines/engine[2]/egt-degf")*(.95-getprop("/controls/engines/engine[2]/cowl-flaps-norm")*.235);
  var egt3 = getprop("/engines/engine[3]/egt-degf")*(.95-getprop("/controls/engines/engine[3]/cowl-flaps-norm")*.235);
  var echt0 = getprop("/engines/engine[0]/est-cht");
  var echt1 = getprop("/engines/engine[1]/est-cht");
  var echt2 = getprop("/engines/engine[2]/est-cht");
  var echt3 = getprop("/engines/engine[3]/est-cht");
#
# Set our estimated cylinder head temp to be around .95 of EGT with
# some lag in temp. movement to simulate warmup and cooldown.  Cowl
# flaps cooling effect is added, changing the max temp which the the
# computed value will rise to based on how far open they are from 0 to 1 
# Also a "breakdown" could happen here by adding code so that if
# echt gets too far above redline the engine shuts down.
#
# .95 was chosen to allow the engines to be operated at maximum power
# for a short time before the cylinder head temp would exceed the
# maximum safe limit of 270C/520F, but if they are operated for too
# long at high power the temp will rise almost to the egt value with
# the cowl flaps closed, and to about 70% EGT with them open. 
#
  setprop("/engines/engine[0]/est-cht", (echt0+((egt0-echt0)*.001)));
  setprop("/engines/engine[1]/est-cht", (echt1+((egt1-echt1)*.001)));
  setprop("/engines/engine[2]/est-cht", (echt2+((egt2-echt2)*.001)));
  setprop("/engines/engine[3]/est-cht", (echt3+((egt3-echt3)*.001)));
#
# Here will use our derived cylinder head temp in conjunction with
# engine RPM to calculate an estimated temperature, which will
# then be used to calculate an estimated oil pressure:
#
# Max safe oil temp is 100C/212F - with a factor of .405 on the
# oil temp calculation, max oil temp would be reached about the same
# time as max cylinder head temp.
#
# We use est-oiltemp in 2 places so we'll assign it to a local variable
#
  var eoilt0 = (echt0*.405);
  var eoilt1 = (echt1*.405);
  var eoilt2 = (echt2*.405);
  var eoilt3 = (echt3*.405);
  setprop("/engines/engine[0]/est-oiltemp", eoilt0);
  setprop("/engines/engine[1]/est-oiltemp", eoilt1);
  setprop("/engines/engine[2]/est-oiltemp", eoilt2);
  setprop("/engines/engine[3]/est-oiltemp", eoilt3);
#
# On a cold engine, 130-140 PSI might be a little high but not insanely
# so. There is not much direct info on the R3350 available but FAA 
# manuals for a Fairchild using R3350s show oil pressures of 85 PSI at 
# 100% RPM, and 10PSI at idle as minimum allowed.  I find references to
# the existance of an oil pressure relief valve to prevent dangerously
# high pressures, but no indication of what the value would be so I
# going to guess 130 PSI for now. I'm setting estimated oil pressure to a
# variable since I need to use it both in the IF/THEN and setprop commands.
# 
var eoilp0=((1.9*rev0)/(.01+(eoilt0*.082))*.215);
var eoilp1=((1.9*rev1)/(.01+(eoilt1*.082))*.215);
var eoilp2=((1.9*rev2)/(.01+(eoilt2*.082))*.215);
var eoilp3=((1.9*rev3)/(.01+(eoilt3*.082))*.215);
if (eoilp0 > 130) {
  setprop("/engines/engine[0]/est-oilpress", 130);
}
else {
  setprop("/engines/engine[0]/est-oilpress", eoilp0);
}
if (eoilp1 > 130) {
  setprop("/engines/engine[1]/est-oilpress", 130);
}
else {
  setprop("/engines/engine[1]/est-oilpress", eoilp1);
}
if (eoilp2 > 130) {
  setprop("/engines/engine[2]/est-oilpress", 130);
}
else {
  setprop("/engines/engine[2]/est-oilpress", eoilp2);
}
if (eoilp3 > 130) {
  setprop("/engines/engine[3]/est-oilpress", 130);
}
else {
  setprop("/engines/engine[3]/est-oilpress", eoilp3);
}

# Engine fuel pressure gauge hack:
# Float the fuel pressure down from 27 based on theory that higher fuel flow means less static
# pressure in the system (if fluid flowing through a line is being drawn out at exactly the maximum
# rate that it can be pumped in, in theory the pressure on the walls of the line would be zero).

  var temp_fuelpress = 0;
  for(var i=0; i<size(engine_props); i+=1) {
    temp_fuelpress = 0;
    if (engine_props[i].getNode("running").getValue()) {
      temp_fuelpress = 27-(engine_props[i].getNode("fuel-flow-gph").getValue()*.057);
    }
    engine_props[i].getNode("est-fuelpress").setValue(temp_fuelpress);
  }


#
# And here we do the calculate for the BMEP instruments, making sure RPM is above zero to avoid a division by 0
# error.  If RPM is zero, them bmep is also zero
#

if (rev0) {
  setprop("/engines/engine[0]/bmep", ((getprop("/fdm/jsbsim/propulsion/engine[0]/power-hp")*260)/rev0));
}
else {
  setprop("/engines/engine[0]/bmep", 0);
}
if (rev1) {
  setprop("/engines/engine[1]/bmep", ((getprop("/fdm/jsbsim/propulsion/engine[1]/power-hp")*260)/rev1));
}
else {
  setprop("/engines/engine[1]/bmep", 0);
}
if (rev2) {
  setprop("/engines/engine[2]/bmep", ((getprop("/fdm/jsbsim/propulsion/engine[2]/power-hp")*260)/rev2));
}
else {
  setprop("/engines/engine[2]/bmep", 0);
}
if (rev3) {
  setprop("/engines/engine[3]/bmep", ((getprop("/fdm/jsbsim/propulsion/engine[3]/power-hp")*260)/rev3));
}
else {
  setprop("/engines/engine[3]/bmep", 0);
}

#
# Set up the 1/4 second timer so this scrit doesn't repeat too fast
#
  settimer(engine_values, .25);
}
engine_values();
