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
    public class ChatView : Gtk.Grid {
        Gtk.Entry utterance_entry;
        SuggestionArea suggest_area;
        Gtk.ScrolledWindow scrollable;
        Gtk.Box chat_box;
        public string received_bubble_text;
        private int number_of_messages;
        private int max_number_of_messages = 15;
        
        public signal void send_message_text (string message);
        
        public ChatView () {
            make_ui ();
            make_events ();
        }
        private void make_ui () {
            chat_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            chat_box.valign = Gtk.Align.START;

            scrollable = new Gtk.ScrolledWindow (null, null);
            scrollable.height_request = 196;
            scrollable.get_style_context ().add_class ("chat-window");
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
        private void make_events () {
            number_of_messages = 0;
            received_bubble_text = "";
            utterance_entry.activate.connect (() => {
                send_message_text (utterance_entry.get_text ());
                utterance_entry.set_text ("");
            });
            utterance_entry.icon_release.connect (() => {
                send_message_text (utterance_entry.get_text ());
                utterance_entry.set_text ("");
            });
            chat_box.size_allocate.connect (() => {
                var adj = scrollable.get_vadjustment ();
                adj.set_value (adj.get_upper () - adj.get_page_size ());
                chat_box.queue_draw ();
            });
        }
        public void push_user_text (string utterance) {
            if (utterance != "") {
                if (number_of_messages >= max_number_of_messages) {
                    var bubble_list = chat_box.get_children ();
                    chat_box.remove (bubble_list.first ().nth_data (0));
                }
                chat_box.pack_start (new SpeechBubble (true, utterance));
                number_of_messages++;
            }
        }
        public void push_mycroft_text (string message) {
            if (message != "" && message != null && (received_bubble_text != message)) {
                if (number_of_messages >= max_number_of_messages) {
                    var bubble_list = chat_box.get_children ();
                    chat_box.remove (bubble_list.first ().nth_data (0));
                }
                chat_box.pack_start (new SpeechBubble (false, message));
                number_of_messages++;
                received_bubble_text = message;
            }
        }
        public void push_qna (string query, string answer, string skill, double? confidence = 0.5) {
            if (answer != "" && answer != null) {
                if (number_of_messages >= max_number_of_messages) {
                    var bubble_list = chat_box.get_children ();
                    chat_box.remove (bubble_list.first ().nth_data (0));
                }
                chat_box.pack_start (new QnABubble (query, answer, skill, confidence));
                number_of_messages++;
                received_bubble_text = answer;
            }
        }
        public void push_current_weather (string icon, string current_temp, string min_temp, string max_temp, string location, string condition, double humidity, double wind) {
            if (number_of_messages >= max_number_of_messages) {
                var bubble_list = chat_box.get_children ();
                chat_box.remove (bubble_list.first ().nth_data (0));
            }
            chat_box.pack_start (new WeatherBubbleCurrent (icon, current_temp, min_temp, max_temp, location, condition, humidity, wind));
            number_of_messages++;
        }
        public void push_app_launch (Hemera.Core.AppEntry app) {
            if (number_of_messages >= max_number_of_messages) {
                var bubble_list = chat_box.get_children ();
                chat_box.remove (bubble_list.first ().nth_data (0));
            }
            chat_box.pack_start (new AppBubble (app));
            number_of_messages++;
        }
        public void refocus () {
            utterance_entry.grab_focus_without_selecting ();
        }
    }
}
