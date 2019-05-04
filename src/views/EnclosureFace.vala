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
    public enum AnimationType {
        IDLE = 0,
        ERROR = 1,
        DEFAULT_SPEAKING = 2,
        SYSTEM_SPEAKING = 3,
        HAPPY_SPEAKING = 4,
        THINKING = 5,
        ANXIOUS_SPEAKING = 6
    }
    public class EnclosureFace : Gtk.Box {
        Gtk.Spinner main_icon;
        private bool eyes_idle_animate_loop = false;
        private int eye_position_left = 26;
        private int eye_position_top = 28;
        private Gtk.CssProvider provider;
        private string provider_data;
        private int eye_left = 0;
        private int eye_top = 0;
        public EnclosureFace () {
            main_icon = new Gtk.Spinner ();
            main_icon.active = true;
            main_icon.halign = Gtk.Align.START;
            main_icon.valign = Gtk.Align.START;
            main_icon.width_request = 64;
            main_icon.height_request = 64;
            get_style_context ().add_class ("enclosure-face-preload");
            pack_start (main_icon);
            provider = new Gtk.CssProvider ();
        }
        public void animate_face () {
            get_style_context ().remove_class ("enclosure-face-preload");
            get_style_context ().add_class ("enclosure-face");
            main_icon.get_style_context ().add_class ("mic");
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
            enable_eyes_animation ();
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
                    Timeout.add (100, () => {
                        main_icon.get_style_context ().remove_class ("personify-blink-right");
                        return false;
                    });
                    break;
            }
        }
        public void disable_personification () {
            disable_eyes_animation ();
            main_icon.get_style_context ().remove_class ("personify-idle");
            main_icon.get_style_context ().remove_class ("personify-blink-both");
            main_icon.get_style_context ().remove_class ("personify-blink-left");
            main_icon.get_style_context ().remove_class ("personify-blink-right");
        }
        private void enable_eyes_animation () {
            eyes_idle_animate_loop = true;
            Timeout.add (1500, () => {
                eye_top = GLib.Random.int_range (-1, 2);
                eye_left = GLib.Random.int_range (-1, 2);
                if (eyes_idle_animate_loop) {
                    provider_data = (".enclosure-face {	padding-top: %dpx; padding-left: %dpx; }").printf (eye_top + eye_position_top, eye_left + eye_position_left);
                } else {
                    provider_data = ".enclosure-face {	padding-top: 28px; padding-left: 26px; }";
                }
                try {
                    provider.load_from_data (provider_data);
                    Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
                }
                catch (Error e) {
                    warning (e.message);
                }
                return eyes_idle_animate_loop;
            });
        }
        private void disable_eyes_animation () {
            eyes_idle_animate_loop = false;
        }
        public void set_volume_icon (int volume_level) {
            switch (volume_level) {
                case 0:
                    main_icon.get_style_context ().add_class ("system-volume-mute");
                    break;
                case 1:
                case 2:
                case 3:
                    main_icon.get_style_context ().add_class ("system-volume-low");
                    break;
                case 4:
                case 5:
                case 6:
                case 7:
                    main_icon.get_style_context ().add_class ("system-volume-medium");
                    break;
                default:
                    main_icon.get_style_context ().add_class ("system-volume-high");
                    break;
            }
            Timeout.add (1000, () => {
                main_icon.get_style_context ().remove_class ("system-volume-mute");
                main_icon.get_style_context ().remove_class ("system-volume-low");
                main_icon.get_style_context ().remove_class ("system-volume-medium");
                main_icon.get_style_context ().remove_class ("system-volume-high");
                return false;
            });
        }
    }
}
