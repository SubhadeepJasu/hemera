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
            main_icon.get_style_context ().add_class ("default-mic-icon");
            main_icon.halign = Gtk.Align.START;
            main_icon.valign = Gtk.Align.START;
            main_icon.width_request = 48;
            main_icon.height_request = 48;
            pack_start (main_icon);
            get_style_context ().add_class ("enclosure-face");
            
        }
    }
}
