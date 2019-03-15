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
        Connection ws_connection;
        public MessageManager (Connection ws_connection) {
            this.ws_connection = ws_connection;
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
                warning (type);
                if (type == "connected") {
                    // Notify that I am connected to Mycroft server
                    warning ("[ HEMERA DEBUG ] Connected");
                }
                else if (type == "speak") {
                    // I am supposed to speaking something
                    warning ("[ HEMERA DEBUG ] Speak");
                }
                else if (type == "mycroft.not.paired") {
                    // I need some love as well
                    warning ("Hemera isn't paired");
                }
                else if (type == "recognizer_loop:audio_output_start") {
                    // I started speaking something... blah, blah, blah
                    warning ("[ HEMERA DEBUG ] Start saying");
                }
                else if (type == "recognizer_loop:audio_output_end") {
                    // I stopped speaking. Shshh!
                    warning ("[ HEMERA DEBUG ] Stop saying");
                }
                else if (type == "configuration.updated") {
                    // Just got back from school
                    warning ("[ HEMERA DEBUG ] Updated");
                }
                else if (type == "recognizer_loop:utterance") {
                    // I heard you say...
                    warning ("[ HEMERA DEBUG ] Received utterance");
                }
                else if (type == "intent_failure") {
                    // Sorry. I didn't hear you.
                    warning ("[ HEMERA DEBUG ] Utterance not understandable");
                }
                else if (type == "gui.value.set") {
                    // See this, yeah that icon tells you something
                    warning ("[ HEMERA DEBUG ] GUI value");
                }
                else if (type == "enclosure.weather.display") {
                    // I heard there will be some thunder storms in your area
                    warning ("[ HEMERA DEBUG ] ");
                }
                else if (type == "enclosure.eyes.blink") {
                    // Do I look more like Human now?
                    warning ("[ HEMERA DEBUG ] Connected");
                }
                else if (type == "enclosure.mouth.reset") {
                    // Neutral face
                    warning ("[ HEMERA DEBUG ] Connected");
                }
                else if (type == "enclosure.mouth.events.activate") {
                    // I have emotion too
                    warning ("[ HEMERA DEBUG ] Connected");
                }
                else if (type == "enclosure.mouth.events.deactivate") {
                    // I stopped showing emotions
                    warning ("[ HEMERA DEBUG ] Connected");
                }
                else if (type == "enclosure.eyes.volume") {
                    // Turn it all the way up
                    warning ("[ HEMERA DEBUG ] Connected");
                }
            }
            catch (Error e) {
                stderr.printf ("Something went wrong, but this may be helpful: %s", e.message);
            }
        }

        public bool send_utterance (string val) {
            if (ws_connection.ws_connected) {
                Json.Builder builder = new Json.Builder ();
                builder.begin_object ();                                        // {
                builder.set_member_name ("type");                               //     "type" : 
                builder.add_string_value ("recognizer_loop:utterance");         //          "recognizer_loop:utterance",
                builder.set_member_name ("data");                               //     "data" : 
                builder.begin_object ();                                        //      {
                builder.set_member_name ("utterances");                         //          "utternances" : 
                builder.begin_array ();
                builder.add_string_value (val);                                 //              [ val ]
                builder.end_array ();
                builder.end_object ();                                          //      }
                builder.end_object ();                                          // }

                Json.Generator generator = new Json.Generator ();
	            Json.Node root = builder.get_root ();
	            generator.set_root (root);
	            string str = generator.to_data (null);

                try {
                    ws_connection.get_web_socket ().send_text (str);
                }
                catch (Error e) {
                    warning ("[Hemera]: Send Message error %s", (string)e);
                    return false;
                }
                return true;
            }
            else {
                warning ("[Hemera]: No web socket");
                return false;
            }
        }

        public bool send_wake () {
            if (ws_connection.ws_connected) {
                Json.Builder builder = new Json.Builder ();
                builder.begin_object ();                                        // {
                builder.set_member_name ("type");                               //     "type" : 
                builder.add_string_value ("mycroft.mic.listen");                //          "mycroft.mic.listen"
                builder.end_object ();                                          // }

                Json.Generator generator = new Json.Generator ();
	            Json.Node root = builder.get_root ();
	            generator.set_root (root);
	            string str = generator.to_data (null);

                try {
                    ws_connection.get_web_socket ().send_text (str);
                }
                catch (Error e) {
                    warning ("[Hemera]: Wake Mic Error: %s", (string)e);
                    return false;
                }
                return true;
            }
            else {
                warning ("[Hemera]: No web socket");
                return false;
            }
        }

    }
}
