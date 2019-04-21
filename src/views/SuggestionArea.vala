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
 */

namespace Hemera.App {
    public class SuggestionArea : Gtk.ScrolledWindow {
        SuggestionBox suggest_box1;
        SuggestionBox suggest_box2;
        SuggestionBox suggest_box3;
        SuggestionBox suggest_box4;
        SuggestionBox suggest_box5;
        SuggestionBox suggest_box6;
        construct {
            var suggest_grid = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4);
            suggest_box1 = new SuggestionBox ("How's the weather now?", 2);
            suggest_box2 = new SuggestionBox ("What time is it?", 1);
            suggest_box3 = new SuggestionBox ("What's in the news?", 0);
            suggest_box4 = new SuggestionBox ("What is Linux?",5);
            suggest_box5 = new SuggestionBox ("Play my music", 4);
            suggest_box6 = new SuggestionBox ("Open Melody",3);
            suggest_grid.pack_start (suggest_box1);
            suggest_grid.pack_start (suggest_box2);
            suggest_grid.pack_start (suggest_box3);
            suggest_grid.pack_start (suggest_box4);
            suggest_grid.pack_start (suggest_box5);
            suggest_grid.pack_start (suggest_box6);
            suggest_grid.halign = Gtk.Align.START;
            suggest_grid.margin_bottom = 4;
            add (suggest_grid);
        }
    }
}
