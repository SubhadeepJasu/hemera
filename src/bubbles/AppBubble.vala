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
    public class AppBubble : Gtk.Grid {
        private const int ICON_SIZE = 64;
        private new Granite.AsyncImage image;
        private SVGData svg;
        Gtk.Label app_name_label;
        Gtk.Label app_desc_label;
        public string app_exec;
        public string app_desc;
        private Gtk.Grid options_menu;
        private bool option_present = false;

        public AppBubble (Hemera.Core.AppEntry app_data) {
            app_name_label = new Gtk.Label (app_data.app_name);
            app_name_label.set_lines (1);
            app_name_label.set_ellipsize (Pango.EllipsizeMode.END);
            app_name_label.max_width_chars = 10;
            app_name_label.justify = Gtk.Justification.LEFT;
            app_name_label.xalign = 0;
            app_name_label.margin_end = 16;
            app_name_label.set_hexpand (true);
            app_name_label.halign = Gtk.Align.START;
            app_name_label.valign = Gtk.Align.END;
            app_name_label.get_style_context ().add_class ("h2");

            var app_launching_label = new Gtk.Label ("Opening");
            app_launching_label.halign = Gtk.Align.START;
            app_launching_label.valign = Gtk.Align.END;
            app_launching_label.get_style_context ().add_class ("h4");
            app_launching_label.margin_top = 12;

            app_desc_label = new Gtk.Label (app_data.app_desc);
            app_desc_label.justify = Gtk.Justification.LEFT;
            app_desc_label.xalign = 0;
            app_desc_label.margin_top = 4;
            app_desc_label.margin_start = 18;
            app_desc_label.margin_end = 16;
            app_desc_label.max_width_chars = 26;
            app_desc_label.wrap = true;
            app_desc_label.wrap_mode = Pango.WrapMode.WORD_CHAR;
            app_desc_label.get_style_context ().add_class ("app_bubble_h4");

            image = new Granite.AsyncImage.from_gicon_async (app_data.app_icon, ICON_SIZE);
            image.pixel_size = ICON_SIZE;
            image.halign = Gtk.Align.START;
            image.margin_start = 14;
            image.margin_top = 6;
            image.margin_end = 6;
            options_menu = new Gtk.Grid ();
            options_menu.orientation = Gtk.Orientation.VERTICAL;
            options_menu.add (app_desc_label);
            foreach (unowned string _action in app_data.desktop_app_info.list_actions()) {
                string action = _action.dup ();
                var option_item = new Gtk.Button.with_label (app_data.desktop_app_info.get_action_name (action));
                option_item.set_hexpand (true);
                option_item.get_style_context ().add_class ("app_bubble_button");
                options_menu.add (option_item);
                option_item.clicked.connect (() => {
                    app_data.desktop_app_info.launch_action (action, new AppLaunchContext());
                });
                option_present = true;
            }
            var reveal_button = new Gtk.Button.from_icon_name ("view-more-horizontal-symbolic", Gtk.IconSize.BUTTON);
            reveal_button.get_style_context ().add_class ("reveal_button_light");
            var revealer = new Gtk.Revealer ();
            revealer.add (options_menu);
            reveal_button.clicked.connect (() => {
                if (revealer.get_reveal_child ()) {
                    revealer.set_reveal_child (false);
                }
                else {
                    revealer.set_reveal_child (true);
                }
            });
            revealer.set_transition_type (Gtk.RevealerTransitionType.SLIDE_DOWN);
            svg = new SVGData ("#fafafa", "#abacae");
            var svg_image = new Gtk.Image.from_pixbuf (svg.get_call_out_image (false));
            svg_image.margin_bottom = 4;
            svg_image.halign = Gtk.Align.START;
            svg_image.valign = Gtk.Align.END;

            var box = new Gtk.Grid ();
            box.get_style_context ().add_class ("app_bubble");
            box.attach (image, 				 0, 0, 1, 2);
            box.attach (app_launching_label, 1, 0, 1, 1);
            box.attach (app_name_label, 	 1, 1, 1, 1);
            box.attach (revealer,       	 0, 2, 2, 1);
            box.attach (reveal_button,       0, 3, 2, 1);

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
