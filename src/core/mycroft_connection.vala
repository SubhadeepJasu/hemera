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

using Soup;
using Gtk;

namespace Hemera {
    public class MyCroftConnection {
        public signal void ws_message (int type, string message);
        public signal void connection_established ();
        public signal void connection_failed ();
        public signal void connection_disengaged ();

        private Soup.WebsocketConnection connection;
        private string ip_address = "0.0.0.0";
        private string port_number = "8181";

        public MyCroftConnection (string ip_address, string port_number) {
            this.ip_address = ip_address;
            this.port_number = port_number;
        }

        public void init_ws () {
            var socket_client = new Soup.Session ();
            socket_client.https_aliases = { "wss" };
            var message = new Soup.Message ("GET", "ws://%s:%s/core".printf (ip_address, port_number));
            socket_client.websocket_connect_async.begin (message, null, null, null, (obj, res) => {
                try {
                    connection = socket_client.websocket_connect_async.end (res);
                    print ("Connected!\n");
                    connection_established ();
                    if (connection != null) {
                        connection.message.connect ((type, message) => { ws_message (type, decode_bytes(message)); });
                        connection.closed.connect (() => {
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
        private string decode_bytes (Bytes byt) {
            Intl.setlocale ();
            uint8[] chars = byt.get_data ();
            string output = """Message: %s""".printf(@"$((string) chars)\n");
            return output;
        }
    }
}


// Below main function is supposed to be cut from this file
int main (string[] args) {
    Gtk.init (ref args);
    Hemera.MyCroftConnection mcc = new Hemera.MyCroftConnection ("127.0.0.1", "8181");
    mcc.init_ws ();
    var window = new Window ();
    window.title = "Mycroft placeholder UI";
    window.border_width = 10;
    window.window_position = WindowPosition.CENTER;
    window.set_default_size (350, 200);
    window.destroy.connect (Gtk.main_quit);
    mcc.ws_message.connect ((type, smme) => {
        warning ("%s\n", smme);
    });

    window.show_all ();

    Gtk.main ();
    return 0;
}
