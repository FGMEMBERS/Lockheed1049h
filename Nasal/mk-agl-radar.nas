#setlistener("/instrumentation/aglradar/power-btn", func (state){
#  var state = state.getBoolValue() or 0;
#  if (state) agl_radar_control();
#});


var agl_radar_control = func {
  #var state = props.globals.getNode("/instrumentation/aglradar/power-btn");
  #if(state.getBoolValue()){
    #print("AGL Radar running ... ok");
    var agl = getprop("/position/altitude-agl-ft");
    var aglft = agl - 7.63;
    var aglm = aglft * 0.3048;
    setprop("/position/gear-agl-ft", aglft);
    setprop("/position/gear-agl-m", aglm);

    settimer(agl_radar_control, 0.5);
  #}
}


agl_radar_control();
