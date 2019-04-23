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
using GLib;

namespace Hemera.Core {
    public class LevenshteinDistanceSearch{
        public static int search (AppEntry[] list_of_apps, string query) {
            int min = 1000;
            int index = 0;
            for (int i = 0; i < list_of_apps.length; i++) {
                int distance = compute_distance (simplify(list_of_apps [i].app_name), simplify(query));
                if (distance < min) {
                    min = distance;
                    index = i;
                }
            }
            if (min > 2) {
                return -1;
            }
            return index;
        }
        private static int compute_distance (string required_string, string query_string) {
            int required_string_length = required_string.length;
            int query_string_length = query_string.length;
            /* For all i and j, distance[i,j] will hold the Levenshtein distance
             * between the first i characters of required_string and the first
             * j characters of query_string, note that distance has
             * (required_string_length+1)*(query_string_length+1) values
             */
            int[,] distance = new int [required_string_length + 1, query_string_length + 1];

            // Base case: empty strings
            if (required_string_length == 0) {
                return query_string_length;
            }
            if (query_string_length == 0) {
                return required_string_length;
            }
            // Source prefixes can be transformed into empty string by
            // dropping all characters
            for (int i = 0; i <= required_string_length; distance[i, 0] = i++);

            // Target prefixes can be reached from empty source prefix
            // by inserting every character
            for (int j = 0; j <= query_string_length; distance[0, j] = j++);

            for (int i = 1; i <= required_string_length; i++) {
                for (int j = 1; j <= query_string_length; j++) {
                    int cost = (query_string[j - 1] == required_string[i - 1]) ? 0 : 1;

                    distance[i, j] = int.min(
                        int.min(distance[i - 1, j] + 1,          // deletion
                        distance[i, j - 1] + 1),                 // insertion
                        distance[i - 1, j - 1] + cost);          // substitution
                }
            }
            return distance[required_string_length, query_string_length];
        }
        private static string simplify (string given_string) {
            string output_string = given_string.replace (" ", "");
            output_string = output_string.replace ("-", "");
            output_string = output_string.replace (".", "");
            output_string = output_string.replace (",", "");
            return output_string.down ();
        }
    }
}
