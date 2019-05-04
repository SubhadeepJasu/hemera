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
 * Authored by: Subhadeep Jasu <subhajasu@gmail.com>
 */

namespace Hemera.App {
    public class MainDynamicButton : Gtk.Overlay {
        private Gtk.Button wake_button;
        private EnclosureFace face;
        private MainWindow window;
        private LightRingAnimator animation_handle;
        private bool _personify = false;
        private bool personify {
            get {
                return _personify;
            }
            set {
                _personify = value;
                set_face_personification ();
            }
        }
        private bool _blink = false;
        private bool blink {
            get {
                return _blink;
            }
            set {
                _blink = value;
                set_face_personification ();
            }
        }
        private bool _talking = false;
        private bool talking {
            get {
                return _talking;
            }
            set {
                _talking = value;
                animate_ring ();
            }
        }
        private int talking_mode = 0;
        private int volume = 0;

        public signal void clicked ();
        public MainDynamicButton (MainWindow window) {
            this.window = window;
            make_ui ();
            make_events ();
        }
        private void make_ui () {
            wake_button = new Gtk.Button.with_label ("Wake");
            face = new EnclosureFace ();
            wake_button.get_style_context ().add_class ("main_wake_button_pre_load");
            wake_button.get_style_context ().add_class ("main_wake_button");
            animation_handle = new LightRingAnimator (wake_button);
            add_overlay (wake_button);
            add_overlay (face);
            set_overlay_pass_through (face, true);
            width_request = 200;
            height_request= 200;
            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.CENTER;
            margin_top = 0;
            margin_bottom = 0;
        }
        private void make_events () {
            wake_button.clicked.connect (() => {
                this.clicked ();
            });
            window.app_reference.mycroft_message_manager.receive_record_begin.connect (() => {
                face.mic_set_listening ();
            });
            window.app_reference.mycroft_message_manager.receive_record_end.connect (() => {
                face.mic_set_default ();
            });
            window.app_reference.mycroft_message_manager.receive_record_failed.connect (() => {
                face.mic_set_listen_failed ();
            });
            window.app_reference.mycroft_message_manager.receive_audio_output_start.connect (() => {
                personify = true;
                talking = true;
            });
            window.app_reference.mycroft_message_manager.receive_audio_output_end.connect (() => {
                talking = false;
                personify_timeout ();
            });
            window.app_reference.mycroft_message_manager.receive_eyes_blink.connect ((s_side) => {
                blink = true;
                switch (s_side) {
                    case ("r"):
                        face.mic_personify_blink (2);
                        break;
                    case ("l"):
                        face.mic_personify_blink (1);
                        break;
                    default:
                        face.mic_personify_blink (0);
                        break;
                }
                Timeout.add (500, () => {
                    blink = false;
                    return false;
                });
            });
            window.app_reference.mycroft_message_manager.receive_fallback_unknown.connect (() => {
                talking_mode = 1;
            });
            window.app_reference.mycroft_message_manager.receive_volume_change.connect ((i_volume) => {
                talking_mode = 2;
                this.volume = (int)i_volume;
                face.set_volume_icon (volume);
            });
            window.app_reference.mycroft_message_manager.receive_thinking.connect (() => {
                window.main_spinner.active = true;
            });
            window.app_reference.mycroft_message_manager.receive_query_timed_out.connect (() => {
                window.main_spinner.active = false;
            });
        }
        private void personify_timeout () {
            this.personify = true;
            Timeout.add (1500, () => {
                this.personify = false;
                return false;
            });
        }
        public void animate_button () {
            Timeout.add (100, () => {
                wake_button.get_style_context ().remove_class ("main_wake_button_pre_load");
                face.animate_face ();
                return false;
            });
        }
        public void set_face_personification () {
            bool b_personification_enabled = personify || blink || talking;
            if (b_personification_enabled) {
                face.mic_personify_idle ();
            } else {
                face.disable_personification ();
            }
        }
        private void animate_ring () {
            if (talking) {
                animation_handle.begin_animation ();
                switch (talking_mode) {
                    case 1:
                        animation_handle.set_animation_type (AnimationType.ERROR);
                        break;
                    case 2:
                        animation_handle.set_animation_type (AnimationType.SYSTEM_SPEAKING);
                        break;
                    default:
                        animation_handle.set_animation_type (AnimationType.DEFAULT_SPEAKING);
                        break;
                }
            } else {
                animation_handle.end_animation ();
                animation_handle.set_animation_type (AnimationType.IDLE);
                talking_mode = 0;
            }
        }
    }
}
