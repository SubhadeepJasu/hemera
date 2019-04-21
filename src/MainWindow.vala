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

namespace Hemera.App {
    public class MainWindow : Gtk.Window {
        private Hemera.App.DisplayEnclosure enclosure_display;
        private ChatView chatbox;
        private Gtk.Grid main_grid;
        private InitSplash welcome_screen;
        private Gtk.HeaderBar headerbar;
        private Gtk.Stack main_stack;
        public Hemera.App.HemeraApp app_reference;

        public MainWindow (Hemera.App.HemeraApp application) {
            icon_name = "com.github.SubhadeepJasu.hemera";
            this.app_reference = application;
            make_ui ();
            make_events ();
            make_mycroft_incoming_events ();
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

            enclosure_display = new Hemera.App.DisplayEnclosure (this);
            var separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);

            chatbox = new ChatView ();

            main_grid = new Gtk.Grid ();
            main_grid.attach (enclosure_display, 0, 0, 1, 1);
            main_grid.attach (separator, 1, 0, 1, 1);
            main_grid.attach (chatbox, 2, 0, 1, 1);
            main_grid.valign = Gtk.Align.CENTER;

            welcome_screen = new InitSplash ();

            main_stack = new Gtk.Stack ();
            main_stack.add_named (main_grid, "Interaction View");
            main_stack.add_named (welcome_screen, "Welcome View");

            main_stack.transition_type = Gtk.StackTransitionType.OVER_LEFT_RIGHT;
            this.add (main_stack);
            this.get_style_context ().add_class ("rounded");
            this.set_resizable (false);
            this.show_all ();
        }
        private void make_events () {
            enclosure_display.wake_button_clicked.connect (() => {
                app_reference.mycroft_message_manager.send_wake ();
            });
            enclosure_display.invoke_mode_changed.connect ((opt) => {
                if (opt == 0) {
                    app_reference.mycroft_message_manager.send_mic_on ();
                }
                else {
                    app_reference.mycroft_message_manager.send_mic_off ();
                }
            });
            welcome_screen.user_attempt_reconnect.connect (() => {
                app_reference.mycroft_connection.init_ws ();
            });
        }
        public void set_launch_screen (int? screen = 0) {
            switch (screen) {
                case 1:
                    main_stack.set_visible_child (main_grid);
                    enclosure_display.animate_button ();
                    break;
                default:
                    main_stack.set_visible_child (welcome_screen);
                    break;
            }
        }
        private void make_mycroft_incoming_events () {
            chatbox.send_message_text.connect ((utterance) => {
                app_reference.mycroft_message_manager.send_utterance (utterance);
            });
            app_reference.mycroft_message_manager.connection_established.connect (() => {
                Timeout.add (500, () => {
                chatbox.push_mycroft_text ("Hi! I am Hemera");
                return false;
                });
                Timeout.add (800, () => {
                    var randomizer = new Rand();
                    var rand = randomizer.int_range (0, 3);
                    switch (rand) {
                        case 0:
                            chatbox.push_mycroft_text ("How may I help you?");
                            break;
                        case 1:
                            chatbox.push_mycroft_text ("How may I be of service?");
                            break;
                        case 2:
                            chatbox.push_mycroft_text ("May I help you?");
                            break;
                        default:
                            chatbox.push_mycroft_text ("Ask me anything you want!");
                            break;
                    }
                    return false;
                });
            });
            app_reference.mycroft_message_manager.receive_speak.connect ((utterance_in, response_expected) => {
                chatbox.push_mycroft_text (utterance_in);
            });
            app_reference.mycroft_message_manager.receive_utterance.connect ((utterance_out) => {
                chatbox.push_user_text (utterance_out);
            });
            app_reference.mycroft_message_manager.receive_qna.connect ((query, answer, skill, conf) => {
                chatbox.push_qna (query, answer, skill, conf);
            });
            app_reference.mycroft_message_manager.receive_current_weather.connect ((icon, current_temp, min_temp, max_temp, location, condition, humidity, wind) => {
                chatbox.push_current_weather (icon, current_temp, min_temp, max_temp, location, condition, humidity, wind);
            });
            
        }
        public void chat_launch_app (Hemera.Core.AppEntry app) {
            chatbox.push_app_launch (app);
        }
    }
}
