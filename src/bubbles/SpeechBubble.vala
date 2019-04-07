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
    public class SpeechBubble : Gtk.Grid {
        private Gtk.Label speech_text;
        private SVGData svg;
        public SpeechBubble (bool? direction = false, string speech) {
            speech_text = new Gtk.Label (speech);
            speech_text.margin = 16;
            speech_text.margin_top = 6;
            speech_text.margin_bottom = 6;
            if (direction) {
                speech_text.justify = Gtk.Justification.RIGHT;
            }
            else {
                speech_text.justify = Gtk.Justification.LEFT;
            }
            speech_text.max_width_chars = 30;
            speech_text.wrap = true;
            
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            box.pack_start (speech_text);
            if (direction) {
                svg = new SVGData ("#ececec", "#7e8087");
            }
            else {
                svg = new SVGData ("#e1edfb", "#0d52bf");
            }
            var image = new Gtk.Image.from_pixbuf (svg.get_call_out_image (direction));
            image.margin_bottom = 4;

            if (direction) {
                image.halign = Gtk.Align.END;
                image.valign = Gtk.Align.END;
                attach (box, 0, 0, 1, 1);
                attach (image, 1, 0, 1, 1);
            }
            else {
                image.halign = Gtk.Align.START;
                image.valign = Gtk.Align.END;
                attach (image, 0, 0, 1, 1);
                attach (box, 1, 0, 1, 1);
            }
            if (direction) {
                box.get_style_context ().add_class ("speech_bubble_right");
                halign = Gtk.Align.END;
            }
            else {
                box.get_style_context ().add_class ("speech_bubble_left");
                halign = Gtk.Align.START;
            }
            valign = Gtk.Align.START;
            margin_bottom = 8;
        }
    }
}
