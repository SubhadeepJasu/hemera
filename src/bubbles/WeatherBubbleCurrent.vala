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

        public WeatherBubbleCurrent (string icon, string current_temp, string min_temp, string max_temp, string location, string condition, double humidity, double wind) {
            current_temp_label = new Gtk.Label (("%s°").printf (current_temp));
            current_temp_label.get_style_context ().add_class ("weather_h1");
            current_temp_label.halign = Gtk.Align.START;
            string cond = ("%s, %s° ~ %s°").printf (condition, min_temp, max_temp);
            condition_label = new Gtk.Label (cond);
            condition_label.width_chars = 14;
            condition_label.halign = Gtk.Align.START;
            condition_label.xalign = 0;
            condition_label.get_style_context ().add_class ("weather_h3");
            
            if (icon == "01d") {
                // Clear Day
                condition_icon = new Gtk.Image.from_icon_name ("weather-clear-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "01n") {
                // Clear Night
                condition_icon = new Gtk.Image.from_icon_name ("weather-clear-night-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "03d" || icon == "03n") {
                // Overcast
                condition_icon = new Gtk.Image.from_icon_name ("weather-overcast-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "04d") {
                // Partly Cloudy Day
                condition_icon = new Gtk.Image.from_icon_name ("weather-few-clouds-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "04d") {
                // Partly Cloudy Night
                condition_icon = new Gtk.Image.from_icon_name ("weather-few-clouds-night-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "09d" || icon == "09n") {
                // Showers or Heavy Rain
                condition_icon = new Gtk.Image.from_icon_name ("weather-showers-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "10d" || icon == "10n") {
                // Partly Rainy
                condition_icon = new Gtk.Image.from_icon_name ("weather-showers-scattered-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "11d" || icon == "11n") {
                // Thunder Storm
                condition_icon = new Gtk.Image.from_icon_name ("weather-storm-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "13d" || icon == "13n") {
                // Snowy
                condition_icon = new Gtk.Image.from_icon_name ("weather-snow-symbolic", Gtk.IconSize.DIALOG);
            }
            else if (icon == "50d") {
                // Foggy or Misty
                condition_icon = new Gtk.Image.from_icon_name ("weather-fog-symbolic", Gtk.IconSize.DIALOG);
            }
            else {
                // Unknown or Possibly Bad Condition
                condition_icon = new Gtk.Image.from_icon_name ("weather-severe-alert-symbolic", Gtk.IconSize.DIALOG);
            }
            condition_icon.valign = Gtk.Align.START;
            string humid = ("Humidity: %s%%").printf(humidity.to_string ());
            min_max_temp_label = new Gtk.Label (humid);
            min_max_temp_label.halign = Gtk.Align.START;
            min_max_temp_label.get_style_context ().add_class ("weather_h3");
            wind_label = new Gtk.Label (("Wind: %.0lf").printf (wind));
            wind_label.halign = Gtk.Align.START;
            wind_label.get_style_context ().add_class ("weather_h3");
            
            location_label = new Gtk.Label (location);
            location_label.halign = Gtk.Align.START;
            location_label.get_style_context ().add_class ("weather_h4");
            
            var weather_grid = new Gtk.Grid ();
            weather_grid.attach (current_temp_label, 0, 0, 1, 1);
            weather_grid.attach (condition_icon, 1, 0, 1, 2);
            weather_grid.attach (condition_label, 0, 1, 1, 1);
            weather_grid.attach (min_max_temp_label, 0, 2, 2, 1);
            weather_grid.attach (wind_label, 0, 3, 2, 1);
            weather_grid.attach (location_label, 0, 4, 2, 1);
            
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.pack_start (weather_grid);
            
            attach (box, 0, 0, 1, 1);
            box.get_style_context ().add_class ("weather_bubble");
            halign = Gtk.Align.START;
            valign = Gtk.Align.START;
            margin_bottom = 8;
            show_all ();
        }
    }
}
