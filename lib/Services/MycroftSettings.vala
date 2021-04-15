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
 *              Hannes Schulze
 */
using Hemera.Models;
namespace Hemera.Services { 
    public class MycroftSettings {
        public static void write (MycroftSettingsModel? settings = null){
            string user_home_directory = GLib.Environment.get_home_dir ();
            string config_location = user_home_directory.concat ("/.mycroft/mycroft.conf");
            Json.Builder builder = new Json.Builder ();
            builder.begin_object ();                                // {
            builder.set_member_name ("lang");                       //      "lang":
            builder.add_string_value (settings.lang);               //          "en-us",
            builder.set_member_name ("system_unit");                //      "system_unit":
            builder.add_string_value (settings.system_unit);        //          "metric",
            builder.set_member_name ("time_format");                //      "time_format":
            builder.add_string_value (settings.time_format);        //          "half",
            builder.set_member_name ("date_format");                //      "date_format":
            builder.add_string_value (settings.date_format);        //          "MDY",
            builder.set_member_name ("opt_in");                     //      "opt_in":
            builder.add_boolean_value (settings.opt_in);            //          "false",
            builder.set_member_name ("confirm_listening");          //      "confirm_listening":
            builder.add_boolean_value (settings.confirm_listening); //          "true",

            builder.set_member_name ("location");                   //      "location":
            builder.begin_object ();                                //      {
            builder.set_member_name ("city");                       //          "city":
            builder.begin_object ();                                //          {
            builder.set_member_name ("code");                       //              "code":
            builder.add_string_value (settings.location_city_code); //                  "Lawrence",
            builder.set_member_name ("name");                       //              "name":
            builder.add_string_value (settings.location_city_name); //                  "Lawrence",
            builder.set_member_name ("state");                      //              "state":
            builder.begin_object ();                                //              {
            builder.set_member_name ("code");                       //                  "code":
            builder.add_string_value (settings.location_state_code);//                      "KS",
            builder.set_member_name ("name");                       //                  "name":
            builder.add_string_value (settings.location_state_name);//                      "Kansas",
            builder.set_member_name ("country");                    //                  "country":
            builder.begin_object ();                                //                  {
            builder.set_member_name ("code");                       //                      "code":
            builder.add_string_value (settings.location_country_code);//                        "US",
            builder.set_member_name ("name");                       //                      "name":
            builder.add_string_value (settings.location_country_name);//                        "United States"
            builder.end_object ();                                  //                  }
            builder.end_object ();                                  //              }
            builder.end_object ();                                  //          },

            builder.set_member_name ("coordinate");                 //          "coordinate":
            builder.begin_object ();                                //          {
            builder.set_member_name ("latitude");                   //              "latitude":
            builder.add_double_value (settings.location_coordinate_latitude);//         "38.971669",
            builder.set_member_name ("longitude");                  //              "longitude":
            builder.add_double_value (settings.location_coordinate_longitude); //       "-95.23525"
            builder.end_object ();                                  //          },
            builder.set_member_name ("timezone");                   //          "timezone":
            builder.begin_object ();                                //          {
            builder.set_member_name ("code");                       //              "latitude":
            builder.add_string_value (settings.location_timezone_code);//               "America/Chicago",
            builder.set_member_name ("name");                       //              "longitude":
            builder.add_string_value (settings.location_timezone_name);//                "Central Standard Time"
            builder.set_member_name ("dstOffset");                  //              "dstOffset":
            builder.add_int_value (settings.location_timezone_dstOffset);//               "3600000",
            builder.set_member_name ("offset");                     //              "offset":
            builder.add_int_value (settings.location_timezone_offset);//                  "-21600000"
            builder.end_object ();                                  //          }
            builder.end_object ();                                  //      },
            builder.set_member_name ("websocket");                  //      "websocket":
            builder.begin_object ();                                //      {
            builder.set_member_name ("host");                       //          "host":
            builder.add_string_value (settings.websocket_host);     //              "0.0.0.0",
            builder.set_member_name ("base_port");                  //          "base_port":
            builder.add_int_value (settings.websocket_port);        //              "8181",
            builder.set_member_name ("ssl");                        //          "ssl":
            builder.add_boolean_value (settings.websocket_ssl);     //              "false"
            builder.end_object ();                                  //      },
            builder.set_member_name ("listener");                   //                  "listener":
            builder.begin_object ();                                //                  {
            builder.set_member_name ("wake_word_upload");           //                      "wake_word_upload":
            builder.begin_object ();                                //                      {
            builder.set_member_name ("disable");                    //                          "disable":
            builder.add_boolean_value (settings.listener_wake_word_upload_disable);//               "false",
            builder.set_member_name ("url");                        //                          "url":
            builder.add_string_value (settings.listener_wake_word_upload_url);//                    "https://training.mycroft.ai/precise/upload"
            builder.end_object ();                                  //                      },
            builder.set_member_name ("mute_during_output");         //                      "mute_during_output":
            builder.add_boolean_value (settings.listener_mute_during_output);//                 "true",
            builder.set_member_name ("duck_while_listening");       //                      "duck_while_listening":
            builder.add_double_value (settings.listener_duck_while_listening);//                "0.3",
            builder.set_member_name ("wake_word");                  //                      "wake_word":
            builder.add_string_value (settings.listener_wake_word); //                          "hey hemera",
            builder.end_object ();                                  //                  },
            builder.set_member_name ("hotwords");                   //                  "hotwords":
            builder.begin_object ();                                //                  {
            builder.set_member_name (settings.listener_wake_word);  //                      "hey hemera":
            builder.begin_object ();                                //                      {
            builder.set_member_name ("module");                     //                          "module":
            builder.add_string_value ("pocketsphinx");              //                              "pocketsphinx",
            builder.set_member_name ("phonemes");                   //                          "phonemes":
            builder.add_string_value (settings.listener_wake_word_phonemes);//                      "HH EY . HH EH M ER AH",
            builder.set_member_name ("threshold");                  //                          "threshold":
            builder.add_string_value ("1e-17");                     //                              "1e-17",
            builder.set_member_name ("lang");                       //                          "lang":
            builder.add_string_value ("en-us");                     //                              "en-us",
            builder.end_object ();                                  //                  }
            builder.end_object ();                                  //      },
            builder.end_object ();                                  // }
            

            Json.Generator generator = new Json.Generator ();
            Json.Node root = builder.get_root ();
            generator.set_root (root);
            string str = generator.to_data (null);
            warning ("warning:" + str);
            
            try {
                var file = File.new_for_path (config_location);
                if (file.query_exists ()) {
                    file.delete ();
                }
                var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
                uint8[] data = str.data;
                long written = 0;
                while (written < data.length) { 
                    // sum of the bytes of 'str' that already have been written to the stream
                    written += dos.write (data[written:data.length]);
                }
            } catch (Error e) {
                stderr.printf ("Error: %s\n", e.message);
            }
        }
        public static void write_defaults (){
            string user_home_directory = GLib.Environment.get_home_dir ();
            string config_location = user_home_directory.concat ("/.mycroft/mycroft.conf");
            Json.Builder builder = new Json.Builder ();
            builder.begin_object ();                                // {
            builder.set_member_name ("lang");                       //      "lang":
            builder.add_string_value ("en-us");                     //          "en-us",
            builder.set_member_name ("system_unit");                //      "system_unit":
            builder.add_string_value ("metric");                    //          "metric",
            builder.set_member_name ("time_format");                //      "time_format":
            builder.add_string_value ("half");                      //          "half",
            builder.set_member_name ("date_format");                //      "date_format":
            builder.add_string_value ("MDY");                       //          "MDY",
            builder.set_member_name ("opt_in");                     //      "opt_in":
            builder.add_boolean_value (false);                      //          "false",
            builder.set_member_name ("confirm_listening");          //      "confirm_listening":
            builder.add_boolean_value (true);                       //          "true",
            builder.set_member_name ("location");                   //      "location":
            builder.begin_object ();                                //      {
            builder.set_member_name ("city");                       //          "city":
            builder.begin_object ();                                //          {
            builder.set_member_name ("code");                       //              "code":
            builder.add_string_value ("Lawrence");                  //                  "Lawrence",
            builder.set_member_name ("name");                       //              "name":
            builder.add_string_value ("Lawrence");                  //                  "Lawrence",
            builder.set_member_name ("state");                      //              "state":
            builder.begin_object ();                                //              {
            builder.set_member_name ("code");                       //                  "code":
            builder.add_string_value ("KS");                        //                      "KS",
            builder.set_member_name ("name");                       //                  "name":
            builder.add_string_value ("Kansas");                    //                      "Kansas",
            builder.set_member_name ("country");                    //                  "country":
            builder.begin_object ();                                //                  {
            builder.set_member_name ("code");                       //                      "code":
            builder.add_string_value ("US");                        //                          "US",
            builder.set_member_name ("name");                       //                      "name":
            builder.add_string_value ("United States");             //                          "United States"
            builder.end_object ();                                  //                  }
            builder.end_object ();                                  //              }
            builder.end_object ();                                  //          },
            builder.set_member_name ("coordinate");                 //          "coordinate":
            builder.begin_object ();                                //          {
            builder.set_member_name ("latitude");                   //              "latitude":
            builder.add_double_value (38.971669);                   //                  "38.971669",
            builder.set_member_name ("longitude");                  //              "longitude":
            builder.add_double_value (-95.23525);                   //                  "-95.23525"
            builder.end_object ();                                  //          },
            builder.set_member_name ("timezone");                   //          "timezone":
            builder.begin_object ();                                //          {
            builder.set_member_name ("code");                       //              "code":
            builder.add_string_value ("America/Chicago");           //                  "America/Chicago",
            builder.set_member_name ("name");                       //              "name":
            builder.add_string_value ("Central Standard Time");     //                  "Central Standard Time"
            builder.set_member_name ("dstOffset");                  //              "dstOffset":
            builder.add_int_value (3600000);                        //                  "3600000",
            builder.set_member_name ("offset");                     //              "offset":
            builder.add_int_value (-21600000);                      //                  "-21600000"
            builder.end_object ();                                  //          }
            builder.end_object ();                                  //      },
            builder.set_member_name ("websocket");                  //      "websocket":
            builder.begin_object ();                                //      {
            builder.set_member_name ("host");                       //          "host":
            builder.add_string_value ("127.0.0.1");                   //              "0.0.0.0",
            builder.set_member_name ("base_port");                  //          "base_port":
            builder.add_int_value (8181);                           //              "8181",
            builder.set_member_name ("ssl");                        //          "ssl":
            builder.add_boolean_value (false);                      //              "false"
            builder.end_object ();                                  //      },
            builder.set_member_name ("listener");                   //      "listener":
            builder.begin_object ();                                //      {
            builder.set_member_name ("wake_word_upload");           //          "wake_word_upload":
            builder.begin_object ();                                //          {
            builder.set_member_name ("disable");                    //              "disable":
            builder.add_boolean_value (false);                      //                  "false",
            builder.set_member_name ("url");                        //              "url":
            builder.add_string_value ("https://training.mycroft.ai/precise/upload"); // "https://training.mycroft.ai/precise/upload"
            builder.end_object ();                                  //          },
            builder.set_member_name ("mute_during_output");         //          "mute_during_output":
            builder.add_boolean_value (false);                      //              "true",
            builder.set_member_name ("duck_while_listening");       //          "duck_while_listening":
            builder.add_double_value (0.3);                         //              "0.3",
            builder.set_member_name ("wake_word");                  //          "wake_word":
            builder.add_string_value ("hey hemera");                //              "hey hemera",
            builder.end_object ();                                  //      },
            builder.set_member_name ("hotwords");                   //      "hotwords":
            builder.begin_object ();                                //      {
            builder.set_member_name ("hey hemera");                 //          "hey hemera":
            builder.begin_object ();                                //          {
            builder.set_member_name ("module");                     //              "module":
            builder.add_string_value ("pocketsphinx");              //                  "pocketsphinx",
            builder.set_member_name ("phonemes");                   //              "phonemes":
            builder.add_string_value ("HH EY . HH EH M ER AH");     //                  "HH EY . HH EH M ER AH",
            builder.set_member_name ("threshold");                  //              "threshold":
            builder.add_string_value ("1e-17");                     //                  "1e-17",
            builder.set_member_name ("lang");                       //              "lang":
            builder.add_string_value ("en-us");                     //                  "en-us",
            builder.end_object ();                                  //          }
            builder.end_object ();                                  //      },
            //  builder.set_member_name ("tts");                        //      "tts":
            //  builder.begin_object ();                                //      {
            //  builder.set_member_name ("module");                     //           "module":
            //  builder.add_string_value ("mimic");                     //               "mimic",
            //  builder.set_member_name ("mimic");                      //           "mimic":
            //  builder.begin_object ();                                //           {
            //  builder.set_member_name ("voice");                      //               "voice":
            //  builder.add_string_value ("ap");                        //                   "ap"
            //  builder.end_object ();                                  //           }
            //  builder.end_object ();                                  //      }
            builder.end_object ();                                  // }
            

            Json.Generator generator = new Json.Generator ();
            Json.Node root = builder.get_root ();
            generator.set_root (root);
            string str = generator.to_data (null);
            warning ("warning:" + str);
            
            try {
                var file = File.new_for_path (config_location);
                if (file.query_exists ()) {
                    file.delete ();
                }
                var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
                uint8[] data = str.data;
                long written = 0;
                while (written < data.length) { 
                    // sum of the bytes of 'str' that already have been written to the stream
                    written += dos.write (data[written:data.length]);
                }
            } catch (Error e) {
                stderr.printf ("Error: %s\n", e.message);
            }
        }

        public static MycroftSettingsModel read_settings () {
            string user_home_directory = GLib.Environment.get_home_dir ();
            string config_location = user_home_directory.concat ("/.mycroft/mycroft.conf");
            File config_file = File.new_for_path (config_location);
            MycroftSettingsModel settings = null;

            try {
                var dis = new DataInputStream (config_file.read ());
                string line = "";
                string data = "";
                while ((line = dis.read_line (null)) != null) {
                    data += line;
                }

                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (data);
                Json.Object root_object = parser.get_root ().get_object ();

                settings = new MycroftSettingsModel ();
                settings.lang = root_object.get_string_member ("lang");
                settings.system_unit = root_object.get_string_member ("system_unit");
                settings.time_format = root_object.get_string_member ("time_format");
                settings.date_format = root_object.get_string_member ("date_format");
                settings.opt_in = root_object.get_boolean_member ("opt_in");
                settings.confirm_listening = root_object.get_boolean_member ("confirm_listening");
                var location = root_object.get_object_member ("location");
                if (location != null) {
                    var city = location.get_object_member ("city");
                    if (city != null) {
                        settings.location_city_code = city.get_string_member ("code");
                        settings.location_city_name = city.get_string_member ("name");
                        var state = city.get_object_member ("state");
                        if (state != null) {
                            settings.location_state_code = state.get_string_member ("code");
                            settings.location_state_name = state.get_string_member ("name");
                            var country = state.get_object_member ("country");
                            if (country != null) {
                                settings.location_country_code = country.get_string_member ("code");
                                settings.location_country_name = country.get_string_member ("name");
                            }
                        }
                    }
                    var coordinates = location.get_object_member ("coordinate");
                    if (coordinates != null) {
                        settings.location_coordinate_latitude = coordinates.get_double_member ("latitude");
                        settings.location_coordinate_longitude = coordinates.get_double_member ("longitude");
                    }
                    var timezone = location.get_object_member ("timezone");
                    if (timezone != null) {
                        settings.location_timezone_code = coordinates.get_string_member ("code");
                        settings.location_timezone_name = coordinates.get_string_member ("name");
                        settings.location_timezone_dstOffset = coordinates.get_int_member ("dstOffset");
                        settings.location_timezone_offset = coordinates.get_int_member ("offset");
                    }
                    var websocket = root_object.get_object_member ("websocket");
                    if (websocket != null) {
                        settings.websocket_host = websocket.get_string_member ("host");
                        settings.websocket_port = (int)websocket.get_int_member ("port");
                        settings.websocket_ssl = websocket.get_boolean_member ("ssl");
                    }
                }
                
                warning (data);
            } catch (Error e) {
                stderr.printf ("Error: %s\n", e.message);
            }
            return settings;
        }
    }
}