/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
 * Copyright (c) 2018-2019 Hannes Schulze <haschu0103@gmail.com>
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
 * Authored by: Subhadeep Jasu
 */

namespace Hemera.App {
    public class QnABubble : Gtk.Grid {
        private Gtk.Label speech_text;
        private SVGData svg;
        public QnABubble (string query, string speech, string skill_id, double? confidence = 0.5) {
            speech_text = new Gtk.Label (speech);
            speech_text.margin = 16;
            speech_text.margin_top = 6;
            speech_text.margin_bottom = 6;
            speech_text.justify = Gtk.Justification.LEFT;
            speech_text.max_width_chars = 30;
            speech_text.wrap = true;
            speech_text.wrap_mode = Pango.WrapMode.WORD_CHAR;
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.pack_start (speech_text);
            
            var launch_button = new Gtk.Button.from_icon_name ("internet-web-browser", Gtk.IconSize.LARGE_TOOLBAR);
            launch_button.get_style_context ().add_class ("qna_launch_button");
            box.pack_end (launch_button);

            svg = new SVGData ("#fafafa", "#abacae");
            var image = new Gtk.Image.from_pixbuf (svg.get_call_out_image (false));
            image.margin_bottom = 4;
            image.halign = Gtk.Align.START;
            image.valign = Gtk.Align.END;
            attach (image, 0, 0, 1, 1);
            attach (box, 1, 0, 1, 1);
            box.get_style_context ().add_class ("qna_bubble");
            halign = Gtk.Align.START;
            valign = Gtk.Align.START;
            margin_bottom = 8;
            show_all ();
            
            
            if (skill_id == "fallback-wolfram-alpha.mycroftai") {
                launch_button.clicked.connect (() => {
                    var qry = query.replace ("%", "%25");
                    qry = qry.replace ("+", "%2B");
                    qry = qry.replace (" ", "+");
                    AppInfo.launch_default_for_uri (("https://www.wolframalpha.com/input/?i=%s").printf (qry), null);
                });
            }
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
