# if engine running stop starter
#setlistener("engines/engine[0]/running", func(run) {
#    var run = run.getBoolValue();
#    if(run) setprop("controls/engines/engine[0]/starter",0);
#});

var switch1SoundToggle = func{
  var switchSound = props.globals.getNode("/sim/sound/switch1",1);
  if(switchSound.getBoolValue()){
    switchSound.setBoolValue(0);
  }else{
    switchSound.setBoolValue(1);
  }
}
var switch2SoundToggle = func{
  var switchSound = props.globals.getNode("/sim/sound/switch2",1);
  if(switchSound.getBoolValue()){
    switchSound.setBoolValue(0);
  }else{
    switchSound.setBoolValue(1);
  }
}
var switch3SoundToggle = func{
  var switchSound = props.globals.getNode("/sim/sound/switch3",1);
  if(switchSound.getBoolValue()){
    switchSound.setBoolValue(0);
  }else{
    switchSound.setBoolValue(1);
  }
}

#------------------  Autostart / stop -----------------------
var autostart = func{
  # switch on the FlightRallyeMode
  var frwKnob = getprop("instrumentation/frw/btn-mode");
  if (frwKnob == 0) {
    setprop("instrumentation/frw/btn-mode",1);
    Lockheed1049h.frw_mode();
  }

  var allreadyRun1 = props.globals.getNode("engines/engine[0]/running",1);
  var allreadyRun2 = props.globals.getNode("engines/engine[0]/running",1);
  var allreadyRun3 = props.globals.getNode("engines/engine[0]/running",1);
  var allreadyRun4 = props.globals.getNode("engines/engine[0]/running",1);
  if (!allreadyRun1.getBoolValue() and 
      !allreadyRun2.getBoolValue() and 
      !allreadyRun3.getBoolValue() and 
      !allreadyRun4.getBoolValue()) {

    Lockheed1049h.Startup();

  }else{

    Lockheed1049h.Shutdown();

  }
}


var Startup = func{

    settimer(setMag1, 1.0 );
    settimer(setMag2, 2.0 );
    settimer(setMag3, 3.0 );
    settimer(setMag4, 4.0 );
    settimer(setPanelLights, 5.0 );
    settimer(setChartLights, 5.0 );

    settimer(setVoltSel, 6.0 );
    settimer(setBattCart, 7.0 );
    settimer(setBattShip, 8.0 );
    settimer(setGen1, 9.0 );
    settimer(setGen2, 10.0 );
    settimer(setGen3, 11.0 );
    settimer(setGen4, 12.0 );
    settimer(setAPU, 13.0 );
    settimer(setBattShip, 14.0 );
    settimer(setBattCart, 15.0 );
    settimer(setMixture, 16.0 );
    settimer(setStart3, 15.0 );
    settimer(setStart4, 17.5 );
    settimer(setStart2, 20.0 );
    settimer(setStart1, 22.5 );
    settimer(setStartEnd, 25.0 );
    settimer(setAlt, 30.0 );
    settimer(setAPAlt, 31.0 );
    settimer(setHdg, 32.0 );
    settimer(setAntiCol, 33.0 );
    settimer(setNavLights, 34.0 );
    settimer(setWingLights, 35.0 );
    settimer(setTaxiLights, 36.0 );
}

var Shutdown = func{ 
    setprop("controls/electric/engine[0]/generator",0);
    setprop("controls/electric/engine[1]/generator",0);
    setprop("controls/electric/engine[2]/generator",0);
    setprop("controls/electric/engine[3]/generator",0);
    setprop("controls/electric/battery-switch",0);
    setprop("controls/lighting/instrument-lights",0);
    setprop("controls/lighting/nav-lights",0);
    setprop("controls/lighting/beacon",0);
    setprop("controls/engines/engine[0]/magnetos",0);
    setprop("controls/engines/engine[0]/fuel-pump",0);
    setprop("controls/engines/engine[1]/magnetos",0);
    setprop("controls/engines/engine[1]/fuel-pump",0);
    setprop("controls/engines/engine[2]/magnetos",0);
    setprop("controls/engines/engine[2]/fuel-pump",0);
    setprop("controls/engines/engine[3]/magnetos",0);
    setprop("controls/engines/engine[3]/fuel-pump",0);
}

  # helper functions and variables for STARTUP
  var setVoltSel = func{
    setprop("controls/switches/volts-select-dc",1);
    switch2SoundToggle();
  }  
  var setBattCart = func{
    setprop("controls/switches/battery-cart",1);
    switch1SoundToggle();
  }
  var setBattShip = func{
    setprop("controls/switches/battery-ship",1);
    switch1SoundToggle();
  }
  var setGen1 = func{
    setprop("controls/switches/generator[0]/position",1);
    switch1SoundToggle();
  }
  var setGen2 = func{
    setprop("controls/switches/generator[1]/position",1);
    switch1SoundToggle();
  }
  var setGen3 = func{
    setprop("controls/switches/generator[2]/position",1);
    switch1SoundToggle();
  }
  var setGen4 = func{
    setprop("controls/switches/generator[3]/position",1);
    switch1SoundToggle();
  }
  var setAPU = func{
    setprop("controls/switches/gen-apu",1);
    switch1SoundToggle();
  }
  var setMixture= func{
    interpolate("controls/engines/engine[0]/mixture", 1  , 1);
    interpolate("controls/engines/engine[1]/mixture", 1.8  , 1);
    interpolate("controls/engines/engine[2]/mixture", 1  , 1);
    interpolate("controls/engines/engine[3]/mixture", 2  , 1);
  }
  var setMag1= func{
    setprop("controls/engines/engine[0]/magnetos",3);
    switch1SoundToggle();
  }
  var setMag2= func{
    setprop("controls/engines/engine[1]/magnetos",3);
    switch1SoundToggle();
  }
  var setMag3= func{
    setprop("controls/engines/engine[2]/magnetos",3);
    switch1SoundToggle();
  }
  var setMag4= func{
    setprop("controls/engines/engine[3]/magnetos",3);
    switch1SoundToggle();
  }
  var setStart1 = func{
    setprop("controls/engines/engine[1]/starter",0);
    setprop("controls/switches/engine-start-select",1);
    switch2SoundToggle();
    Lockheed1049h.engine_starter();
  }
  var setStart2 = func{
    setprop("controls/engines/engine[3]/starter",0);
    setprop("controls/switches/engine-start-select",2);
    switch2SoundToggle();
    Lockheed1049h.engine_starter();
  }
  var setStart3 = func{
    setprop("controls/switches/engine-start-select",3);
    switch2SoundToggle();
    Lockheed1049h.engine_starter();
  }
  var setStart4 = func{
    setprop("controls/engines/engine[2]/starter",0);
    setprop("controls/switches/engine-start-select",4);
    switch2SoundToggle();
    Lockheed1049h.engine_starter();
  }
  var setStartEnd= func{
    setprop("controls/engines/engine[0]/starter",0);
    setprop("controls/switches/engine-start-select",0);
    switch2SoundToggle();
  }

  var setAlt = func{
    setprop("controls/electric/engine[0]/generator",1);
    switch1SoundToggle();
  }
  var setAPAlt = func{
    setprop("autopilot/settings/target-altitude-ft",4000);
  }
  var setHdg = func{
    setprop("autopilot/settings/heading-bug-deg",getprop("orientation/heading-deg"));
  }
  var setAntiCol = func{
    setprop("controls/lighting/beacon",1);
    switch1SoundToggle();
  } 
  var setPanelLights = func{
    interpolate("controls/lighting/panel-norm", 1 , 1);
    switch2SoundToggle();    
    switch2SoundToggle();    
    switch2SoundToggle();    
    switch2SoundToggle();    
    switch2SoundToggle();
  }
  var setChartLights = func{
    interpolate("controls/lighting/chart", 1 , 1);
    switch2SoundToggle();    
    switch2SoundToggle();    
    switch2SoundToggle();    
    switch2SoundToggle();    
    switch2SoundToggle();
  }
  var setNavLights = func{
    setprop("controls/lighting/nav",1);
    switch1SoundToggle();
  }
  var setWingLights = func{
    setprop("controls/lighting/tail",1);
    switch1SoundToggle();
  }  
  var setTaxiLights = func{
    setprop("controls/lighting/taxi",1);
    switch1SoundToggle();
  }
  var openBrake = func{
    setprop("controls/gear/brake-parking",0);
  }

    # startup procedure
    #interpolate("engines/engine[0]/mixture", 1  , 1);
    #setprop("controls/engines/engine[0]/propeller-pitch",1);
    #setprop("controls/engines/engine[0]/magnetos",3);
    #switch1SoundToggle();


  # helper functions and variables for SHUTTDOWN


# ---------------- End of Autostart/stop -----------------------------

