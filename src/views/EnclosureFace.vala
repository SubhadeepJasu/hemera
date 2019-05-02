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
    public class EnclosureFace : Gtk.Box {
        Gtk.Spinner main_icon;
        public EnclosureFace () {
            main_icon = new Gtk.Spinner ();
            main_icon.active = true;
            main_icon.get_style_context ().add_class ("mic");
            main_icon.halign = Gtk.Align.START;
            main_icon.valign = Gtk.Align.START;
            main_icon.width_request = 64;
            main_icon.height_request = 64;
            pack_start (main_icon);
            get_style_context ().add_class ("enclosure-face");
        }
        public void mic_set_listening () {
            main_icon.get_style_context ().add_class ("listening");
        }
        public void mic_set_default () {
            main_icon.get_style_context ().remove_class ("listening");
        }
        public void mic_set_listen_failed () {
            main_icon.get_style_context ().add_class ("error");
            Timeout.add (100, () => {
                main_icon.get_style_context ().remove_class ("error");
                return false;
            });
        }
        public void mic_personify_idle () {
            main_icon.get_style_context ().add_class ("personify-idle");
        }
        public void mic_personify_blink (int i_side) {
            switch (i_side) {
                case 0:
                    main_icon.get_style_context ().add_class ("personify-blink-both");
                    Timeout.add (100, () => {
                        main_icon.get_style_context ().remove_class ("personify-blink-both");
                        return false;
                    });
                    break;
                case 1:
                    main_icon.get_style_context ().add_class ("personify-blink-left");
                    Timeout.add (100, () => {
                        main_icon.get_style_context ().remove_class ("personify-blink-left");
                        return false;
                    });
                    break;
                case 2:
                    main_icon.get_style_context ().add_class ("personify-blink-right");
                    Timeout.add (10, () => {
                        main_icon.get_style_context ().remove_class ("personify-blink-right");
                        return false;
                    });
                    break;
            }
            warning ("BLINK////////////////////");
        }
        public void disable_personification () {
            main_icon.get_style_context ().remove_class ("personify-idle");
            main_icon.get_style_context ().remove_class ("personify-blink-both");
            main_icon.get_style_context ().remove_class ("personify-blink-left");
            main_icon.get_style_context ().remove_class ("personify-blink-right");
        }
    }
}
