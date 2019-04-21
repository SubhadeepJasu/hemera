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
 */

namespace Hemera.App {
    public class WeatherBubbleCurrent : Gtk.Grid {
        Gtk.Label current_temp_label;
        Gtk.Label condition_label;
        Gtk.Image condition_icon;

        Gtk.Label min_max_temp_label;
        Gtk.Label wind_label;
        Gtk.Label location_label;
        
        private SVGData svg;

        public WeatherBubbleCurrent (string icon, string current_temp, string min_temp, string max_temp, string location, string condition, double humidity, double wind) {
            current_temp_label = new Gtk.Label (("%s°").printf (current_temp));
            current_temp_label.get_style_context ().add_class ("weather_h1");
            current_temp_label.halign = Gtk.Align.START;
            current_temp_label.margin_top = 6;
            current_temp_label.margin_start = 16;
            string cond = ("%s, %s° ~ %s°").printf (get_proper_weather_condition(condition), min_temp, max_temp);
            condition_label = new Gtk.Label (cond);
            condition_label.width_chars = 14;
            condition_label.halign = Gtk.Align.START;
            condition_label.margin_start = 16;
            condition_label.margin_end = 16;
            condition_label.xalign = 0;
            condition_label.get_style_context ().add_class ("weather_h3");
            
            int card_number = 0;
            switch (icon) {
                case "01d":
                    // Clear Day
                    condition_icon = new Gtk.Image.from_icon_name ("weather-clear-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 1;
                    break;
                case "01n":
                    // Clear Night
                    condition_icon = new Gtk.Image.from_icon_name ("weather-clear-night-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 2;
                    break;
                case "03d":
                case "03n":
                    // Overcast
                    condition_icon = new Gtk.Image.from_icon_name ("weather-overcast-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 3;
                    break;
                case "04d":
                    // Partly Cloudy Day
                    condition_icon = new Gtk.Image.from_icon_name ("weather-few-clouds-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 4;
                    break;
                case "04n":
                    // Partly Cloudy Night
                    condition_icon = new Gtk.Image.from_icon_name ("weather-few-clouds-night-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 5;
                    break;
                case "09d":
                case "09n":
                    // Showers or Heavy Rain
                    condition_icon = new Gtk.Image.from_icon_name ("weather-showers-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 6;
                    break;
                case "10d":
                case "10n":
                    // Partly Rainy
                    condition_icon = new Gtk.Image.from_icon_name ("weather-showers-scattered-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 7;
                    break;
                case "11d":
                case "11n":
                    // Thunder Storm
                    condition_icon = new Gtk.Image.from_icon_name ("weather-storm-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 8;
                    break;
                case "13d":
                case "13n":
                    // Snowy
                    condition_icon = new Gtk.Image.from_icon_name ("weather-snow-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 9;
                    break;
                case "50d":
                    // Foggy or Misty
                    condition_icon = new Gtk.Image.from_icon_name ("weather-fog-symbolic", Gtk.IconSize.DIALOG);
                    card_number = 10;
                    break;
                default:
                    // Unknown or Possibly Bad Condition
                    condition_icon = new Gtk.Image.from_icon_name ("weather-severe-alert-symbolic", Gtk.IconSize.DIALOG);
                    break;
            }
            try {
                var provider = new Gtk.CssProvider ();
                string provider_data = (".weather_bubble {background-image: url(\"resource://com/github/SubhadeepJasu/hemera/images/weather/%s_card.png\");
                border: 1px solid %s;}").printf (get_weather_card(card_number), get_weather_color (card_number));
                provider.load_from_data (provider_data);
                Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            }
            catch (Error e) {
                error (e.message);
            }
            
            condition_icon.valign = Gtk.Align.START;
            condition_icon.margin_top = 6;
            condition_icon.margin_end = 16;
            string humid = ("Humidity: %s%%").printf(humidity.to_string ());
            min_max_temp_label = new Gtk.Label (humid);
            min_max_temp_label.halign = Gtk.Align.START;
            min_max_temp_label.get_style_context ().add_class ("weather_h3");
            wind_label = new Gtk.Label (("Wind: %.0lf").printf (wind));
            wind_label.halign = Gtk.Align.START;
            wind_label.get_style_context ().add_class ("weather_h3");
            
            location_label = new Gtk.Label (one_line (location));
            location_label.halign = Gtk.Align.START;
            location_label.get_style_context ().add_class ("weather_h4");
            
            var reveal_button = new Gtk.Button.from_icon_name ("view-more-horizontal-symbolic", Gtk.IconSize.BUTTON);
            reveal_button.get_style_context ().add_class ("reveal_button_dark");
            reveal_button.margin_top = 8;
            
            var weather_grid = new Gtk.Grid ();
            weather_grid.attach (current_temp_label, 0, 0, 1, 1);
            weather_grid.attach (condition_icon, 1, 0, 1, 2);
            weather_grid.attach (condition_label, 0, 1, 1, 1);
            
            var extra_grid = new Gtk.Grid ();
            
            extra_grid.attach (min_max_temp_label, 0, 0, 1, 1);
            extra_grid.attach (wind_label, 0, 1, 1, 1);
            extra_grid.attach (location_label, 0, 2, 1, 1);
            
            var revealer = new Gtk.Revealer ();
            revealer.margin_start = 16;
            revealer.margin_end = 16;
            revealer.add (extra_grid);
            weather_grid.attach (revealer, 0, 2, 2, 1);
            reveal_button.clicked.connect (() => {
                if (revealer.get_reveal_child ()) {
                    revealer.set_reveal_child (false);
                }
                else {
                    revealer.set_reveal_child (true);
                }
            });
            revealer.set_transition_type (Gtk.RevealerTransitionType.SLIDE_DOWN);
            
            
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.pack_start (weather_grid);
            box.pack_end (reveal_button);
            
            svg = new SVGData (get_weather_color (card_number), get_weather_color (card_number));
            var image = new Gtk.Image.from_pixbuf (svg.get_call_out_image (false));
            image.margin_bottom = 4;
            image.halign = Gtk.Align.START;
            image.valign = Gtk.Align.END;
            attach (image, 0, 0, 1, 1);
            attach (box, 2, 0, 1, 1);
            box.get_style_context ().add_class ("weather_bubble");
            halign = Gtk.Align.START;
            valign = Gtk.Align.START;
            margin_bottom = 8;
            show_all ();
            animate_bubble ();
            size_allocate.connect (() => {
                queue_draw ();
            });
        }
        private static string get_weather_card (int card_number) {
            switch (card_number) {
                case 1:
                    return "clear_day";
                case 2:
                    return "clear_night";
                case 3:
                    return "overcast";
                case 4:
                    return "cloudy_day";
                case 5:
                    return "cloudy_night";
                case 6:
                    return "heavy_rain";
                case 7:
                    return "light_rain";
                case 8:
                    return "t_storm";
                case 9:
                    return "snowy";
                case 10:
                    return "foggy";
                default:
                    return "unknown";
            }
        }
        private static string get_weather_color (int card_number) {
            switch (card_number) {
                case 1:
                    return "#204879";
                case 2:
                    return "#010101";
                case 3:
                    return "#413f48";
                case 4:
                    return "#134451";
                case 5:
                    return "#0b1320";
                case 6:
                    return "#021019";
                case 7:
                    return "#1c393c";
                case 8:
                    return "#1e1e1e";
                case 9:
                    return "#0c1011";
                case 10:
                    return "#364462";
                default:
                    return "#cb9800";
            }
        }
        private static string get_proper_weather_condition (string cond) {
            switch (cond) {
                case "clear":
                    return "Clear";
                case "light rain":
                    return "Light Rain";
                case "broken clouds":
                    return "Partly Cloudy";
                case "heavy intensity rain":
                    return "Heavy Rain";
                default:
                    return cond;
            }
        }
        private static string one_line (string str) {
            return str.replace ("\n", ", ");
        }
        private void animate_bubble () {
            Timeout.add (0, () => {
                get_style_context ().add_class ("speech_bubble_start_animate");
                return false;
            });
        }
    }
}
