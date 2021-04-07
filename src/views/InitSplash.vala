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
        public signal void user_attempt_install ();
        public signal void user_attempt_reconnect ();
        public signal void user_attempt_setup ();
        public class InitSplash (bool showInstallOption) {
            var welcome = new Granite.Widgets.Welcome ("Hi! I am Hemera", "Mycroft is my soul and I need it");
            /* Below commented line is there as a potential future feature.
             * Uncomment the add the option to the list
             */
            welcome.append ("network-error", "Reconnect with Mycroft", "Attempt to reconnect with Mycroft");
            welcome.append ("preferences-system", "Hemera Setup",      "Locate Mycroft and set up connection");
            if (showInstallOption)
                welcome.append ("emblem-downloads", "Install Mycroft", "Download and install mycroft");

            welcome.activated.connect ((index) => {
                switch (index) {
                    case 0:
                        user_attempt_reconnect ();
                        break;
                    case 1:
                        user_attempt_setup ();
                        break;
                    default:
                        user_attempt_install ();
                        break;
                }
            });
            add (welcome);
        }
    }
}
