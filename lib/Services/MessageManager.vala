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

        private void readJSON (string json_message) {
            try {
                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (json_message);
                var root_object = parser.get_root ().get_object ();
                string type = root_object.get_string_member ("type");
                warning (type);

                // SYSTEM MESSAGES /////////////////////////////////////////////////////////
                if (type == "connected") {
                    // Notify that I am connected to Mycroft server
                    warning ("Mycroft connection established");
                }
                else if (type == "mycroft.not.paired") {
                    // I need some love as well
                    warning ("Hemera isn't paired with Mycroft. Run the Mycroft Pairing wizard");
                }
                else if (type == "recognizer_loop:audio_output_start") {
                    // I started speaking something... blah, blah, blah
                }
                else if (type == "recognizer_loop:audio_output_end") {
                    // I stopped speaking.
                }
                else if (type == "recognizer_loop:record_begin") {
                    // I started listening.
                }
                else if (type == "recognizer_loop:end") {
                    // I stopped listening.
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
                    // {"type": "gui.value.set", "data": {"current": "11", "min": "3", "max": "14", "location": "Lawrence\nKansas\nUnited States", "condition": "clear", "icon": "01d", "weathercode": 0, "humidity": 51, "wind": "--", "__from": "mycroft-weather.mycroftai"}, "context": {}}
                    // 
                }

                // COMMON DISPLAY SIGNALS //////////////////////////////////////////////////
                else if (type == "enclosure.system.blink") {
                    /* The 'eyes' should blink the given number of times.
                     * Args:
                     * times (int): number of times to blink
                     */
                }
                else if (type == "enclosure.system.mute") {
                    // Mute (turn off) the system speaker
                }
                else if (type == "enclosure.system.unmute") {
                    // Unmute (turn on) the system speaker
                }
                else if (type == "enclosure.weather.display") {
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
                }

                // EYE FEATURE SIGNALS /////////////////////////////////////////////////////
                else if (type == "enclosure.eyes.blink") {
                    /* Do I look more like Human now?
                     * Make the eyes blink
                     * Args:
                     * side (str): 'r', 'l', or 'b' for 'right', 'left' or 'both'
                     */
                }
                else if (type == "enclosure.eyes.color") {
                    // Let's party
                    /* Change the eye color to the given RGB color
                     * Args:
                     *       r (int): 0-255, red value
                     *       g (int): 0-255, green value
                     *       b (int): 0-255, blue value
                     */
                }
                else if (type == "enclosure.eyes.spin") {
                    // Now I'm drunk
                }
                else if (type == "enclosure.eyes.timedspin") {
                    /* Make the eyes 'roll' for the given time.
                     * Args:
                     *    length (int): duration in milliseconds of roll, None = forever
                     */
                }
                else if (type == "enclosure.eyes.narrow") {
                    // Make the eyes look narrow, like a squint
                }
                else if (type == "enclosure.eyes.look") {
                    /* Make the eyes look to the given side
                     * Args:
                     *   side (str): 'r' for right
                     *               'l' for left
                     *               'u' for up
                     *               'd' for down
                     *               'c' for crossed
                     */
                }
                else if (type == "enclosure.eyes.level") {
                    /* Set the brightness of the eyes in the display.
                     * Args:
                     *   level (int): 1-30, bigger numbers being brighter
                     */
                }
                else if (type == "enclosure.eyes.volume") {
                    /* Indicate the volume using the eyes
                     * Args:
                     *     volume (int): 0 to 11
                     */
                }
                else if (type == "enclosure.eyes.fill") {
                    /* Use the eyes as a type of progress meter
                     *   Args:
                     *       amount (int): 0-49 fills the right eye, 50-100 also covers left
                     *       percentage (int) : 0-100 for both eyes
                     */
                }
                else if (type == "enclosure.eyes.on") {
                    // Eyes on
                }
                else if (type == "enclosure.eyes.off") {
                    // No eyes
                }
                else if (type == "enclosure.eyes.reset") {
                    // Neutral eyes
                }

                // MOUTH FEATURE SIGNALS ///////////////////////////////////////////////////
                else if (type == "enclosure.mouth.smile") {
                    // Ha ha I am happy
                }
                else if (type == "enclosure.mouth.think") {
                    // Thinking...
                }
                else if (type == "enclosure.mouth.talk") {
                    // Talking...
                }
                else if (type == "enclosure.mouth.text") {
                    /* Display text (scrolling as needed)
                     * Args:
                     *     text (str): text string to display
                     */
                }
                else if (type == "enclosure.mouth.viseme_list") {
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
                }
                else if (type == "enclosure.mouth.display_image") {
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
                
                // PLAYBACK CONTROL SIGNALS ///////////////////////////////////////////////
                else if (type == "mycroft.audio.service.next") {
                    // Next Track
                }
                else if (type == "mycroft.audio.service.pause") {
                    // Pause Playback
                }
                else if (type == "mycroft.audio.service.prev") {
                    // Previous Track
                }
                else if (type == "mycroft.audio.service.resume") {
                    // Resume Track
                }
                
                // ALARM DISPLAY AND CONTROLS ////////////////////////////////////////////
                else if (type == "mycroft-alarm.mycroftai:Flash") {
                    // Beep Beep
                }
                
                // QUESTION ANSWER SYSTEM ////////////////////////////////////////////////
                else if (type == "question:query.response") {
                    /*
                    {"type": "question:query.response", "data": {"phrase": "who is bill gates", "skill_id": "fallback-wolfram-alpha.mycroftai", "answer": "William Henry Gates III (born October 28, 1955) is an American business magnate, investor, author, philanthropist, and humanitarian. He is best known as the principal founder of Microsoft Corporation.", "callback_data": {"query": "who is bill gates", "answer": "William Henry Gates III (born October 28, 1955) is an American business magnate, investor, author, philanthropist, and humanitarian. He is best known as the principal founder of Microsoft Corporation."}, "conf": 0.6}, "context": {}}
                    */
                }
                
                // SKILL DOWNLOAD SYSTEM /////////////////////////////////////////////////
                else if (type == "padatious:register_intent") {
                    // {"type": "padatious:register_intent", "data": {"file_name": "/opt/mycroft/skills/count.andlo/vocab/en-us/count.intent", "name": "count.andlo:count.intent"}, "context": {}}
                }
                else if (type == "mycroft-configuration.mycroftai:ConfigurationSkillupdate_remote") {
                    // data: UpdateRemote
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

    }
}
