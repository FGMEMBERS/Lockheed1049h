################################################################################
#
# Lockheed1049h: Autostart via checklists
#
# Copyright (c) 2015, Richard Senior
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
# This script assumes that you have complete checklist items that will
# start or shutdown the aircraft. It does not support delays between items or
# waiting for bindings to complete.
#
# Usage:
#
# 1. Include this file in the aircraft-set.xml as a Nasal script
#
#    For example:
#
#    <nasal>
#      ... other scripts
#      <MyAircraft>
#        <file>path-to-this-file/checklist.nas</file>
#      </MyAircraft>
#    </nasal>
#
# 2. Define a menu item that calls either the startup or shutdown function, or
#    toggles a startup state based on a property specific to your aircraft.
#
#    Remember to use the correct namespace, depending on configuration in (1).
#
#    For example:
#
#    <item>
#      <label>Autostart</label>
#      <binding>
#        <command>nasal</command>
#        <script>MyAircraft.startup();</script>
#      </binding>
#    </item>
#
# 3. In the aircraft-set.xml, define a list of checklist indexes to run
#    for startup (aka Autostart) and shutdown:
#
#    For example, in the aircraft-set.xml, to run checklists with indexes 0
#    and 1 for startup and checklist 9 for shutdown:
#
#   <checklists>
#     <checklist include="Checklists/before-starting-engines.xml"/>
#     <checklist include="Checklists/start-engines.xml"/>
#     ... more checklists here
#     <checklist include="Checklists/parking.xml"/>
#     <startup>
#       <index n="0">0</index> <!-- Before starting engines -->
#       <index n="1">1</index> <!-- Start engines -->
#     </startup>
#     <shutdown>
#       <index n="0">9</index> <!-- Parking -->
#     </startup>
#   </checklists>
#
################################################################################

var checklists = props.globals.getNode("sim/checklists");

# Flag to indicate that checklists are being completed automatically. This
# can be used in Nasal bindings in the checklists suppress a binding when
# autostart or shutdown is in progress, e.g. checklist items that display
# dialogs.
#
var auto = props.globals.initNode("sim/checklists/auto", 0, "BOOL");

# Automatically complete a set of checklists defined by a series of indexes
# listed under the node argument. Not intended to be called from outside this
# script.
#
var _complete = func(node)
{
    auto.setValue(1);
    foreach (var index; node.getChildren("index")) {
        var checklist = checklists.getChild("checklist", index.getValue());
        foreach (var item; checklist.getChildren("item")) {
            foreach (var binding; item.getChildren("binding")) {
                props.runBinding(binding);
            }
        }
    }
    auto.setValue(0);
}

# Startup function, typically called from a Nasal binding in a menu but could
# be assigned to a controller button, etc.
#
var startup = func
{
    _complete(checklists.getChild("startup"));
}

# Shutdown function, typically called from a Nasal binding in a menu but could
# be assigned to a controller button, etc.
#
var shutdown = func
{
    _complete(checklists.getChild("shutdown"));
}

