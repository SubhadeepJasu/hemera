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
    public class AppDiscovery {
        public static AppInfo[] discover_apps () {
            List <AppInfo?> infos = AppInfo.get_all();
            AppInfo[] app_infos = new AppInfo[0];
            int i = 0;
            infos.foreach ((app_item) => {
                if (app_item.should_show()) {
                    app_infos.resize (app_infos.length + 1);
                    app_infos[i++] = app_item;
                }
            });
            return app_infos;
        }
    }
}
