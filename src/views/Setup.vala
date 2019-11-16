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
    public class Setup : Gtk.Grid {
        public signal void setup_launch_mycroft ();
        MainWindow window;

        Gtk.Entry  ip_address_entry;
        Gtk.Entry  port_entry;
        Gtk.Switch rewrite_settings_switch;

        string location = "";
        public Setup (MainWindow window) {
            this.window = window;
            var header_label = new Gtk.Label ("Hemera Setup");
            header_label.get_style_context ().add_class ("h2");
            var ip_address_label = new Gtk.Label ("Mycroft Server Address");
            ip_address_label.halign = Gtk.Align.END;
            ip_address_entry = new Gtk.Entry ();
            ip_address_entry.set_placeholder_text ("IP Address");
            ip_address_entry.set_text ("127.0.0.1"); 
            ip_address_entry.set_max_length (15);
            ip_address_entry.width_chars = 15;
            port_entry = new Gtk.Entry ();
            port_entry.width_chars = 5;
            port_entry.max_width_chars = 5;
            port_entry.set_max_length (5);
            port_entry.set_placeholder_text ("Port");
            port_entry.set_text ("8181"); 
            var location_label = new Gtk.Label ("Mycroft Core Folder");
            location_label.halign = Gtk.Align.END;
            var location_entry = new Gtk.Entry ();
            location_entry.set_placeholder_text ("Mycroft Core Root Folder");

            string user_home_directory = GLib.Environment.get_home_dir ();
            location_entry.set_text (user_home_directory.concat ("/mycroft-core"));
            location_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "folder-open-symbolic");

            Gtk.Label settings_rewrite_consent = new Gtk.Label ("Rewrite Mycroft Settings");
            rewrite_settings_switch = new Gtk.Switch ();
            rewrite_settings_switch.margin_right = 63;
            rewrite_settings_switch.set_active (true);

            var launching_spinner = new Gtk.Spinner ();
            launching_spinner.start ();
            launching_spinner.opacity = 0.0;

            var connect_button = new Gtk.Button.with_label ("Save & Connect");
            connect_button.get_style_context ().add_class(Gtk.STYLE_CLASS_SUGGESTED_ACTION);

            Gtk.Label install_mycroft_label = new Gtk.Label ("Mycroft is like my soul, get it from ");
            install_mycroft_label.halign = Gtk.Align.END;
            install_mycroft_label.opacity = 0.50;
            Gtk.LinkButton install_mycroft_link = new Gtk.LinkButton.with_label ("https://github.com/MycroftAI/mycroft-core", "their GitHub.");
            install_mycroft_link.halign = Gtk.Align.START;

            Gtk.HBox note_grid = new Gtk.HBox (false, 0);
            note_grid.pack_start (install_mycroft_label);
            note_grid.pack_end (install_mycroft_link);


            attach (header_label, 0, 0, 3, 1);
            attach (ip_address_label, 0, 1, 1, 1);
            attach (ip_address_entry, 1, 1, 1, 1);
            attach (port_entry, 2, 1, 1, 1);
            attach (location_label, 0, 2, 1, 1);
            attach (location_entry, 1, 2, 2, 1);
            attach (settings_rewrite_consent, 0, 3, 1, 1);
            attach (rewrite_settings_switch, 1, 3, 1, 1);
            attach (connect_button, 1, 4, 2, 1);
            attach (note_grid, 0, 5, 3, 1);

            column_spacing = 8;
            row_spacing     = 8;
            valign = Gtk.Align.CENTER;
            halign = Gtk.Align.CENTER;

            connect_button.clicked.connect (() => {
                save_connection_settings ();
                launching_spinner.opacity = 1.0;
                Timeout.add (1000, () => {
                    this.setup_launch_mycroft ();
                    return false;
                });
            });

            location_entry.icon_release.connect ((pos, event) => {
                location = choose_folder ();
                location_entry.set_text (location);
            });

            show_all ();
        }
        public string? choose_folder () {
            string? return_value = null;
    
            Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
                _ ("Select a folder."), window, Gtk.FileChooserAction.SELECT_FOLDER,
                _ ("Cancel"), Gtk.ResponseType.CANCEL,
                _ ("Open"), Gtk.ResponseType.ACCEPT);
    
            var filter = new Gtk.FileFilter ();
            filter.set_filter_name (_ ("Folder"));
            filter.add_mime_type ("inode/directory");
    
            chooser.add_filter (filter);
    
            if (chooser.run () == Gtk.ResponseType.ACCEPT) {
                return_value = chooser.get_file ().get_path ();
            }
    
            chooser.destroy ();
            return return_value;
        }
        
        private void save_connection_settings () {
            var settings = Hemera.Configs.Settings.get_default ();
            settings.mycroft_location = this.location;
            settings.mycroft_ip = this.ip_address_entry.get_text ();
            settings.mycroft_port = this.port_entry.get_text ();
        }
    }
}