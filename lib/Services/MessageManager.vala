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
 *              Hannes Schulze
 */


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
// Initialise Mycroft MessageManager Service                                               //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

namespace Hemera.Services {
    public class MessageManager {
        Connection ws_connection;
        public MessageManager (Connection ws_connection) {
            this.ws_connection = ws_connection;
            ws_connection.ws_message.connect ((type, message) => {
                readJSON (message);
            });
        }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
// Parse events from Mycroft                                                               //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
        public signal void connection_established ();
        public signal void receive_speak (string utterance, bool response_expected);
        public signal void receive_utterance (string utterance);
        public signal void receive_qna (string phrase, string answer, string skill_id, double confidence);
        public signal void receive_current_weather (string icon, string current, string min, string max, string location, string condition, double humidity, double wind);
        public signal void receive_hemera_launch_app(string app);

        public signal void receive_audio_output_start ();
        public signal void receive_audio_output_end ();
        public signal void receive_record_begin ();
        public signal void receive_record_end ();
        public signal void receive_record_failed ();

        public signal void receive_system_blink (int64 times);
        public signal void receive_system_mute ();
        public signal void receive_system_unmute ();

        public signal void receive_eyes_blink (string side);
        public signal void receive_eyes_narrow ();
        public signal void receive_eyes_look (string side);
        public signal void receive_eyes_off ();

        private void readJSON (string json_message) {
            try {
                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (json_message);
                Json.Object root_object = parser.get_root ().get_object ();
                string type = root_object.get_string_member ("type");
                warning (json_message); // DEBUG ONLY

                // SYSTEM MESSAGES /////////////////////////////////////////////////////////
                switch (type) {
                    case "connected":
                        // Notify that I am connected to Mycroft server
                        connection_established ();
                        warning ("Mycroft connection established");
                        break;
                    case "mycroft.not.paired":
                        // I need some love as well
                        warning ("Hemera isn't paired with Mycroft. Run the Mycroft Pairing wizard");
                        break;
                    case "speak":
                        // Speaking it.
                        // "data": {"utterance": "Sorry, I didn't catch that.", "expect_response": false}
                        Json.Object data = root_object.get_object_member ("data");
                        string utterance = data.get_string_member ("utterance");
                        bool expect_response = data.get_boolean_member ("expect_response");
                        receive_speak (utterance, expect_response);
                        break;
                    case "mycroft.skills.initialized":
                        // Ready to roll!
                        break;
                    case "recognizer_loop:audio_output_start":
                        // I started speaking something... blah, blah, blah
                        receive_audio_output_start ();
                        break;
                    case "recognizer_loop:audio_output_end":
                        // I stopped speaking.
                        receive_audio_output_end ();
                        break;
                    case "recognizer_loop:record_begin":
                        // I started listening.
                        receive_record_begin ();
                        break;
                    case "recognizer_loop:record_end":
                        // I stopped listening.
                        receive_record_end ();
                        break;
                    case "mycroft.speech.recognition.unknown":
                        // Sorry. I didn't hear you.
                        receive_record_failed ();
                        break;
                    case "configuration.updated":
                        // Just got back from school
                        break;
                    case "recognizer_loop:utterance":
                        // I heard you say...
                        Json.Object data = root_object.get_object_member ("data");
                        Json.Array utterances = data.get_array_member ("utterances");
                        string utterance = utterances.get_string_element (0);

                        receive_utterance (utterance);
                        break;
                    case "intent_failure":
                        break;
                    case "gui.value.set":
                        // See this, yeah that icon tells you something
                        // {"type": "gui.value.set", "data": {"current": "11", "min": "3", "max": "14", "location": "Lawrence\nKansas\nUnited States", "condition": "clear", "icon": "01d", "weathercode": 0, "humidity": 51, "wind": "--", "__from": "mycroft-weather.mycroftai"}, "context": {}}
                        // 
                        Json.Object data = root_object.get_object_member ("data");
                        string provider = data.get_string_member ("__from");
                        if (provider == "mycroft-weather.mycroftai") {
                            string icon         = data.get_string_member ("icon");
                            string current_temp = data.get_string_member ("current");
                            string min_temp     = data.get_string_member ("min");
                            string max_temp     = data.get_string_member ("max");
                            string location     = data.get_string_member ("location");
                            string condition    = data.get_string_member ("condition");
                            double humidity     = data.get_double_member ("humidity");
                            double wind         = data.get_double_member ("wind");
                            warning ("WEATHER///////////////////");
                            receive_current_weather (icon, current_temp, min_temp, max_temp, location, condition, humidity, wind);
                        }
                        break;
                    // HEMERA SKILL SIGNALS ////////////////////////////////////////////////////
                    case "hemera_action":
                        Json.Object data = root_object.get_object_member ("data");
                        string type_of_action = data.get_string_member ("type");
                        if (type_of_action == "launch") {
                            string app_name = data.get_string_member ("app");
                            receive_hemera_launch_app (app_name);
                        }
                        break;

                    // COMMON DISPLAY SIGNALS //////////////////////////////////////////////////
                    case "enclosure.system.blink":
                        /* The 'eyes' should blink the given number of times.
                         * Args:
                         * times (int): number of times to blink
                         */
                        Json.Object data = root_object.get_object_member ("data");
                        int64 times = data.get_int_member ("times");
                        receive_system_blink (times);
                        break;
                    case "enclosure.system.mute":
                        // Mute (turn off) the system speaker
                        receive_system_mute ();
                        break;
                    case "enclosure.system.unmute":
                        // Unmute (turn on) the system speaker
                        receive_system_unmute ();
                        break;
                    case "enclosure.weather.display":
                        // I heard there will be some thunder storms in your area
                        /* Show a the temperature and a weather icon
                         *  Args:
                         *      img_code (char): one of the following icon codes
                         *                    0 = sunny
                         *                    1 = partly cloudy
                         *                    2 = cloudy
                         *                    3 = light rain
                         *                    4 = raining
                         *                    5 = stormy
                         *                    6 = snowing
                         *                    7 = wind/mist
                         *       temp (int): the temperature (either C or F, not indicated)
                         */
                        break;

                    // EYE FEATURE SIGNALS /////////////////////////////////////////////////////
                    case "enclosure.eyes.blink":
                        /* Do I look more like Human now?
                         * Make the eyes blink
                         * Args:
                         * side (str): 'r', 'l', or 'b' for 'right', 'left' or 'both'
                         */
                        Json.Object data = root_object.get_object_member ("data");
                        string side = data.get_string_member ("side");
                        receive_eyes_blink (side);
                        break;
                    case "enclosure.eyes.color":
                        // Let's party
                        /* Change the eye color to the given RGB color
                         * Args:
                         *       r (int): 0-255, red value
                         *       g (int): 0-255, green value
                         *       b (int): 0-255, blue value
                         */
                         break;
                    case "enclosure.eyes.spin":
                        // Now I'm drunk
                        break;
                    case "enclosure.eyes.timedspin":
                        /* Make the eyes 'roll' for the given time.
                         * Args:
                         *    length (int): duration in milliseconds of roll, None = forever
                         */
                         break;
                    case "enclosure.eyes.narrow":
                         // Make the eyes look narrow, like a squint
                         receive_eyes_narrow ();
                         break;
                    case "enclosure.eyes.look":
                         /* Make the eyes look to the given side
                          * Args:
                          *   side (str): 'r' for right
                          *               'l' for left
                          *               'u' for up
                          *               'd' for down
                          *               'c' for crossed
                          */
                         Json.Object data = root_object.get_object_member ("data");
                         string side = data.get_string_member ("side");
                         receive_eyes_look (side);
                         break;
                    case "enclosure.eyes.level":
                         /* Set the brightness of the eyes in the display.
                          * Args:
                          *   level (int): 1-30, bigger numbers being brighter
                          */
                         break;
                    case "enclosure.eyes.volume":
                        /* Indicate the volume using the eyes
                         * Args:
                         *     volume (int): 0 to 11
                         */
                         break;
                    case "enclosure.eyes.fill":
                        /* Use the eyes as a type of progress meter
                         *   Args:
                         *       amount (int): 0-49 fills the right eye, 50-100 also covers left
                         *       percentage (int) : 0-100 for both eyes
                         */
                        break;
                    case "enclosure.eyes.on":
                        // Eyes on
                        break;
                    case "enclosure.eyes.off":
                        // No eyes
                        receive_eyes_off ();
                        break;
                    case "enclosure.eyes.reset":
                        // Neutral eyes
                        receive_eyes_off ();
                        break;

                    // MOUTH FEATURE SIGNALS ///////////////////////////////////////////////////
                    case "enclosure.mouth.smile":
                        // Ha ha I am happy
                        break;
                    case "enclosure.mouth.think":
                        // Thinking...
                        break;
                    case "enclosure.mouth.talk":
                        // Talking...
                        break;
                    case "enclosure.mouth.text":
                        /* Display text (scrolling as needed)
                         * Args:
                         *     text (str): text string to display
                         */
                        break;
                    case "enclosure.mouth.viseme_list":
                        /* Send mouth visemes as a list in a single message.
                         * Arguments:
                         *      start (int):    Timestamp for start of speech
                         *      viseme_pairs:   Pairs of viseme id and cumulative end times
                         *                      (code, end time)
                         *                      codes:
                         *                       0 = shape for sounds like 'y' or 'aa'
                         *                       1 = shape for sounds like 'aw'
                         *                       2 = shape for sounds like 'uh' or 'r'
                         *                       3 = shape for sounds like 'th' or 'sh'
                         *                       4 = neutral shape for no sound
                         *                       5 = shape for sounds like 'f' or 'v'
                         *                       6 = shape for sounds like 'oy' or 'ao'
                         */
                        break;
                    case "enclosure.mouth.display_image":
                        /* Send an image to the enclosure.
                         * Args:
                         *       image_absolute_path (string): The absolute path of the image
                         *       invert (bool): inverts the image being drawn.
                         *       x (int): x offset for image
                         *       y (int): y offset for image
                         *       refresh (bool): specify whether to clear the faceplate before
                         *                       displaying the new image or not.
                         *                       Useful if you'd like to display muliple images
                         *                       on the faceplate at once.
                         */
                        break;
                    case "enclosure.mouth.reset":
                        // Neutral face
                        break;
                    case "enclosure.mouth.events.activate":
                        // I have emotion too
                        break;
                    case "enclosure.mouth.events.deactivate":
                        // I stopped showing emotions
                        break;
                
                    // PLAYBACK CONTROL SIGNALS ///////////////////////////////////////////////
                    case "mycroft.audio.service.next":
                        // Next Track
                        break;
                    case "mycroft.audio.service.pause":
                        // Pause Playback
                        break;
                    case "mycroft.audio.service.prev":
                        // Previous Track
                        break;
                    case "mycroft.audio.service.resume":
                        // Resume Track
                        break;
                
                    // ALARM DISPLAY AND CONTROLS ////////////////////////////////////////////
                    case "mycroft-alarm.mycroftai:Flash":
                        // Beep Beep
                        break;
                
                    // QUESTION ANSWER SYSTEM ////////////////////////////////////////////////
                    case "question:query.response":
                        /*
                        {"type": "question:query.response", "data": {"phrase": "who is bill gates", "skill_id": "fallback-wolfram-alpha.mycroftai", "answer": "William Henry Gates III (born October 28, 1955) is an American business magnate, investor, author, philanthropist, and humanitarian. He is best known as the principal founder of Microsoft Corporation.", "callback_data": {"query": "who is bill gates", "answer": "William Henry Gates III (born October 28, 1955) is an American business magnate, investor, author, philanthropist, and humanitarian. He is best known as the principal founder of Microsoft Corporation."}, "conf": 0.6}, "context": {}}
                        */
                        Json.Object data = root_object.get_object_member ("data");
                        string answer = data.get_string_member ("answer");
                        string phrase = data.get_string_member ("phrase");
                        string skill_id = data.get_string_member ("skill_id");
                        double confidence = data.get_double_member ("conf");

                        receive_qna (phrase, answer, skill_id, confidence);
                        break;

                    // SKILL DOWNLOAD SYSTEM /////////////////////////////////////////////////
                    case "padatious:register_intent":
                        // {"type": "padatious:register_intent", "data": {"file_name": "/opt/mycroft/skills/count.andlo/vocab/en-us/count.intent", "name": "count.andlo:count.intent"}, "context": {}}
                        break;
                    case "mycroft-configuration.mycroftai:ConfigurationSkillupdate_remote":
                        // data: UpdateRemote
                        break;
                    default:
                        // Unrecognized signal
                        break;
                }
            }
            catch (Error e) {
                stderr.printf ("Something went wrong, but this may be helpful: %s", e.message);
            }
        }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
// Send messages to Mycroft                                                                //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//


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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
// Enable Mycroft Mic to listen for query                                                  //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

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

        public bool send_speech (string val, string? localle = "en-us") {
            if (ws_connection.ws_connected) {
                Json.Builder builder = new Json.Builder ();
                builder.begin_object ();                                        // {
                builder.set_member_name ("type");                               //     "type" : 
                builder.add_string_value ("speak");                             //          "speak",
                builder.set_member_name ("data");                               //     "data" : 
                builder.begin_object ();                                        //      {
                builder.set_member_name ("utterance");                          //          "utternance" : 
                builder.add_string_value (val);                                 //              val
                builder.end_object ();                                          //
                builder.begin_object ();                                        //
                builder.set_member_name ("lang");                               //          "lang" :
                builder.add_string_value (localle);                             //              localle
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
        public bool send_mic_on () {
            if (ws_connection.ws_connected) {
                Json.Builder builder = new Json.Builder ();
                builder.begin_object ();                                        // {
                builder.set_member_name ("type");                               //     "type" : 
                builder.add_string_value ("mycroft.mic.unmute");                //          "mycroft.mic.unmute"
                builder.end_object ();                                          // }

                Json.Generator generator = new Json.Generator ();
                Json.Node root = builder.get_root ();
                generator.set_root (root);
                string str = generator.to_data (null);

                try {
                    ws_connection.get_web_socket ().send_text (str);
                }
                catch (Error e) {
                    warning ("[Hemera]: Mic Error: %s", (string)e);
                    return false;
                }
                return true;
            }
            else {
                warning ("[Hemera]: No web socket");
                return false;
            }
        }
        public bool send_mic_off () {
            if (ws_connection.ws_connected) {
                Json.Builder builder = new Json.Builder ();
                builder.begin_object ();                                        // {
                builder.set_member_name ("type");                               //     "type" : 
                builder.add_string_value ("mycroft.mic.mute");                  //          "mycroft.mic.mute"
                builder.end_object ();                                          // }

                Json.Generator generator = new Json.Generator ();
                Json.Node root = builder.get_root ();
                generator.set_root (root);
                string str = generator.to_data (null);

                try {
                    ws_connection.get_web_socket ().send_text (str);
                }
                catch (Error e) {
                    warning ("[Hemera]: Mic Error: %s", (string)e);
                    return false;
                }
                return true;
            }
            else {
                warning ("[Hemera]: No web socket");
                return false;
            }
        }
        public bool stop () {
            if (ws_connection.ws_connected) {
                Json.Builder builder = new Json.Builder ();
                builder.begin_object ();                                        // {
                builder.set_member_name ("type");                               //     "type" : 
                builder.add_string_value ("mycroft.stop");                      //          "mycroft.stop"
                builder.end_object ();                                          // }

                Json.Generator generator = new Json.Generator ();
                Json.Node root = builder.get_root ();
                generator.set_root (root);
                string str = generator.to_data (null);

                try {
                    ws_connection.get_web_socket ().send_text (str);
                }
                catch (Error e) {
                    warning ("[Hemera]: Mycroft Error: %s", (string)e);
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
