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
    public class SVGData {
        private string right_svg;
        private string left_svg;
        private Gtk.Image bubble_component;
        public SVGData (string background, string edge) {
            right_svg = format_resource ("/com/github/SubhadeepJasu/hemera/images/bubbles/right.svg", background, edge);

            left_svg = format_resource ("/com/github/SubhadeepJasu/hemera/images/bubbles/left.svg", background, edge);
        }

        public Gdk.Pixbuf get_call_out_image (bool direction) {
            uint8[] svg_data;
            if (direction) {
                svg_data = right_svg.data;
            }
            else {
                svg_data = left_svg.data;
            }
            var input_stream_m = new MemoryInputStream.from_data (svg_data);
            var pixmp = new Gdk.Pixbuf.from_stream (input_stream_m);
            return pixmp;
        }

        private string format_resource (string resource_path, string background, string edge) {
            uint8[] resource_out;
            File file = File.new_for_uri ("resource:/" + resource_path);
            file.load_contents (null, out resource_out, null);
            return ((string) resource_out).printf (background, edge);
        }
    }
}
