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
    public class AppSearch {
        AppEntry[] apps;
        AppInfo[]  app_info;
        public signal void list_populated ();

        public AppSearch () {
            try {
                Thread<int> thread_a = new Thread<int>.try ("app_list_thread", populate_app_list);
            } catch (Error e) {
                warning ("%s\n", e.message);
            }
        }
        private int populate_app_list () {
            app_info = AppDiscovery.discover_apps ();
            apps = new AppEntry [app_info.length];
            for (int i = 0; i < app_info.length; i++) {
                apps [i] = new AppEntry (app_info[i]);
            }
            list_populated ();
            return 0;
        }
        public AppEntry get_app_by_search (string query) {
            int search_index = LevenshteinDistanceSearch.search (apps, query);
            if (search_index == -1) {
                return null;
            }
            return apps [search_index];
        }
    }
}
