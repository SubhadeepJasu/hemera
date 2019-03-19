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


        public HemeraApp (){
            Object (
                application_id: "com.github.SubhadeepJasu.hemera",
                flags: ApplicationFlags.FLAGS_NONE
            );
            warning ("initialized");
        }
        public MainWindow mainwindow;
        protected override void activate () {

            warning ("opened");
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
