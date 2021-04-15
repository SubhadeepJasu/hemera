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

namespace Hemera.Models {
    public class MycroftSettingsModel {
        public string   lang { get; set; }

        public string   system_unit { get; set; }

        public string   time_format { get; set; }
        public string   date_format { get; set; }

        public bool     opt_in { get; set; }

        public bool     confirm_listening { get; set; }

        public string   location_city_code { get; set; }
        public string   location_city_name { get; set; }
        public string   location_state_code { get; set; }
        public string   location_state_name { get; set; }
        public string   location_country_code { get; set; }
        public string   location_country_name { get; set; }
        public double   location_coordinate_latitude { get; set; }
        public double   location_coordinate_longitude { get; set; }
        public string   location_timezone_code { get; set; }
        public string   location_timezone_name { get; set; }
        public int64    location_timezone_dstOffset { get; set; }
        public int64    location_timezone_offset { get; set; }

        public string   websocket_host { get; set; }
        public int      websocket_port { get; set; }
        public bool     websocket_ssl  { get; set; }

        public bool     listener_wake_word_upload_disable { get; set; }
        public string   listener_wake_word_upload_url { get; set; }
        public bool     listener_mute_during_output { get; set; }
        public float    listener_duck_while_listening { get; set; }
        public string   listener_wake_word { get; set; }
        public string   listener_wake_word_phonemes { get; set; }
    }
}