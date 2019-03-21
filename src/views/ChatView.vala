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
        public ChatView () {
            make_ui ();
        }
        private void make_ui () {
            var chat_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            chat_box.height_request = 230;
            utterance_entry = new Gtk.Entry ();
            utterance_entry.width_chars = 39;
            utterance_entry.max_width_chars = 39;
            utterance_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "mail-send-symbolic");
            attach (chat_box, 0, 0, 1, 1);
            attach (utterance_entry, 0, 1, 1, 1);
            margin_start = 15;
        }
    }
}
