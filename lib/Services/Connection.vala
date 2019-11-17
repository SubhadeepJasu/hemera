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

namespace Hemera.Services {

    /**
     * The {@code Connection} class is responsible for creating a websocket 
     * connection with Mycroft
     * @since 1.0.0
     */
    public class Connection {
        public signal void ws_message (int type, string message);
        public signal void connection_established ();
        public signal void connection_failed ();
        public signal void connection_disengaged ();
        public signal void check_connection (bool connected);

        private Soup.WebsocketConnection websocket_connection;
        private string ip_address = "0.0.0.0";
        private string port_number = "8181";
        public bool ws_connected { public get; private set; }

        /**
         * Constructs a new {@code Connection} object
         */
        public Connection (string ip_address, string port_number) {
            this.ip_address = ip_address;
            this.port_number = port_number;
            this.ws_connected = false;
        }

        public void set_connection_address (string ip, string port_number) {
            this.ip_address = ip_address;
            this.port_number = port_number;
        }
        /**
         * Get the websocket connection reference
         * @return {@code Soup.WebsocketConnection}
         */
        public Soup.WebsocketConnection get_web_socket () {
            return websocket_connection;
        }

        /**
         * Attempt reconnection with Mycroft.
         */
        public void init_ws_after_starting_mycroft () {
            int count = 0;
            if (!ws_connected) {
                Timeout.add (200, () => {
                    init_ws ();
                    if (count++ > 25) {
                        connection_failed ();
                    }
                    return !(ws_connected || (count > 25));
                });
            }
        }

        /**
         * Attempt connection to check if Mycroft is running.
         */
        public void init_ws_before_starting_mycroft () {
            init_ws ();
            Timeout.add (5000, () => {
                check_connection (ws_connected);
                return false;
            });
        }

        /**
         * Starts a web socket connection with Mycroft asynchronously.
         */
        public void init_ws () {
            MainLoop loop = new MainLoop ();
            ws_connected = false;
            var socket_client = new Soup.Session ();
            socket_client.https_aliases = { "wss" };
            var message = new Soup.Message ("GET", "ws://%s:%s/core".printf (ip_address, port_number));
            socket_client.websocket_connect_async.begin (message, null, null, null, (obj, res) => {
                try {
                    websocket_connection = socket_client.websocket_connect_async.end (res);
                    print ("Connected!\n");
                    ws_connected = true;
                    if (websocket_connection != null) {
                        websocket_connection.message.connect ((type, m_message) => {
                            ws_message (type, decode_bytes(m_message, m_message.length));
                        });
                        websocket_connection.closed.connect (() => {
                            print ("Connection closed\n");
                            connection_disengaged ();
                        });
                    }
                } catch (Error e) {
                    stderr.printf ("Remote error\n");
                    connection_failed ();
                    ws_connected = false;
                    loop.quit ();
                }
                loop.quit ();
                connection_established ();
            });
            loop.run ();
        }

        /**
         * Converts a stream of bytes to string.
         * @return {@code string}
         */
        private static string decode_bytes (Bytes byt, int n) {
            Intl.setlocale ();

            /* The reason for the for loop is to remove
             * garbage after the main JSON string.
             * Store contents of the byte array in to
             * another array and stop when the expected 
             * array length is reached
             */

            uint8[] chars = new uint8 [n];
            uint8[] capdata = byt.get_data ();
            for (int i = 0; i < n; i++) {
                chars[i] = capdata[i];
            }
            string output = """%s""".printf(@"$((string) chars)\n");
            
            return output;
        }
    }
}
