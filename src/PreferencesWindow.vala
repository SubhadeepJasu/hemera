/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
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
    public class PreferencesWindow : Gtk.Dialog {
        private MainWindow window;
        private Gtk.Stack main_stack;
        private const int MIN_WIDTH = 600;
        private const int MIN_HEIGHT = 500;

        private Gtk.Label lang_preview_label;
        private Gtk.Label units_preview_label;
        private Gtk.Label time_format_preview_label;
        private Gtk.Label date_format_preview_label;
        private Gtk.Label location_preview_label;
        private Gtk.Label wakeword_preview_label;
        private Gtk.Label tts_preview_label;
        private Gtk.Label stt_preview_label;
        
        private Hemera.App.Settings settings;

        public PreferencesWindow (MainWindow? parent = null) {

            // Window properties
            title = _("Preferences");
            set_size_request (MIN_WIDTH, MIN_HEIGHT);
            resizable = false;
            window_position = Gtk.WindowPosition.CENTER;
            modal = true;
            if (parent != null) {
                set_transient_for (parent);
                window_position = Gtk.WindowPosition.CENTER_ON_PARENT;
            }
            window = parent;
            
            settings = Hemera.App.Settings.get_default ();
        }
        construct {
            var mode_button = new Granite.Widgets.ModeButton ();;
            mode_button.hexpand = true;
            mode_button.halign = Gtk.Align.CENTER;
            mode_button.append_text (_("Hemera"));
            mode_button.append_text (_("Mycroft"));
            mode_button.append_text (_("About"));

            mode_button.selected = 0;

            main_stack = new Gtk.Stack ();
            main_stack.expand = true;
            main_stack.margin = 12;
            main_stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            main_stack.add_named (get_hemera_general_widget (), "hemera_general");
            main_stack.add_named (get_mycroft_core_widget (), "mycroft_core");
            main_stack.add_named (get_about_widget (), "about");
            
            var content_grid = new Gtk.Grid ();
            content_grid.orientation = Gtk.Orientation.VERTICAL;
            content_grid.add (mode_button);
            content_grid.add (main_stack);
            
            ((Gtk.Container) get_content_area ()).add (content_grid);
            
            mode_button.mode_changed.connect ((widget) => {
                if (mode_button.selected == 0) {
                    main_stack.visible_child_name = "hemera_general";
                } else if (mode_button.selected == 1){
                    main_stack.visible_child_name = "mycroft_core";
                } else {
                    main_stack.visible_child_name = "about";
                }
            });

        }
        private Gtk.Widget get_hemera_general_widget () {
            int pixel_size = 24;

            // Global Language
            var lang_icon = new Gtk.Image ();
            lang_icon.gicon = new ThemedIcon ("preferences-desktop-locale");
            lang_icon.pixel_size = pixel_size;

            var lang_label = new Gtk.Label (_("Language"));
            lang_label.get_style_context ().add_class ("h3");

            lang_preview_label = new Gtk.Label ("English (US)");
            var lang_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            lang_box.margin = 6;
            lang_box.margin_end = 12;
            lang_box.hexpand = true;
            lang_box.pack_start (lang_icon, false, false, 0);
            lang_box.pack_start (lang_label, false, false, 6);
            lang_box.pack_end (lang_preview_label, false, false, 0);

            var lang_eventbox = new Gtk.EventBox ();
            lang_eventbox.add (lang_box);

            // Unit System
            var units_icon = new Gtk.Image ();
            units_icon.gicon = new ThemedIcon ("applications-engineering");
            units_icon.pixel_size = pixel_size;

            var units_label = new Gtk.Label (_("Units of Measurement"));
            units_label.get_style_context ().add_class ("h3");

            units_preview_label = new Gtk.Label ("U.S.");
            var units_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            units_box.margin = 6;
            units_box.margin_end = 12;
            units_box.hexpand = true;
            units_box.pack_start (units_icon, false, false, 0);
            units_box.pack_start (units_label, false, false, 6);
            units_box.pack_end (units_preview_label, false, false, 0);

            var units_eventbox = new Gtk.EventBox ();
            units_eventbox.add (units_box);
            
            // Time Format
            var time_format_icon = new Gtk.Image ();
            time_format_icon.gicon = new ThemedIcon ("preferences-system-time");
            time_format_icon.pixel_size = pixel_size;
            
            var time_format_label = new Gtk.Label (_("Time Format"));
            time_format_label.get_style_context ().add_class ("h3");
            
            time_format_preview_label = new Gtk.Label ("12 Hours");
            var time_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            time_format_box.margin = 6;
            time_format_box.margin_end = 12;
            time_format_box.hexpand = true;
            time_format_box.pack_start (time_format_icon, false, false, 0);
            time_format_box.pack_start (time_format_label, false, false, 6);
            time_format_box.pack_end   (time_format_preview_label, false, false, 0);

            var time_format_eventbox = new Gtk.EventBox ();
            time_format_eventbox.add (time_format_box);
            
            // Date Format
            var date_format_icon = new Gtk.Image ();
            date_format_icon.gicon = new ThemedIcon ("office-calendar");
            date_format_icon.pixel_size = pixel_size;
            
            var date_format_label = new Gtk.Label (_("Date Format"));
            date_format_label.get_style_context ().add_class ("h3");
            
            date_format_preview_label = new Gtk.Label ("DD/MM/YYYY");
            var date_format_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            date_format_box.margin = 6;
            date_format_box.margin_end = 12;
            date_format_box.hexpand = true;
            date_format_box.pack_start (date_format_icon, false, false, 0);
            date_format_box.pack_start (date_format_label, false, false, 6);
            date_format_box.pack_end   (date_format_preview_label, false, false, 0);

            var date_format_eventbox = new Gtk.EventBox ();
            date_format_eventbox.add (date_format_box);
            
            // Confirm Listen
            var confirm_listen_icon = new Gtk.Image ();
            confirm_listen_icon.gicon = new ThemedIcon ("preferences-desktop-sound");
            confirm_listen_icon.pixel_size = pixel_size;
            
            var confirm_listen_label = new Gtk.Label (_("Confirm Listening"));
            confirm_listen_label.get_style_context ().add_class ("h3");
            
            var confirm_listen_switch = new Gtk.Switch ();
            confirm_listen_switch.valign = Gtk.Align.CENTER;
            confirm_listen_switch.get_style_context ().add_class ("active-switch");
            confirm_listen_switch.active = true;
            
            var confirm_listen_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            confirm_listen_box.margin = 6;
            confirm_listen_box.margin_end = 12;
            confirm_listen_box.hexpand = true;
            confirm_listen_box.tooltip_text = _("Play a beep when system begins to listen.");
            confirm_listen_box.pack_start (confirm_listen_icon, false, false, 0);
            confirm_listen_box.pack_start (confirm_listen_label, false, false, 6);
            confirm_listen_box.pack_end   (confirm_listen_switch, false, false, 0);

            var confirm_listen_eventbox = new Gtk.EventBox ();
            confirm_listen_eventbox.add (confirm_listen_box);
            
            // Location
            var location_icon = new Gtk.Image ();
            location_icon.gicon = new ThemedIcon ("library-places");
            location_icon.pixel_size = pixel_size;
            
            var location_label = new Gtk.Label (_("Location"));
            location_label.get_style_context ().add_class ("h3");
            
            location_preview_label = new Gtk.Label ("Lawrence, US");
            var location_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            location_box.margin = 6;
            location_box.margin_end = 12;
            location_box.hexpand = true;
            location_box.pack_start (location_icon, false, false, 0);
            location_box.pack_start (location_label, false, false, 6);
            location_box.pack_end   (location_preview_label, false, false, 0);

            var location_eventbox = new Gtk.EventBox ();
            location_eventbox.add (location_box);
            
            // Wakeword
            var wakeword_icon = new Gtk.Image ();
            wakeword_icon.gicon = new ThemedIcon ("face-tired");
            wakeword_icon.pixel_size = pixel_size;
            
            var wakeword_label = new Gtk.Label (_("Wakeword"));
            wakeword_label.get_style_context ().add_class ("h3");
            
            wakeword_preview_label = new Gtk.Label ("'Hey Hemera!'");
            var wakeword_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            wakeword_box.margin = 6;
            wakeword_box.margin_end = 12;
            wakeword_box.hexpand = true;
            wakeword_box.pack_start (wakeword_icon, false, false, 0);
            wakeword_box.pack_start (wakeword_label, false, false, 6);
            wakeword_box.pack_end   (wakeword_preview_label, false, false, 0);

            var wakeword_eventbox = new Gtk.EventBox ();
            wakeword_eventbox.add (wakeword_box);
            
            // Text to Speech
            var tts_icon = new Gtk.Image ();
            tts_icon.gicon = new ThemedIcon ("audio-card");
            tts_icon.pixel_size = pixel_size;
            
            var tts_label = new Gtk.Label (_("Voice"));
            tts_label.get_style_context ().add_class ("h3");
            
            tts_preview_label = new Gtk.Label ("Google TTS");
            var tts_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            tts_box.margin = 6;
            tts_box.margin_end = 12;
            tts_box.hexpand = true;
            tts_box.pack_start (tts_icon, false, false, 0);
            tts_box.pack_start (tts_label, false, false, 6);
            tts_box.pack_end   (tts_preview_label, false, false, 0);

            var tts_eventbox = new Gtk.EventBox ();
            tts_eventbox.add (tts_box);
            
            // Speech to Text
            var stt_icon = new Gtk.Image ();
            stt_icon.gicon = new ThemedIcon ("audio-input-microphone");
            stt_icon.pixel_size = pixel_size;
            
            var stt_label = new Gtk.Label (_("Speech Recognition"));
            stt_label.get_style_context ().add_class ("h3");
            
            stt_preview_label = new Gtk.Label ("Mycroft");
            var stt_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            stt_box.margin = 6;
            stt_box.margin_end = 12;
            stt_box.hexpand = true;
            stt_box.pack_start (stt_icon, false, false, 0);
            stt_box.pack_start (stt_label, false, false, 6);
            stt_box.pack_end   (stt_preview_label, false, false, 0);

            var stt_eventbox = new Gtk.EventBox ();
            stt_eventbox.add (stt_box);

            // Separators
            var s_0 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_0.margin_start = 36;
            var s_1 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_1.margin_start = 36;
            var s_2 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_2.margin_start = 36;
            var s_3 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_3.margin_start = 36;
            var s_4 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_4.margin_start = 36;
            var s_5 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_5.margin_start = 36;
            var s_6 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_6.margin_start = 36;
            var s_7 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_7.margin_start = 36;
            var s_8 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_8.margin_start = 36;
            
            // Assemble all
            var main_grid = new Gtk.Grid ();
            main_grid.orientation = Gtk.Orientation.VERTICAL;
            
            main_grid.add (lang_eventbox);
            main_grid.add (s_0);
            
            main_grid.add (units_eventbox);
            main_grid.add (s_1);
            
            main_grid.add (time_format_eventbox);
            main_grid.add (s_2);
            
            main_grid.add (date_format_eventbox);
            main_grid.add (s_3);
            
            main_grid.add (confirm_listen_eventbox);
            main_grid.add (s_4);
            
            main_grid.add (location_eventbox);
            main_grid.add (s_5);
            
            main_grid.add (wakeword_eventbox);
            main_grid.add (s_6);
            
            main_grid.add (tts_eventbox);
            main_grid.add (s_7);
            
            main_grid.add (stt_eventbox);
            main_grid.add (s_8);
            
            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.add (main_grid);
            
            var main_frame = new Gtk.Frame (null);
            main_frame.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            main_frame.add (scrolled);
            
            return main_frame;
        }
        private Gtk.Widget get_mycroft_core_widget () {
            
            var mycroft_icon = new Gtk.Image ();
            mycroft_icon.gicon = new ThemedIcon ("avatar-default");
            mycroft_icon.pixel_size = 64;
            mycroft_icon.margin_top = 12;
            mycroft_icon.halign = Gtk.Align.CENTER;
            mycroft_icon.hexpand = true;
            
            var mycroft_label = new Gtk.Label ("Powered by Mycroft %s".printf ("<b>" + Hemera.App.Configs.Constants.VERSION + "</b>"));
            mycroft_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            mycroft_label.halign = Gtk.Align.CENTER;
            mycroft_label.hexpand = true;
            mycroft_label.use_markup = true;
            
            // Update Button
            var update_icon = new Gtk.Image ();
            update_icon.gicon = new ThemedIcon ("system-software-update");
            update_icon.pixel_size = 24;
            
            var update_label = new Gtk.Label (_("Check for Updates"));
            update_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

            var update_preview_label = new Gtk.Label (_("Already up-to-date!"));
            
            var update_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            update_box.margin = 6;
            update_box.pack_start (update_icon, false, false, 0);
            update_box.pack_start (update_label, false, false, 6);
            update_box.pack_end (update_preview_label, false, false, 0);
            
            var update_eventbox = new Gtk.EventBox ();
            update_eventbox.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            update_eventbox.add (update_box);
            
            // Core Location Button
            var core_location_icon = new Gtk.Image ();
            core_location_icon.gicon = new ThemedIcon ("folder-open");
            core_location_icon.pixel_size = 24;
            
            var core_location_label = new Gtk.Label (_("Mycroft Core Location"));
            core_location_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

            var core_location_preview_label = new Gtk.Label ("~/");
            core_location_preview_label.label = settings.mycroft_location;
            
            var core_location_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            core_location_box.margin = 6;
            core_location_box.pack_start (core_location_icon, false, false, 0);
            core_location_box.pack_start (core_location_label, false, false, 6);
            core_location_box.pack_end (core_location_preview_label, false, false, 0);
            
            var core_location_eventbox = new Gtk.EventBox ();
            core_location_eventbox.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            core_location_eventbox.add (core_location_box);
            
            
            var s_1 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_1.margin_start = 36;

            var s_2 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_2.margin_start = 36;
            
            var main_grid = new Gtk.Grid ();
            main_grid.orientation = Gtk.Orientation.VERTICAL;
            main_grid.add (mycroft_icon);
            main_grid.add (mycroft_label);
            main_grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            main_grid.add (update_eventbox);
            main_grid.add (s_1);
            main_grid.add (core_location_eventbox);
            main_grid.add (s_2);
            
            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.add (main_grid);

            var main_frame = new Gtk.Frame (null);
            main_frame.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            main_frame.add (scrolled);
            
            return main_frame;
        }
        private Gtk.Widget get_about_widget () {
            var hemera_icon = new Gtk.Image ();
            hemera_icon.gicon = new ThemedIcon ("com.github.SubhadeepJasu.hemera");
            hemera_icon.pixel_size = 64;
            hemera_icon.margin_top = 12;
            hemera_icon.halign = Gtk.Align.CENTER;
            hemera_icon.hexpand = true;
            
            var hemera_label = new Gtk.Label ("Hemera %s".printf ("<b>" + Hemera.App.Configs.Constants.VERSION + "</b>"));
            hemera_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            hemera_label.halign = Gtk.Align.CENTER;
            hemera_label.hexpand = true;
            hemera_label.use_markup = true;
            
            var hemera_developer = new Gtk.Label ("Subhadeep Jasu");
            hemera_developer.margin_bottom = 12;
            hemera_developer.halign = Gtk.Align.CENTER;
            hemera_developer.hexpand = true;
		    hemera_developer.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
            hemera_developer.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            
            // Home Button
            var home_icon = new Gtk.Image ();
            home_icon.gicon = new ThemedIcon ("internet-web-browser");
            home_icon.pixel_size = 24;
            
            var home_label = new Gtk.Label (_("Home Page"));
            home_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

            var home_end = new Gtk.Image ();
            home_end.gicon = new ThemedIcon ("pan-end-symbolic");
            home_end.pixel_size = 16;
            
            var home_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            home_box.margin = 6;
            home_box.pack_start (home_icon, false, false, 0);
            home_box.pack_start (home_label, false, false, 6);
            home_box.pack_end (home_end, false, false, 0);
            
            var home_eventbox = new Gtk.EventBox ();
            home_eventbox.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            home_eventbox.add (home_box);
            
            // Issue Menu
            var issue_icon = new Gtk.Image ();
            issue_icon.gicon = new ThemedIcon ("bug");
            issue_icon.pixel_size = 24;
            
            var issue_label = new Gtk.Label (_("Report a Issue"));
            issue_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            
            var issue_end = new Gtk.Image ();
            issue_end.gicon = new ThemedIcon ("pan-end-symbolic");
            issue_end.pixel_size = 16;
            
            var issue_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            issue_box.margin = 6;
            issue_box.pack_start (issue_icon, false, false, 0);
            issue_box.pack_start (issue_label, false, false, 6);
            issue_box.pack_end (issue_end, false, false, 0);
            
            var issue_eventbox = new Gtk.EventBox ();
            issue_eventbox.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            issue_eventbox.add (issue_box);
            
            // Translate Menu
            var tr_icon = new Gtk.Image ();
            tr_icon.gicon = new ThemedIcon ("preferences-desktop-locale");
            tr_icon.pixel_size = 24;
            
            var tr_label = new Gtk.Label (_("Translations"));
            tr_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            
            var tr_end = new Gtk.Image ();
            tr_end.gicon = new ThemedIcon ("pan-end-symbolic");
            tr_end.pixel_size = 16;
            
            var tr_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            tr_box.margin = 6;
            tr_box.pack_start (tr_icon, false, false, 0);
            tr_box.pack_start (tr_label, false, false, 6);
            tr_box.pack_end (tr_end, false, false, 0);
            
            var tr_eventbox = new Gtk.EventBox ();
            tr_eventbox.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            tr_eventbox.add (tr_box);

            // Translate Menu
            var donation_icon = new Gtk.Image ();
            donation_icon.gicon = new ThemedIcon ("emblem-favorite");
            donation_icon.pixel_size = 24;
            
            var donation_label = new Gtk.Label (_("Support"));
            donation_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

            var donation_end = new Gtk.Image ();
            donation_end.gicon = new ThemedIcon ("pan-end-symbolic");
            donation_end.pixel_size = 16;

            var donation_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            donation_box.margin = 6;
            donation_box.pack_start (donation_icon, false, false, 0);
            donation_box.pack_start (donation_label, false, false, 6);
            donation_box.pack_end (donation_end, false, false, 0);

            var donation_eventbox = new Gtk.EventBox ();
            donation_eventbox.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            donation_eventbox.add (donation_box);

            // Credits Menu
            var credits_icon = new Gtk.Image ();
            credits_icon.gicon = new ThemedIcon ("help-about");
            credits_icon.pixel_size = 24;
            
            var credits_label = new Gtk.Label (_("Credits"));
            credits_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

            var credits_end = new Gtk.Image ();
            credits_end.gicon = new ThemedIcon ("pan-end-symbolic");
            credits_end.pixel_size = 16;

            var credits_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            credits_box.margin = 6;
            credits_box.pack_start (credits_icon, false, false, 0);
            credits_box.pack_start (credits_label, false, false, 6);
            credits_box.pack_end (credits_end, false, false, 0);

            var credits_eventbox = new Gtk.EventBox ();
            credits_eventbox.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            credits_eventbox.add (credits_box);
            
            var s_1 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_1.margin_start = 36;

            var s_2 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_2.margin_start = 36;

            var s_3 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_3.margin_start = 36;

            var s_4 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            s_4.margin_start = 36;

            var main_grid = new Gtk.Grid ();
            main_grid.orientation = Gtk.Orientation.VERTICAL;
            main_grid.add (hemera_icon);
            main_grid.add (hemera_label);
            main_grid.add (hemera_developer);
            main_grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            main_grid.add (home_eventbox);
            main_grid.add (s_1);
            main_grid.add (issue_eventbox);
            main_grid.add (s_2);
            main_grid.add (tr_eventbox);
            main_grid.add (s_3);
            main_grid.add (donation_eventbox);
            main_grid.add (s_4);
            main_grid.add (credits_eventbox);
            main_grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            
            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.add (main_grid);

            var main_frame = new Gtk.Frame (null);
            main_frame.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
            main_frame.add (scrolled);
            
            return main_frame;
        }
    }
}
