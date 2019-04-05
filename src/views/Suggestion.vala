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
    public class SuggestionBox : Gtk.Grid {
        private Gtk.Label label;
        public SuggestionBox (string suggestion, int type = 0) {
            label = new Gtk.Label (suggestion);
            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.CENTER;
            if (type == 0) {
                get_style_context ().add_class ("suggest_box_red");
            }
            attach (label, 0, 0, 1, 1);
            label.margin = 4;
            label.margin_start = 12;
            label.margin_end = 12;
            label.justify = Gtk.Justification.CENTER;
        }
    }
    public class SuggestionArea : Gtk.Grid {
        SuggestionBox suggest_box;
        construct {
            suggest_box = new SuggestionBox ("How's the weather now?", 0);
            attach (suggest_box, 0, 0, 1, 1);
        }
    }
}
