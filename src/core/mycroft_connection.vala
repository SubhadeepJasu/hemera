using Soup;
using Gtk;

namespace Hemera {
    public class MyCroftConnection {
        public WebsocketConnection ws;
        public void init_ws () {
            string ip_address  = "0.0.0.0";
            string port_number = "8181";

            string uri_s = """ws://%s:%s/core""".printf(ip_address, port_number);
            Soup.URI uri = new Soup.URI (uri_s);
            GLib.Socket socket = new GLib.Socket (SocketFamily.IPV4, SocketType.STREAM, SocketProtocol.TCP);
            SocketConnection stream = SocketConnection.factory_create_connection (socket);
            ws = new WebsocketConnection (stream, uri, WebsocketConnectionType.CLIENT, null, null);
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
        mcc.ws.message.connect ((type, smme) => {
            warning ("Message: %s\n", (string)smme);
        });

        window.show_all ();

        Gtk.main ();
        return 0;
    }
}
