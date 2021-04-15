/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
 * Copyright (c) 2018-2019 Hannes Schulze <haschu0103@gmail.com>
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
 *              Hannes Schulze
 */

namespace Hemera.App {
    public class SwitchBoardBubble : Gtk.Grid {
        private const int ICON_SIZE = 64;
        private new Granite.AsyncImage image;
        private SVGData svg;
        Gtk.Label plug_name_label;
        Gtk.Label app_desc_label;
        public string app_exec;
        public string app_desc;
        private bool option_present = false;

        public SwitchBoardBubble (Hemera.Core.PlugInfo plug_info) {
            plug_name_label = new Gtk.Label (plug_info.app_name);
            plug_name_label.set_lines (1);
            plug_name_label.set_ellipsize (Pango.EllipsizeMode.END);
            plug_name_label.max_width_chars = 10;
            plug_name_label.justify = Gtk.Justification.LEFT;
            plug_name_label.xalign = 0;
            plug_name_label.margin_end = 16;
            plug_name_label.set_hexpand (true);
            plug_name_label.halign = Gtk.Align.START;
            plug_name_label.valign = Gtk.Align.END;
            plug_name_label.get_style_context ().add_class ("h2");

            var app_launching_label = new Gtk.Label ("Opening");
            app_launching_label.halign = Gtk.Align.START;
            app_launching_label.valign = Gtk.Align.END;
            app_launching_label.get_style_context ().add_class ("h4");
            app_launching_label.margin_top = 12;

            app_desc_label = new Gtk.Label (plug_info.title);
            app_desc_label.justify = Gtk.Justification.LEFT;
            app_desc_label.xalign = 0;
            app_desc_label.margin_top = 4;
            app_desc_label.margin_start = 18;
            app_desc_label.margin_end = 16;
            app_desc_label.max_width_chars = 26;
            app_desc_label.wrap = true;
            app_desc_label.wrap_mode = Pango.WrapMode.WORD_CHAR;
            app_desc_label.get_style_context ().add_class ("app_bubble_h4");

            image = new Granite.AsyncImage.from_icon_name_async (plug_info.icon, Gtk.IconSize.DIALOG);
            image.pixel_size = ICON_SIZE;
            image.halign = Gtk.Align.START;
            image.margin_start = 14;
            image.margin_top = 6;
            image.margin_end = 6;

            svg = new SVGData ("#fafafa", "#abacae");
            var svg_image = new Gtk.Image.from_pixbuf (svg.get_call_out_image (false));
            svg_image.margin_bottom = 4;
            svg_image.halign = Gtk.Align.START;
            svg_image.valign = Gtk.Align.END;

            var box = new Gtk.Grid ();
            box.get_style_context ().add_class ("app_bubble");
            box.attach (image, 				 0, 0, 1, 2);
            box.attach (app_launching_label, 1, 0, 1, 1);
            box.attach (plug_name_label, 	 1, 1, 1, 1);
            box.attach (app_desc_label,      0, 2, 2, 1);

            var empty_space_overlay = new EmptySpaceOverlay ("#fafafa", false);
            empty_space_overlay.add (box);

            attach (svg_image, 0, 0, 1, 1);
            attach (empty_space_overlay, 1, 0, 1, 1);

            halign = Gtk.Align.START;
            valign = Gtk.Align.START;
            margin_bottom = 8;
            show_all ();
            animate_bubble ();
        }
        private void animate_bubble () {
            Timeout.add (0, () => {
                get_style_context ().add_class ("speech_bubble_start_animate");
                return false;
            });
        }
    }
}
