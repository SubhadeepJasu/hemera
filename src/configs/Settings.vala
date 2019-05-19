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

namespace Hemera.Configs {
    public class Settings : Granite.Services.Settings {
        private static Settings settings;
        public static unowned Settings get_default () {
            if (settings == null) {
                settings = new Settings ();
            }
            return settings;
        }
        private Settings () {
            base (Constants.ID);
        }
        public string mycroft_location {get; set;}
        public int    window_width {get; set;}
        public int    window_height {get; set;}
        public bool   override_remote_settings {get; set;}
        public bool   launch_at_startup {get; set;}
    }
}
