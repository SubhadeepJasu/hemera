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
        private static HemeraApp? _instance = null;
        private MainWindow mainwindow { get; private set; default = null; }


        private string version_string;

        private bool show_main_window = false;
        private bool show_preferences = false;
        private bool version = false;

        construct {
            application_id = "com.github.SubhadeepJasu.hemera";
            flags = ApplicationFlags.HANDLES_COMMAND_LINE;
            version_string = "0.1.0";
        }
        protected override void activate () {
            if (mainwindow == null && show_main_window && !show_preferences) {
                mainwindow = new MainWindow ();
                add_window (mainwindow);
                mainwindow.close.connect (close_window);
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
        }
        public override int command_line (ApplicationCommandLine cmd) {
            command_line_interpreter (cmd);
            return 0;
        }
        private void command_line_interpreter (ApplicationCommandLine cmd) {
            show_main_window = show_preferences = false;
            string[] cmd_args = cmd.get_arguments ();
            unowned string[] args = cmd_args;
            
            bool mem_to_clip = false;
            
            GLib.OptionEntry [] option = new OptionEntry [3];
            option [0] = { "version", 0, 0, OptionArg.NONE, ref version, "Display version number", null };
            option [1] = { "show_ui", 0, 0, OptionArg.NONE, ref show_main_window, "Display main window", null };
            option [2] = { "preferences", 0, 0, OptionArg.NONE, ref show_preferences, "Display preferences window", null };
            option [3] = { null };
            
            var option_context = new OptionContext ("actions");
            option_context.add_main_entries (option, null);
            try {
                option_context.parse (ref args);
            } catch (Error err) {
                warning (err.message);
                return;
            }
            
            if (version) {
			    stdout.printf ("%s\n", version_string);
			    return;
            }
            activate ();
        }
        private void close_window () {
            if (mainwindow != null) {
                mainwindow.destroy ();
                mainwindow = null;
            }
        }
        public static new HemeraApp get_default () {
            if (_instance == null) {
                _instance = new HemeraApp ();
            }
            return _instance;
        }
    }
}

int main (string[] args) {
    var app = Hemera.App.HemeraApp.get_default ();
    return app.run (args);
}
