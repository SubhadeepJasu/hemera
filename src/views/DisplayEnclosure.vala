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
 */

namespace Hemera.App {
    public class DisplayEnclosure : Gtk.Grid {
        private MainDynamicButton main_button;
        private Granite.Widgets.ModeButton invoke_mode_button;
        private Gtk.Button stop_button;
        private MainWindow window;

        public signal void wake_button_clicked ();
        public signal void invoke_mode_changed (int mode);

        public DisplayEnclosure (MainWindow window) {
            this.window = window;
            make_ui ();
            make_events ();
        }
        private void make_ui () {
            main_button = new Hemera.App.MainDynamicButton (window);
            stop_button = new Gtk.Button.from_icon_name ("media-playback-stop-symbolic", Gtk.IconSize.BUTTON);
            stop_button.margin_start = 90;
            stop_button.margin_end = 90;
            stop_button.margin_bottom = 6;
            stop_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            stop_button.get_style_context ().add_class ("rounded_button");
            stop_button.tooltip_text = "Stop";
            invoke_mode_button = new Granite.Widgets.ModeButton ();
            invoke_mode_button.append_text ("Verbal Invoke");
            invoke_mode_button.append_text ("Manual Invoke");
            invoke_mode_button.margin_start = 18;
            invoke_mode_button.margin_end = 18;
            invoke_mode_button.set_active (0);

            attach (main_button, 0, 0, 1, 1);
            attach (stop_button, 0, 1, 1, 1);
            attach (invoke_mode_button, 0, 2, 1, 1);
        }
        private void make_events () {
            main_button.clicked.connect (() => {
                wake_button_clicked ();
            });
            invoke_mode_button.mode_changed.connect (() => {
                invoke_mode_changed (invoke_mode_button.selected);
            });
        }
        public void animate_button () {
            main_button.animate_button ();
        }
    }
}
