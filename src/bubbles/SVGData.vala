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
    public class SVGData {
        private string right_svg;
        private string left_svg;
        private Gtk.Image bubble_component;
        public SVGData (string background, string edge) {
            right_svg = ("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<svg
   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"
   xmlns:cc=\"http://creativecommons.org/ns#\"
   xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"
   xmlns:svg=\"http://www.w3.org/2000/svg\"
   xmlns=\"http://www.w3.org/2000/svg\"
   xmlns:xlink=\"http://www.w3.org/1999/xlink\"
   id=\"svg3508\"
   height=\"16\"
   width=\"16\"
   version=\"1.1\">
  <metadata
     id=\"metadata3513\">
    <rdf:RDF>
      <cc:Work
         rdf:about=\"\">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource=\"http://purl.org/dc/dcmitype/StillImage\" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <g
     id=\"g815\">
    <path
       id=\"path833\"
       d=\"M 0.49823025,0.79978025 V 15.449769\"
       style=\"fill:none;stroke:%s;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\" />
    <path
       id=\"path880\"
       d=\"M 0.5075453,0.79978025 C 0.89363775,9.4623042 14.821158,9.6828091 14.821158,9.6828091 c 0,0 -3.123468,3.1326539 -6.933412,4.5254399 -3.3580848,1.227601 -7.3802007,1.24152 -7.3802007,1.24152\"
       style=\"fill:%s;fill-opacity:1;stroke:%s;stroke-width:1.00269759;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:5;stroke-dasharray:none;stroke-opacity:0.94117647;paint-order:normal\" />
  </g>
</svg>").printf (background, background, edge);


        left_svg = ("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<svg
   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"
   xmlns:cc=\"http://creativecommons.org/ns#\"
   xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"
   xmlns:svg=\"http://www.w3.org/2000/svg\"
   xmlns=\"http://www.w3.org/2000/svg\"
   xmlns:xlink=\"http://www.w3.org/1999/xlink\"
   id=\"svg3508\"
   height=\"16\"
   width=\"16\"
   version=\"1.1\">
  <metadata
     id=\"metadata3513\">
    <rdf:RDF>
      <cc:Work
         rdf:about=\"\">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource=\"http://purl.org/dc/dcmitype/StillImage\" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <g
     id=\"g815\">
    <path
       id=\"path833\"
       d=\"M 15.510303,0.79978025 V 15.449769\"
       style=\"fill:none;stroke:%s;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\" />
    <path
       id=\"path880\"
       d=\"M 15.500988,0.79978025 C 15.114896,9.4623042 1.1873754,9.6828091 1.1873754,9.6828091 c 0,0 3.123468,3.1326539 6.933412,4.5254399 3.3580846,1.227601 7.3802006,1.24152 7.3802006,1.24152\"
       style=\"fill:%s;fill-opacity:1;stroke:%s;stroke-width:1.00269759;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:5;stroke-dasharray:none;stroke-opacity:0.94117647;paint-order:normal\" />
  </g>
</svg>").printf (background, background, edge);
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
    }
}
