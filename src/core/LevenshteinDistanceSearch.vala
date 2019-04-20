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
    public class LevenshteinDistanceSearch {
        public static int search (AppEntry[] list_of_apps, string query) {
            int min = 1000;
            int index = 0;
            for (int i = 0; i < list_of_apps.length; i++) {
                int distance = compute_distance (list_of_apps [i].app_name, query);
                if (distance < min) {
                    min = distance;
                    index = i;
                }
            }
            if (min > 2) {
                return (0 - 1);
            }
            return index;
        }
        private static int compute_distance (string s, string t) {
            int n = s.length;
            int m = t.length;
            int[,] d = new int [n + 1, m + 1];

            // Step 1
            if (n == 0)
            {
                return m;
            }
            if (m == 0)
            {
                return n;
            }
            // Step 2
            for (int i = 0; i <= n; d[i, 0] = i++);

            for (int j = 0; j <= m; d[0, j] = j++);

            // Step 3
            for (int i = 1; i <= n; i++)
            {
                //Step 4
                for (int j = 1; j <= m; j++)
                {
                    // Step 5
                    int cost = (t[j - 1] == s[i - 1]) ? 0 : 1;

                    // Step 6
                    d[i, j] = int.min(
                        int.min(d[i - 1, j] + 1, d[i, j - 1] + 1),
                        d[i - 1, j - 1] + cost);
                }
            }
            // Step 7
            return d[n, m];
        }
    }
}
