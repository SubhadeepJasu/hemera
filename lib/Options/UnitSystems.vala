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


namespace Hemera.Options {
    public class UnitSystems {
        public const string[] unit_code = {
            "metric",
            "english"
        };

        public const string[] names = {
            "Metric",
            "Imperial"
        };

        public static string get_name_from_unit_codes (string unit_codes) {
            int i = 0;
            for (; i < unit_code.length; i++) {
                if (unit_codes == unit_code[i]) {
                    return names[i];
                }
            }
            return "";
        }

        public static int get_unit_codes_index (string unit_codes) {
            int i = 0;
            for (; i < unit_code.length; i++) {
                if (unit_codes == unit_code[i]) {
                    return i;
                }
            }
            return -1;
        }

        public static int length () {
            return unit_code.length;
        }
    }
}