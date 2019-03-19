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
        private Gtk.HeaderBar headerbar;
        public MainWindow () {
            icon_name = "com.github.SubhadeepJasu.hemera";
            make_ui ();
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

		    Gtk.Label label = new Gtk.Label ("Hello, GTK");
		    this.add (label);
		    this.get_style_context ().add_class ("rounded");
		    this.set_resizable (false);
		    this.show_all ();
        }
    }
}
