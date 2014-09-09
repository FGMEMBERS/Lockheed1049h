# Lockheed 1049h Constellation
#
# Fire up the dialog menu system
#
# Gary Neely aka 'Buckaroo'


Menu = {};

Menu.new = func {
  obj = { parents : [Menu],
          crew : nil,
          fuel : nil,
          radios : nil,
          menu : nil
        };
  obj.init();
  return obj;
};

Menu.init = func {
  me.menu = gui.Dialog.new("/sim/gui/dialogs/Lockheed1049/menu/dialog",
                           "Aircraft/Lockheed1049h/Dialogs/Lockheed1049h-menu.xml");
  me.radios = gui.Dialog.new("/sim/gui/dialogs/Lockheed1049/radios/dialog",
                           "Aircraft/Lockheed1049h/Dialogs/Lockheed1049h-radios.xml");
}
