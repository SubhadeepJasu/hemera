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
 *              Hannes Schulze
 */

namespace Hemera.Services {
    public class MessageManager {
        public MessageManager (Connection ws_connection) {
            ws_connection.ws_message.connect ((type, message) => {
                readJSON (message);
            });
        }
        
        private void readJSON (string json_message) {
            try {
                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (json_message);
                var root_object = parser.get_root ().get_object ();
                string type = root_object.get_string_member ("type");
                
                if (type == "connected") {
                    // Notify that I am connected to Mycroft server
                }
                else if (type == "speak") {
                    // I am supposed to speaking something
                }
                else if (type == "mycroft.not.paired") {
                    // I need some love as well
                }
                else if (type == "recognizer_loop:audio_output_start") {
                    // I started speaking something... blah, blah, blah
                }
                else if (type == "recognizer_loop:audio_output_end") {
                    // I stopped speaking. Shshh!
                }
                else if (type == "configuration.updated") {
                    // Just got back from school
                }
                else if (type == "recognizer_loop:utterance") {
                    // I heard you say...
                }
                else if (type == "intent_failure") {
                    // Sorry. I didn't hear you.
                }
                else if (type == "gui.value.set") {
                    // See this, yeah that icon tells you something
                }
                else if (type == "enclosure.weather.display") {
                    // I heard there will be some thunder storms in your area
                }
                else if (type == "enclosure.eyes.blink") {
                    // Do I look more like Human now?
                }
                else if (type == "enclosure.mouth.reset") {
                    // Neutral face
                }
                else if (type == "enclosure.mouth.events.activate") {
                    // I have emotion too
                }
                else if (type == "enclosure.mouth.events.deactivate") {
                    // I stopped showing emotions
                }
                else if (type == "enclosure.eyes.volume") {
                    // Turn it all the way up
                }
            }
            catch (Error e) {
                stderr.printf ("Something went wrong, but this may be helpful: %s", (string)e);
            }
        }
    }
}
