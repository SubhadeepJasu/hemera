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
    public class LightRingAnimator {
        private bool   b_animation_enabled;
        private string s_top_color = "#808080";
        private string s_center_color = "#6b6b6b";
        private string s_bottom_color = "#595959";
        private int i_center_stop = 50;

        private Gtk.CssProvider provider;
        private string provider_data;
        private Gtk.Button button;
        public LightRingAnimator (Gtk.Button button) {
            this.button = button;
            provider = new Gtk.CssProvider ();
        }
        
        public void begin_animation () {
            b_animation_enabled = true;
            Timeout.add (100, () => {
                animate ();
                return b_animation_enabled;
            });
        }
        public void end_animation () {
            b_animation_enabled = false;
        }
        public void set_animation_type (AnimationType a_type) {
            switch (a_type) {
                case AnimationType.SYSTEM_SPEAKING:
                    s_top_color = "#ce9ef8";
                    s_center_color = "#a56ce2";
                    s_bottom_color = "#743bb5";
                    break;
                case AnimationType.ERROR:
                    s_top_color = "#7f7f7f";
                    s_center_color = "#c32830";
                    s_bottom_color = "#e54f4f";
                    break;
                case AnimationType.DEFAULT_SPEAKING:
                    s_top_color = "#b081d0";
                    s_center_color = "#77a6d3";
                    s_bottom_color = "#61e4df";
                    break;
                default:
                    s_top_color = "#808080";
                    s_center_color = "#6b6b6b";
                    s_bottom_color = "#595959";
                    break;
            }
        }
        private void animate () {
            i_center_stop = GLib.Random.int_range (0, 100);
            provider_data = (".main_wake_button {background: linear-gradient(to bottom, %s 0%, %s %d%, %s 100%);}").printf (s_top_color, s_center_color, i_center_stop, s_bottom_color);
            try {
                provider.load_from_data (provider_data);
                Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            }
            catch (Error e) {
                warning (e.message);
            }
        }
    }
}
