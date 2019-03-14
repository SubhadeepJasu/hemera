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

using Gtk;

namespace Hemera.App {
    // Below main function is supposed to be cut from this file
    int main (string[] args) {
        Gtk.init (ref args);
        var mcc = new Hemera.Services.Connection ("127.0.0.1", "8181");
        mcc.init_ws ();
        var window = new Window ();
        window.title = "Mycroft placeholder UI";
        window.border_width = 10;
        window.window_position = WindowPosition.CENTER;
        window.set_default_size (350, 200);
        window.destroy.connect (Gtk.main_quit);
        
        var button = new Gtk.Button.with_label ("Send Message");
        window.add (button);
        window.show_all ();
        mcc.ws_message.connect ((type, smme) => {
            warning ("%s\n", smme);
        });
        button.clicked.connect (() => {
            //mcc.ws_send_message ("Who are you");
            mcc.ws_wake ();
        });

        Gtk.main ();
        return 0;
    }
}
