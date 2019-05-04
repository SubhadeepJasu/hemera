/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
 * Copyright (c) 2018-2019 Hannes Schulze <haschu0103@gmail.com>
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
        public Hemera.Services.Connection mycroft_connection;
        public Hemera.Services.MessageManager mycroft_message_manager;
        public Hemera.Core.AppSearch app_search_provider;

        public HemeraApp () {
            Object (
                application_id: "com.github.SubhadeepJasu.hemera",
                flags: ApplicationFlags.HANDLES_COMMAND_LINE
            );
            version_string = "0.1.0";
            mycroft_connection = new Hemera.Services.Connection ("127.0.0.1", "8181");
            mycroft_message_manager = new Hemera.Services.MessageManager (mycroft_connection);
        }
        public MainWindow mainwindow;
        protected override void activate () {
            if (mainwindow == null) {
                mainwindow = new MainWindow (this);
                add_window (mainwindow);
            }
            var css_provider = new Gtk.CssProvider();
            try {
                css_provider.load_from_resource ("/com/github/SubhadeepJasu/hemera/css/style.css");
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
            Timeout.add (1000, () => {
                    mycroft_connection.init_ws ();
                    return false;
            });
            mycroft_connection.connection_established.connect (() => {
                Timeout.add (1000, () => {
                    mainwindow.present ();
                    mainwindow.set_launch_screen (1);
                    mainwindow.queue_draw ();
                    return false;
                });
            });
            mycroft_connection.connection_failed.connect (() => {
                mainwindow.present ();
                mainwindow.set_launch_screen (0);
            });
            handle_application_launch_system ();
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
        private void handle_application_launch_system () {
            app_search_provider = new Hemera.Core.AppSearch ();
            mycroft_message_manager.receive_hemera_launch_app.connect ((query) => {
                try {
                    Hemera.Core.AppEntry launchable_app = app_search_provider.get_app_by_search (query);
                    launchable_app.launch ();
                    if (mainwindow != null) {
                        mainwindow.chat_launch_app (launchable_app);
                        Rand randomizer = new Rand ();
                        int random = randomizer.int_range (1, 4);
                        string open_word = "";
                        switch (random) {
                            case 1:
                                open_word = ("Opening %s").printf (launchable_app.app_name);
                                break;
                            case 2:
                                open_word = ("Alright, opening %s").printf (launchable_app.app_name);
                                break;
                            case 3:
                                open_word = ("Here's %s for you").printf (launchable_app.app_name);
                                break;
                            default:
                                open_word = ("Okay, launching %s").printf (launchable_app.app_name);
                                break;
                        }
                        mycroft_message_manager.send_speech (open_word);
                        if (mainwindow != null) {
                            mainwindow.set_chat_message_override (open_word);
                        }
                    }
                } catch (Error e) {
                    mycroft_message_manager.send_speech (e.message);
                    warning (e.message);
                }
            });
        }
        private void close_window () {
            if (mainwindow != null) {
                mainwindow.destroy ();
                mainwindow = null;
            }
        }
        
        public static int main (string[] args) {
            var app = new Hemera.App.HemeraApp ();
            var ret = app.run (args);
            return ret;
        }
    }
}
