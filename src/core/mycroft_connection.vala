using Soup;
using Gtk;

namespace Hemera {
    public class MyCroftConnection {
        public signal void ws_message (int type, Bytes message);
        
        private Soup.WebsocketConnection connection;
        
        public void init_ws () {
            string ip_address  = "0.0.0.0";
            string port_number = "8181";
            
            var socket_client = new Soup.Session ();
            socket_client.https_aliases = { "wss" };
            var message = new Soup.Message ("GET", "ws://%s:%s/core".printf (ip_address, port_number));
            
            socket_client.websocket_connect_async.begin (message, null, null, null, (obj, res) => {
                try {
                    connection = socket_client.websocket_connect_async.end (res);
                    print ("Connected!\n");
                    if (connection != null) {
                        connection.message.connect ((type, message) => { ws_message (type, message); });
                        connection.closed.connect (() => {
                            print ("Connection closed\n");
                        });
                    }
                } catch (Error e) {
                    stderr.printf ("Remote error\n");
                }
            });
        }
    }
    
    int main (string[] args) {
        Gtk.init (ref args);
        MyCroftConnection mcc = new MyCroftConnection ();
        mcc.init_ws ();
        var window = new Window ();
        window.title = "First GTK+ Program";
        window.border_width = 10;
        window.window_position = WindowPosition.CENTER;
        window.set_default_size (350, 70);
        window.destroy.connect (Gtk.main_quit);
        mcc.ws_message.connect ((type, smme) => {
            warning ("Message: %s\n", (string)smme);
        });

        window.show_all ();

        Gtk.main ();
        return 0;
    }
}
