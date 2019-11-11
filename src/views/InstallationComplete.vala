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

namespace Hemera.App {
    public class InstallerComplete : Gtk.Grid {
        Gtk.Label installation_complete_label;
        Gtk.Button launch_mycroft_button;
        Gtk.Spinner launching_spinner;

        public signal void ui_launch_mycroft ();
        construct {
            installation_complete_label = new Gtk.Label ("Installation Complete!");
            installation_complete_label.get_style_context().add_class("h2");
            launch_mycroft_button = new Gtk.Button.with_label ("    Wake me    ");
            launch_mycroft_button.get_style_context ().add_class(Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            
            launching_spinner = new Gtk.Spinner ();
            launching_spinner.start ();
            launching_spinner.opacity = 0;

            attach (installation_complete_label, 0, 0, 1, 1);
            attach (launch_mycroft_button, 0, 1, 1, 1);
            attach (launching_spinner, 0, 2, 1, 1);

            valign = Gtk.Align.CENTER;
            halign = Gtk.Align.CENTER;
            row_spacing = 4;

            launch_mycroft_button.clicked.connect (() => {
                launching_spinner.opacity = 1;
                Timeout.add (1000, () => {
                    this.ui_launch_mycroft ();
                    return false;
                });
            });

            show_all ();
        }
    }
}