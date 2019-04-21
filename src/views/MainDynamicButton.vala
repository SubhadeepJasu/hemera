/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
 * Copyright (c) 2018-2019 Hannes Schulze <haschu0103@gmail.com>
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
 */

namespace Hemera.App {
    public class MainDynamicButton : Gtk.Overlay {
        private Gtk.Button wake_button;
        private MainWindow window;
        public signal void clicked ();
        public MainDynamicButton (MainWindow window) {
            this.window = window;
            make_ui ();
            make_events ();
        }
        private void make_ui () {
            wake_button = new Gtk.Button.with_label ("Wake");
            wake_button.get_style_context ().add_class ("main_wake_button_pre_load");
            wake_button.get_style_context ().add_class ("main_wake_button");
            add_overlay (wake_button);
            width_request = 200;
            height_request= 200;
            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.CENTER;
            margin_top = 0;
            margin_bottom = 0;
        }
        private void make_events () {
            wake_button.clicked.connect (() => {
                this.clicked ();
            });
        }
        public void animate_button () {
            Timeout.add (100, () => {
                wake_button.get_style_context ().remove_class ("main_wake_button_pre_load");
                return false;
            });
        }
    }
}
