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
 * Authored by: Subhadeep Jasu <subhajasu@gmail.com>
 */

namespace Hemera.App {
    public class InitSplash : Gtk.Grid {
        public signal void user_attempt_reconnect ();
        public class InitSplash () {
            var welcome = new Granite.Widgets.Welcome ("Hemera", "Your own personal digital assistant");
            welcome.append ("media-playback-start", "Start Mycroft", "Mycroft is my soul and I need it to function");
            welcome.append ("application-default-icon", "Setup Mycroft", "Mycroft not installed? Let me help you");

            welcome.activated.connect ((index) => {
                switch (index) {
                    case 0:
                        user_attempt_reconnect ();
                        break;
                    case 1:
                        try {
                            AppInfo.launch_default_for_uri ("https://github.com/elementary/granite", null);
                        } catch (Error e) {
                            warning (e.message);
                        }

                        break;
                }
            });
            add (welcome);
        }
    }
}
