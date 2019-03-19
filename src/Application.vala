/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
 * Copyright (c) 2018-2019 Hannes Schulze
 * Copyright (c) 2018-2019 Christopher M
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
 * Authored by: Subhadeep Jasu <subhajasu@gmail.com>
 *              Hannes Schulze
 */

namespace Hemera.App {
    public class HemeraApp : Gtk.Application {
        static HemeraApp _instance = null;
        public static HemeraApp instance {
            get {
                if (_instance == null) {
                    _instance = new HemeraApp ();
                }
                return _instance;
            }
        }
        private string version_string = "";

        public HemeraApp (){
            Object (
                application_id: "com.github.SubhadeepJasu.hemera",
                flags: ApplicationFlags.HANDLES_COMMAND_LINE
            );
            version_string = "0.1.0";
        }
        public MainWindow mainwindow;
        protected override void activate () {
            if (mainwindow == null) {
                mainwindow = new MainWindow ();
                add_window (mainwindow);
            }
            var css_provider = new Gtk.CssProvider();
            try {
                css_provider.load_from_resource ("/com/github/SubhadeepJasu/hemera/Application.css");
            }
            catch (Error e) {
                warning("%s", e.message);
            }
            // CSS Provider
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default(),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
            mainwindow.present ();
        }
        public override int command_line (ApplicationCommandLine cmd) {
            command_line_interpreter (cmd);
            return 0;
        }
        private void command_line_interpreter (ApplicationCommandLine cmd) {
            string[] cmd_args = cmd.get_arguments ();
            unowned string[] args = cmd_args;
            
            bool version = false, show_preferences = false;
            OptionEntry[] option = new OptionEntry[3];
		    option[0] = { "version", 0, 0, OptionArg.NONE, ref version, "Display version number", null };
            option[1] = { "show-preferences", 0, 0, OptionArg.NONE, ref show_preferences, "Display Preferences Window", null };
            option[2] = { null };
            
            var option_context = new OptionContext ("actions");
            option_context.add_main_entries (option, null);
            try {
                option_context.parse (ref args);
            } catch (Error err) {
                warning (err.message);
                return;
            }
            
            if (version) {
                cmd.print ("%s\n",version_string);
            }
            else if (show_preferences) {
                var prefs = new PreferencesWindow ();
                prefs.show_all ();
                add_window (prefs);
            }
            else {
                activate ();
            }
        }
        private void close_window () {
            if (mainwindow != null) {
                mainwindow.destroy ();
                mainwindow = null;
            }
        }
        
        public static int main (string[] args) {
            var app = new Hemera.App.HemeraApp ();
            return app.run (args);
        }
    }
}
