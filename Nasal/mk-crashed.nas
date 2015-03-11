### do not forget, in the Lockheed1049h-engines.nas I have also changed the following line ...
### engine_controls[engine].getNode("starter").setBoolValue(1);		# Engage engine starter

# there was a ground contact
setlistener("/fdm/jsbsim/systems/crash-detect/crash-on-ground", func(c) {

		if(c.getBoolValue()) setprop("/fdm/jsbsim/systems/crash-detect/crash-save", 1);
    
}, 1, 1);

## GEAR
#######

# prevent retraction of the landing gear when any of the wheels are compressed
setlistener("controls/gear/gear-down", func
 {
 var down = props.globals.getNode("controls/gear/gear-down").getBoolValue();
 var crashed = getprop("/fdm/jsbsim/systems/crash-detect/crash-on-ground") or 0;
 if (!down and (getprop("gear/gear[0]/wow") or getprop("gear/gear[1]/wow") or getprop("gear/gear[2]/wow")))
  {
    if(!crashed){
  		props.globals.getNode("controls/gear/gear-down").setBoolValue(1);
    }else{
  		props.globals.getNode("controls/gear/gear-down").setBoolValue(0);
    }
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


# this script start up the burning engines
var fire_on = func (){
   var first  = getprop("/controls/engines/engine[0]/on-fire") or 0;
   var second = getprop("/controls/engines/engine[1]/on-fire") or 0;
   var third  = getprop("/controls/engines/engine[2]/on-fire") or 0;
   var fourth  = getprop("/controls/engines/engine[3]/on-fire") or 0;
   
   if(!first and !second and !third and !fourth){

      var e = rand();
   		var eng = 0;
   		var is_on = 0;
   		
   		if(e < 0.3) eng = 1;
			if(e >= 0.3 and e < 0.6) eng = 2;
			if(e >= 0.6 and e < 0.8) eng = 3;
			 
			var cht  = getprop("/engines/engine["~eng~"]/cht-degf") or 0;
			var bmep = getprop("/engines/engine["~eng~"]/bmep") or 0;
			var pit  = getprop("/orientation/pitch-deg") or 0;
			
			
   		#print("Temp is on : ", cht);
   		#print("BMEP is on : ", bmep);
   		#print("pitch is   : ", pit);
			 
			var r = rand();
			
			if ((r > 0.8 and cht > 550 and bmep < 150) or pit > 20.0 or pit < -30.0) setprop("/controls/engines/engine["~eng~"]/on-fire", 1);
   }
   
   settimer( fire_on, 5.5);
};

fire_on();

# NOTICE: the fire-warning you found in the /Lockheed1049h-lights.nas


