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
    public class ChatView : Gtk.Grid {
        Gtk.Entry utterance_entry;
        SuggestionArea suggest_area;
        public ChatView () {
            make_ui ();
        }
        private void make_ui () {
            var chat_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            var bubble  = new SpeechBubble (true, "Who are you");
            var bubble2 = new SpeechBubble (false, "I am Hemera. Nice to meet you!");
            chat_box.pack_start (bubble);
            chat_box.pack_start (bubble2);
            chat_box.valign = Gtk.Align.START;
            var scrollable = new Gtk.ScrolledWindow (null, null);
            scrollable.height_request = 196;
            scrollable.add (chat_box);
            utterance_entry = new Gtk.Entry ();
            utterance_entry.width_chars = 39;
            utterance_entry.max_width_chars = 39;
            utterance_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "mail-send-symbolic");
            
            suggest_area = new SuggestionArea ();

            attach (scrollable, 0, 0, 1, 1);
            attach (suggest_area, 0, 1, 1, 1);
            attach (utterance_entry, 0, 2, 1, 1);
            margin_start = 15;
        }
    }
}
