/*-
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
 * Authored by: Hannes Schulze
 */

namespace Hemera.App {
    public class EmptySpaceOverlay : Gtk.Overlay {

        private class OverlayWidget : Gtk.Bin {
            public string background { get; set; }

            public OverlayWidget (string background, bool direction) {
                set_size_request (2, 5);
                this.background = background;
                notify.connect (() => { queue_draw (); });
                margin_bottom = 9;

                if (direction) {
                    halign = Gtk.Align.END;
                    valign = Gtk.Align.END;
                } else {
                    halign = Gtk.Align.START;
                    valign = Gtk.Align.END;
                }
            }

            public override void get_preferred_width (out int min_w, out int natural_w) {
                min_w = 2;
                natural_w = 2;
            }

            public override void get_preferred_height (out int min_h, out int natural_h) {
                min_h = 5;
                natural_h = 5;
            }

            public override bool draw (Cairo.Context cr) {
                cr.save ();

                Gdk.Color parsed_color;
                Gdk.Color.parse (background, out parsed_color);

                double red = (double) parsed_color.red / (double) uint16.MAX;
                double green = (double) parsed_color.green / (double) uint16.MAX;
                double blue = (double) parsed_color.blue / (double) uint16.MAX;

                cr.set_source_rgb (red, green, blue);
                cr.rectangle (0, 0, 2, 5);
                cr.fill ();

                cr.restore ();

                return base.draw (cr);
            }
        }

        private OverlayWidget overlay_widget;

        public string background {
            get {
                return overlay_widget.background;
            }
            set {
                overlay_widget.background = value;
            }
        }

        public EmptySpaceOverlay (string background, bool direction) {
            overlay_widget = new OverlayWidget (background, direction);
            add_overlay (overlay_widget);
        }
    }
}
