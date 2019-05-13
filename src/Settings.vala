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
 * Authored by: Subhadeep Jasu
 */

namespace Hemera.App {
    public class Settings : Granite.Services.Settings {
        private static Settings settings;
        public static Settings get_default () {
            if (settings == null) {
                settings = new Settings ();
            }
            return settings;
        }
        public string mycroft_location {get; set;}
        public bool override_remote_settings {get; set;}
        public bool launch_at_startup {get; set;}
        private Settings () {
            base ("com.github.SubhadeepJasu.hemera");
        }
    }
}
