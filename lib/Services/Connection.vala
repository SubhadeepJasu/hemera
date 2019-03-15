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
    public class Connection {
        public signal void ws_message (int type, string message);
        public signal void connection_established ();
        public signal void connection_failed ();
        public signal void connection_disengaged ();

        private Soup.WebsocketConnection websocket_connection;
        private string ip_address = "0.0.0.0";
        private string port_number = "8181";
        private bool ws_connected { public get; private set; }

        public Connection (string ip_address, string port_number) {
            this.ip_address = ip_address;
            this.port_number = port_number;
            this.ws_connected = false;
        }
        public Soup.WebsocketConnection get_web_socket () {
            return websocket_connection;
        }

        public void init_ws () {
            var socket_client = new Soup.Session ();
            socket_client.https_aliases = { "wss" };
            var message = new Soup.Message ("GET", "ws://%s:%s/core".printf (ip_address, port_number));
            socket_client.websocket_connect_async.begin (message, null, null, null, (obj, res) => {
                try {
                    websocket_connection = socket_client.websocket_connect_async.end (res);
                    print ("Connected!\n");
                    ws_connected = true;
                    connection_established ();
                    if (websocket_connection != null) {
                        websocket_connection.message.connect ((type, message) => {
                            ws_message (type, decode_bytes(message));
                        });
                        websocket_connection.closed.connect (() => {
                            print ("Connection closed\n");
                            connection_disengaged ();
                        });
                    }
                } catch (Error e) {
                    stderr.printf ("Remote error\n");
                    connection_failed ();
                }
            });
        }
        public bool ws_send_message (string val) {
            if (ws_connected) {
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
                    this.websocket_connection.send_text (str);
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
        
        public bool ws_wake () {
            if (ws_connected) {
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
                    this.websocket_connection.send_text (str);
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

        private static string decode_bytes (Bytes byt) {
            Intl.setlocale ();
            uint8[] chars = byt.get_data ();
            string output = """%s""".printf(@"$((string) chars)\n");
            return output;
        }
    }
}
