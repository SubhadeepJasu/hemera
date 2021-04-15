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

    public struct PlugInfo {
        public string title;
        public string icon;
        public string uri;
        public string app_name;
        public string[] path;
    }

    public class SwitchBoardPlugSearch {
        PlugInfo[] switchboard_plugs;
        public signal void list_populated ();

        public SwitchBoardPlugSearch () {
            try {
                populate_switchboard_plugs.begin ();
            } catch (Error e) {
                warning ("%s\n", e.message);
            }
        }
        private async int populate_switchboard_plugs () {
            var plugs_manager = Switchboard.PlugsManager.get_default ();
            PlugInfo[] children = {};
            foreach (var plug in plugs_manager.get_plugs ()) {
                var settings = plug.supported_settings;
                if (settings == null || settings.size <= 0) {
                    continue;
                }
    
                string uri = settings.keys.to_array ()[0];
                var plug_info = PlugInfo () {
                    title = plug.display_name,
                    app_name = plug.display_name,
                    icon = plug.icon,
                    uri = uri,
                    path = {}
                };
                children += plug_info;
    
                // Using search to get sub settings
                var search_results = yield plug.search ("");
                foreach (var result in search_results.entries) {
                    unowned string title = result.key;
                    var view = result.value;
    
                    // get uri from plug's supported_settings
                    // Use main plug uri as fallback
                    string sub_uri = uri;
                    if (view != "") {
                        foreach (var setting in settings.entries) {
                            if (setting.value == view) {
                                sub_uri = setting.key;
                                break;
                            }
                        }
                    }
    
                    string[] path = title.split (" → ");
    
                    plug_info = PlugInfo () {
                        title = title,
                        icon = plug.icon,
                        uri = (owned) sub_uri,
                        app_name = path[path.length - 1],
                        path = (owned) path
                    };
                    children += plug_info;
                }
            }
            switchboard_plugs = children;
            for (int i = 0; i < switchboard_plugs.length; i++) {
                print(switchboard_plugs[i].app_name + "\n");
            }
            list_populated ();
            return 0;
        }
        public PlugInfo get_plug_by_search (string query) throws SEARCH_ERROR.NO_SEARCH_RESULTS, SEARCH_ERROR.SAME_APP {
            int search_index = LevenshteinDistanceSearch.search_plugs (switchboard_plugs, query);
            if (search_index == -1) {
                throw new SEARCH_ERROR.NO_SEARCH_RESULTS ("Sorry, I couldn't find the settings entry");
            }
            return switchboard_plugs [search_index];
        }
    }
}
