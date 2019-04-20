/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Subhadeep Jasu
 */
using GLib;

namespace Hemera.Core {
    public class AppEntry {
        public Icon   app_icon;
        public string app_name;
        public string app_exec;
	    public string app_desc;
	    public string desktop_file_name;
        public GLib.AppInfo app_info;
        public DesktopAppInfo desktop_app_info;
        public bool options_available = false;
        public List<string> app_action_name;
        public List<string> app_action_command;

        public AppEntry (AppInfo app_info) {
            this.app_info = app_info;
            desktop_app_info = new DesktopAppInfo (this.app_info.get_id ());
            app_name = this.app_info.get_display_name ();
            app_icon = this.app_info.get_icon ();
            if (app_icon == null) {
			    app_icon = new ThemedIcon ("application-default-icon");
		    }
		    app_exec = this.app_info.get_commandline();
	        app_desc = this.app_info.get_description () ?? app_name;

            app_action_name    = new List<string> ();
            app_action_command = new List<string> ();

	        foreach (unowned string _action in desktop_app_info.list_actions()) {
                string action = _action.dup ();
                app_action_name.append (desktop_app_info.get_action_name (action));
                app_action_command.append (action);
            }
        }
        public void launch () {
		    try {
                if(app_info != null) {
			        app_info.launch(null, null);
                }
		    }
		    catch (Error e) {
			    warning ("Failed to launch %s: %s", app_name, app_exec);
		    }
	    }
    }
}
