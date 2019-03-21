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
 */

namespace Hemera.App {
    public class MainWindow : Gtk.Window {
        private Hemera.App.DisplayEnclosure enclosure_display;
        private ChatView chatbox;
        private Gtk.HeaderBar headerbar;
        private Gtk.Stack main_stack;
        private Hemera.App.HemeraApp app_reference;

        public MainWindow (Hemera.App.HemeraApp application) {
            icon_name = "com.github.SubhadeepJasu.hemera";
            this.app_reference = application;
            make_ui ();
            make_events ();
        }
        private void make_ui () {
            Gtk.Button settings_button = new Gtk.Button ();
            settings_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            settings_button.tooltip_text = _("Menu");
            settings_button.valign = Gtk.Align.CENTER;

            this.set_default_size (560, 280);
		    headerbar = new Gtk.HeaderBar ();
            headerbar.has_subtitle = false;
            headerbar.show_close_button = true;
            headerbar.title = _("Hemera");
            headerbar.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            headerbar.get_style_context().add_class("headerbar");
            headerbar.pack_end(settings_button);
            this.set_titlebar (headerbar);

		    enclosure_display = new Hemera.App.DisplayEnclosure ();
		    var separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);

		    chatbox = new ChatView ();

		    var main_grid = new Gtk.Grid ();
		    main_grid.attach (enclosure_display, 0, 0, 1, 1);
		    main_grid.attach (separator, 1, 0, 1, 1);
		    main_grid.attach (chatbox, 2, 0, 1, 1);
		    main_grid.valign = Gtk.Align.CENTER;

            main_stack = new Gtk.Stack ();
            main_stack.add_named (main_grid, "Interaction View");

		    this.add (main_stack);
		    this.get_style_context ().add_class ("rounded");
		    this.set_resizable (false);
		    this.show_all ();
        }
        private void make_events () {
            enclosure_display.wake_button_clicked.connect (() => {
                app_reference.mycroft_message_manager.send_wake ();
            });
        }
    }
}
