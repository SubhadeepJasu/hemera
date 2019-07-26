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
    public class Installer : Gtk.Grid {
        Gtk.Label progressbar_label;
        Gtk.ProgressBar progressbar_downloading;
        Gtk.ProgressBar progressbar_installer;
        private Hemera.Core.MycroftManager mycroft_system;
        bool installing = true;

        public Installer () {
            mycroft_system = new Hemera.Core.MycroftManager ();
            var logo = new Gtk.Spinner ();
            logo.active = true;
            logo.get_style_context ().add_class ("mycroft-logo");
            logo.width_request = 64;
            logo.height_request = 64;
            logo.margin_bottom = 75;
            logo.halign = Gtk.Align.CENTER;
            
            progressbar_label = new Gtk.Label (null);
            progressbar_label.xalign = 0;
            progressbar_label.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
            progressbar_label.margin_bottom = 4;
            
            progressbar_downloading = new Gtk.ProgressBar ();
            progressbar_downloading.hexpand = true;
            
            progressbar_installer = new Gtk.ProgressBar ();
            progressbar_installer.hexpand = true;
            progressbar_installer.width_request = 250;
            
            margin_end = 22;
            margin_start = 22;
            margin_top = 90;
            attach (logo, 0, 0, 2, 1);
            attach (progressbar_label, 0, 1, 1, 1);
            attach (progressbar_downloading, 0, 2, 1, 1);
            attach (progressbar_installer, 1, 2, 1, 1);
            
            column_spacing = 8;
            mycroft_system.mycroft_downloading.connect ((progress) => {
                progressbar_label.label = "Downloading...";
                progressbar_downloading.fraction = progress;
            });
            mycroft_system.mycroft_extracting.connect ((progress) => {
                progressbar_label.label = "Extracting...";
                //progressbar_installer.fraction = progress;
            });
            mycroft_system.mycroft_installing.connect (() => {
                queue_draw ();
                progressbar_label.label = "Installing, It will take a long time...";
                double i = 0;
                Timeout.add (10, () => {
                    //progressbar_installer.pulse ();

                    progressbar_installer.set_fraction (i+=0.00005);
                    return installing;
                });
            });
            mycroft_system.mycroft_finished_installation.connect (() => {
                progressbar_label.label = "Installation Complete!";
                installing = false;
                progressbar_installer.fraction = 1.0;
                queue_draw ();
            });
        }
        public void download_mycroft () {
            mycroft_system.check_updates ();
            mycroft_system.mycroft_update_available.connect ((tag, body, download_url) => {
                print ("Update Available! Version: %s\nWhat's new:\n\n%s\n", tag, body);
                mycroft_system.download_mycroft (download_url);
                mycroft_system.extract_mycroft ("/tmp/.mycroft-core.tar.gz");
            });
        }
    }
}
