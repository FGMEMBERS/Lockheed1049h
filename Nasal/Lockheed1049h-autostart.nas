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
#        <file>path-to-this-file/Lockheed1049h-autostart.nas</file>
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
#        <script>MyAircraft.complete_checklists("startup");</script>
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
# 4. Optionally, configure automated checklists using these properties:
#
#   <checklists>
#     ...
#     <auto>
#       <completed-message>Checklists complete</completed-message>
#       <startup-message>Running checklists, please wait ...</startup-message>
#       <timeout-message>Some checks failed.</timeout-message>
#       <timeout-sec>10</timeout-sec>
#       <wait-sec>3</wait-sec>
#     <auto>
#   </checklists>
#
################################################################################
 
var checklists = props.globals.getNode("sim/checklists");
 
# Root property tree path for auto checklists
#
var root = "sim/checklists/auto/";

# Flag to indicate that checklists are being completed automatically. This
# can be used in Nasal bindings in the checklists suppress a binding when
# autostart or shutdown is in progress, e.g. checklist items that display
# dialogs.
#
var active = props.globals.initNode(root~"active", 0, "BOOL");

# Timeout for completion of a checklist item.
#
var timeout_sec = props.globals.initNode(root~"timeout-sec", 10, "INT");
var started = props.globals.initNode(root~"started", 0.0, "DOUBLE");

# Wait time for on-ground starts. If the previous checklist item is not
# complete, the process waits this number of seconds before trying again.
#
var wait_sec = props.globals.initNode(root~"wait-sec", 3, "INT");

# Messages

var completed_message = props.globals.initNode(root~"completed-message",
    "Checklists complete."
);

var startup_message = props.globals.initNode(root~"startup-message",
    "Running checklists, please wait ..."
);

var timeout_message = props.globals.initNode(root~"timeout-message",
    "Some checks failed. Try completing checklist manually."
);

################################################################################

# Announces a message to the pilot
#
# @param message the message to display
#
var announce = func(message)
{
    setprop("sim/messages/copilot", message);
    logprint(3, message);
}

# Resets the timestamp used for checking timeouts
#
var reset_timeout = func()
{
    started.setValue(0.0);
}

# Return true if the timeout period has been exceeded
#
var timed_out = func()
{
    var elapsed = getprop("sim/time/elapsed-sec") - started.getValue();
    return started.getValue() and elapsed > timeout_sec.getValue();
}

# Waits for the completion of an item, setting a timestamp for timeouts
#
# @param node: the node containing the list of checklist indexes to run
# @param item: the checklist item node from which to start
#
var wait = func(node, item)
{
    var t = maketimer(wait_time(), func {complete(node, item);});
    t.singleShot = 1;
    t.start();

    if (!started.getValue()) {
        started.setValue(getprop("sim/time/elapsed-sec"));
    }
}

# If this is a ground start, use the wait time defined above. If this is an
# in-air start, only delay a fraction of a second.
#
var wait_time = func()
{
    return getprop("gear/gear/wow") ? wait_sec.getValue() : 0.1;
}
 
# Automatically complete a set of checklists defined by a series of indexes
# listed under the node argument. Not intended to be called from outside this
# script.
#
# @param node: the node containing the list of checklist indexes to run
# @param from: the checklist item node from which to start
#
var complete = func(node, from = nil)
{
    var previous_condition = nil;
    var skipping = from != nil;

    foreach (var index; node.getChildren("index")) {
        var checklist = checklists.getChild("checklist", index.getValue());
        foreach (var item; checklist.getChildren("item")) {
            var condition = item.getChild("condition");
            if (skipping) {
                if (!item.equals(from)) {
                    previous_condition = condition;
                    continue;
                }
                skipping = 0;
            }
            if (props.condition(previous_condition)) {
                reset_timeout();
            } else {
                if (timed_out()) {
                    var title = checklist.getChild("title").getValue();
                    announce(title~": "~timeout_message.getValue());
                    return;
                }
                wait(node, item);
                return;
            }
            if (!props.condition(condition)) {
                foreach (var binding; item.getChildren("binding")) {
                    active.setValue(1);
                    props.runBinding(binding);
                    active.setValue(0);
                }
            }
            previous_condition = condition;
        }
    }
    announce(completed_message.getValue());
}
 
################################################################################
 
# Complete a checklist sequence, typically called from a Nasal binding in a
# menu, e.g. autostart, but could be assigned to a controller button or even
# called from a listener.
#
# @param sequence the name of the checklist sequence to run.
#
var complete_checklists = func(sequence)
{
    var node = checklists.getChild(sequence);
    if (node != nil) {
        announce(startup_message.getValue());
        complete(node);
    } else {
        announce("Could not find checklist sequence called '"~sequence~"'");
    }
}
 
