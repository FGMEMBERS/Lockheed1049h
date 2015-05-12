### do not forget, in the Lockheed1049h-engines.nas I have also changed the following line ...
### engine_controls[engine].getNode("starter").setBoolValue(1);         # Engage engine starter

# there was a ground contact
setlistener("/fdm/jsbsim/systems/crash-detect/crash-on-ground", func(c) {

                if(c.getBoolValue()) setprop("/fdm/jsbsim/systems/crash-detect/crash-save", 1);
    
}, 1, 1);

## GEAR
#######

# prevent retraction of the landing gear when any of the wheels are compressed
setlistener("controls/gear/gear-down", func {
   var down = props.globals.getNode("controls/gear/gear-down").getBoolValue();
   var crashed = getprop("/fdm/jsbsim/systems/crash-detect/crash-on-ground") or 0;
   if (!down and (getprop("gear/gear[0]/wow")
               or getprop("gear/gear[1]/wow")
               or getprop("gear/gear[2]/wow")))
   {
      props.globals.getNode("controls/gear/gear-down").setBoolValue (!crashed);
   }
});

# fire up engines, if crashed
setlistener("/fdm/jsbsim/systems/crash-detect/crash-save", func(r) {
    var r = r.getBoolValue() or 0;
    var p = getprop("/orientation/roll-deg") or 0;
    # left hand side
    if (r and p <= 0){        
        setprop("sim/multiplay/generic/int[11]", 1);  
        setprop("/controls/engines/engine[0]/mixture", 0);
        setprop("/controls/engines/engine[0]/magnetos", 0);
        setprop("/controls/engines/engine[0]/on-fire", 1);
        setprop("sim/multiplay/generic/int[12]", 1);
        setprop("/controls/engines/engine[1]/mixture", 0);
        setprop("/controls/engines/engine[1]/magnetos", 0);
        setprop("/controls/engines/engine[1]/on-fire", 1);
    }
    
    # on the right
    if (r and p > 0){
        setprop("sim/multiplay/generic/int[13]", 1);
        setprop("/controls/engines/engine[2]/mixture", 0);
        setprop("/controls/engines/engine[2]/magnetos", 0);
        setprop("/controls/engines/engine[2]/on-fire", 1);
        setprop("sim/multiplay/generic/int[14]", 1);
        setprop("/controls/engines/engine[3]/mixture", 0);
        setprop("/controls/engines/engine[3]/magnetos", 0);
        setprop("/controls/engines/engine[3]/on-fire", 1);
    }
    
}, 0, 1);

# blow out the fire
setlistener("/controls/engines/engine[0]/on-fire", func(f0) {
    var f0 = f0.getBoolValue() or 0;  
    if (!f0){
        setprop("sim/multiplay/generic/int[11]", 0);
    }else{
        setprop("sim/multiplay/generic/int[11]", 1);
        setprop("/controls/engines/engine[0]/magnetos", 0);
        setprop("/controls/engines/engine[0]/mixture", 0.4);
    }
}, 0, 1);

setlistener("/controls/engines/engine[1]/on-fire", func(f1) {
    var f1 = f1.getBoolValue() or 0;  
    if (!f1){
        setprop("sim/multiplay/generic/int[12]", 0);
    }else{
        setprop("sim/multiplay/generic/int[12]", 1);
        setprop("/controls/engines/engine[1]/magnetos", 0);
        setprop("/controls/engines/engine[1]/mixture", 0.4);
    }
}, 0, 1);

setlistener("/controls/engines/engine[2]/on-fire", func(f2) {
    var f2 = f2.getBoolValue() or 0;
    if (!f2){
        setprop("sim/multiplay/generic/int[13]", 0);
    }else{
        setprop("sim/multiplay/generic/int[13]", 1);
        setprop("/controls/engines/engine[2]/magnetos", 0);
        setprop("/controls/engines/engine[2]/mixture", 0.4);
    }
}, 0, 1);

setlistener("/controls/engines/engine[3]/on-fire", func(f3) {
    var f3 = f3.getBoolValue() or 0;  
    if (!f3){
        setprop("sim/multiplay/generic/int[14]", 0);
    }else{
        setprop("sim/multiplay/generic/int[14]", 1);
        setprop("/controls/engines/engine[3]/magnetos", 0);
        setprop("/controls/engines/engine[3]/mixture", 0.4);
    }
}, 0, 1);


# blow out the fire
setlistener("/controls/engines/engine[0]/throttle", func(t0) {
    var t0 = t0.getValue() or 0;
    var m0 = getprop("/controls/engines/engine[0]/mixture"); 
    if (t0 == 0 and m0 == 0){
        setprop("/controls/engines/engine[0]/on-fire", 0 );
    }
}, 0, 1);

setlistener("/controls/engines/engine[1]/throttle", func(t1) {
    var t1 = t1.getValue() or 0;
    var m1 = getprop("/controls/engines/engine[1]/mixture"); 
    if (t1 == 0 and m1 == 0){
        setprop("/controls/engines/engine[1]/on-fire", 0 );
    }
}, 0, 1);

setlistener("/controls/engines/engine[2]/throttle", func(t2) {
    var t2 = t2.getValue() or 0;
    var m2 = getprop("/controls/engines/engine[2]/mixture"); 
    if (t2 == 0 and m2 == 0){
        setprop("/controls/engines/engine[2]/on-fire", 0 );
    }
}, 0, 1);

setlistener("/controls/engines/engine[3]/throttle", func(t3) {
    var t3 = t3.getValue() or 0;
    var m3 = getprop("/controls/engines/engine[3]/mixture"); 
    if (t3 == 0 and m3 == 0){
        setprop("/controls/engines/engine[3]/on-fire", 0 );
    }
}, 0, 1);


var randomly_set_engines_on_fire = maketimer (5.5, func {
   # Choose an engine at random, then set it on fire if too hot
   var e = rand();
   var engine = 0;

   if (e <= 0.25) engine = 0;
   else if (e <= 0.5) engine = 1;
   else if (e <= 0.75) engine = 2;
   else engine = 3;
       
   if (getprop("/controls/engines/engine["~engine~"]/on-fire")
       or !getprop("/engines/engine["~engine~"]/fuel-flow-gph") > 0) {
      # Already on fire or no fuel flow, do nothing.
      return;
   }
   var probability = 0;
   # The probability that the engine catches fire increases with
   # cylinder head temperature if above 550 degF.  Above 650 degF,
   # the probability becomes certainty.
   var cht = getprop("/engines/engine["~engine~"]/cht-degf") - 550;
   if (cht > 0) { probability = cht / 100; }
   if (rand () < probability) {
      setprop("/controls/engines/engine["~engine~"]/on-fire", 1);
   }
});

setlistener ("/sim/signals/fdm-initialized", func {
  if (!randomly_set_engines_on_fire.isRunning) {
    randomly_set_engines_on_fire.start ();
  }
}, 0, 0);

# NOTICE: the fire-warning you found in the /Lockheed1049h-lights.nas
