# Lockheed 1049H Constellation
#
# Initialization routines
#	fire up the fuel system
#	set up autopilot (deprecated)
#	set up menu dialogs
#
# Gary Neely aka 'Buckaroo'


LockheedMain = {};

LockheedMain.new = func {
  obj = { parents : [LockheedMain]
        };
  obj.init();
  return obj;
}

								# Custom autopilot deprecated by CVS changes
#LockheedMain.sec2cron = func {
#  autopilotsystem.schedule();
#  settimer(func{ me.sec2cron(); },autopilotsystem.AUTOPILOTSEC);
#}

								# Determines values carried between sessions
LockheedMain.savedata = func {
  aircraft.data.add("/sim/presets/fuel");			# User's default fuel load selection
  aircraft.data.add("/systems/seat/presets/z-offset-m");	# User's pilot seat view selections
  aircraft.data.add("/systems/seat/presets/y-offset-m");
  aircraft.data.add("/systems/seat/presets/pitch-offset-deg");
  #aircraft.data.add("/sim/current-view/z-offset-m");
  #aircraft.data.add("/sim/current-view/y-offset-m");
  #aircraft.data.add("/sim/current-view/pitch-offset-deg");
}


# global variables in Lockheed1049h namespace, for call by XML
LockheedMain.instantiate = func {
   #globals.Lockheed1049h.autopilotsystem = Autopilot.new();
   globals.Lockheed1049h.menusystem = Menu.new();
}

LockheedMain.init = func {
   me.instantiate();
   aircraft.livery.init("Models/Liveries");
   InstrumentationInit();					# See Lockheed1049h_instrumentation_drivers.nas
   me.savedata();  						# Initiate save on exit, restore on launch stuff
}


L1049hL = setlistener("/sim/signals/fdm-initialized", func {
  theconstellation = LockheedMain.new();
  removelistener(L1049hL);
  }
);
