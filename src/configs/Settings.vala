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

    /**
     * The {@code Settings} class is responsible for defining all
     * the texts that are displayed in the application and must be translated.
     *
     * @see Granite.Services.Settings
     * @since 1.0.0
     */
    public class Settings : Granite.Services.Settings {

        /**
         * This static property represents the {@code Settings} type.
         */
        private static Settings settings;

        /**
         * Returns a single instance of this class.
         *
         * @return {@code Settings}
         */
        public static unowned Settings get_default () {
            if (settings == null) {
                settings = new Settings ();
            }
            return settings;
        }

        /**
         * Constructs a new {@code Settings} object
         * and sets the default exit folder.
         */
        private Settings () {
            base (Constants.ID);
        }

        /**
         * This property represents the location of mycroft-core
         * Variable of type {@code string} as declared.
         */
        public string mycroft_location {get; set;}

        /**
         * This property represents the IP Address that Hemera 
         * attempts to connect through to Mycroft Server
         */
        public string mycroft_ip {get; set;}

        /**
         * This property represents the Port used by the Mycroft
         * Server 
         */
        public string mycroft_port {get; set;}

        /**
         * This property represents the Port used by the Mycroft
         * Server 
         */
        public bool   rewrite_mycroft_settings {get; set;}
        
        /**
         * This property represents the width of MainWindow
         * Variable of type {@code int} as declared.
         * @see Hemera.App.MainWindow
         */

        public int    window_width {get; set;}

        /**
         * This property represents the height of MainWindow
         * Variable of type {@code int} as declared.
         * @see Hemera.App.MainWindow
         */
        public int    window_height {get; set;}

        /**
         * This property is set to true when the user opts to let Hemera handle
         * Mycroft settings
         * Variable of type {@code bool} as declared.
         */
        public bool   override_remote_settings {get; set;}

        /**
         * This property is set to true when the user opts to start Hemera on
         * start up
         * Variable of type {@code bool} as declared.
         */
        public bool   launch_at_startup {get; set;}
    }
}
