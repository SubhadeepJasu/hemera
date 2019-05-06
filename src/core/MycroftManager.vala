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

namespace Hemera.Core {
    public class MycroftManager {
        public signal void mycroft_launch_failed ();
        public signal void mycroft_launched ();
        public signal void mycroft_launch_error ();
        public signal void mycroft_update_available (string tag, string body, string download_url);
        public signal void mycroft_update_failed ();
        public signal void mycroft_finish_download ();
        public string mycroft_install_location = "~/mycroft-core";
        private string user_home_directory = "~/";

        public MycroftManager () {
            user_home_directory = GLib.Environment.get_home_dir ();
            mycroft_install_location = user_home_directory.concat ("/mycroft-core");
        }

        public bool start_mycroft () {
            string mc_stdout = "", ms_stderr = "";
            int mc_status = 0;
            bool b_status = true;
            Timeout.add (100, () => {
                string launch_command = (".%s/start-mycroft.sh all").printf (mycroft_install_location);
                warning (launch_command);
                try {
                GLib.Process.spawn_command_line_sync (launch_command,
                                                      out mc_stdout,
                                                      out ms_stderr,
                                                      out mc_status);
                }
                catch (SpawnError e) {
                    mycroft_launch_failed ();
                    return false;
                }
                try {
                    b_status = GLib.Process.check_exit_status (mc_status);
                }
                catch (Error e) {
                    mycroft_launch_error ();
                    return false;
                }
                if (mc_stdout.contains ("Starting background service enclosure")) {
                    mycroft_launched ();
                } else {
                    mycroft_launch_failed ();
                }
                return false;
            });
            return b_status;
        }
        public void stop_mycroft () {
            string mc_stdout = "", ms_stderr = "";
            int mc_status = 0;
            bool b_status = true;
            Timeout.add (100, () => {
                string stop_command = ("cd %s && ./stop-mycroft.sh all").printf (mycroft_install_location);
                GLib.Process.spawn_command_line_sync (stop_command,
                                                      out mc_stdout,
                                                      out ms_stderr,
                                                      out mc_status);
                return false;
            });
        }
        public bool download_mycroft (string uri_endpoint) {
            MainLoop loop = new MainLoop ();

            var file_path = File.new_for_path (user_home_directory.concat ("/.mycroft-core.tar.gz"));
            var file_from_uri = File.new_for_uri (uri_endpoint);
            var progress = 0.0;
            if (!file_path.query_exists ()) {
                file_from_uri.copy_async.begin (file_path, 
                    FileCopyFlags.OVERWRITE | FileCopyFlags.ALL_METADATA, GLib.Priority.DEFAULT, 
                    null, (current_num_bytes, total_num_bytes) => {
                        // Report copy-status:
                        progress = (double) current_num_bytes / total_num_bytes;
                        total_num_bytes = total_num_bytes == 0 ? Hemera.App.Configs.Constants.MYCROFT_TAR_SIZE : total_num_bytes;
                        print ("%" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n", current_num_bytes, total_num_bytes);
                        //show_progress (progress);
	                }, (obj, res) => {
                        try {
                            bool tmp = file_from_uri.copy_async.end (res);
                            print ("Result: %s\n", tmp.to_string ());
                            //#if WITH_UNITY
                            //launcher.progress_visible = false;
                            //#endif
                            mycroft_finish_download ();
                        } catch (Error e) {
                            warning ("Error Coping to folder: %s", e.message);
                        }
		                loop.quit ();
                });
            }else {
                //print ("Picture %s already exist\n", img_file_name);
                mycroft_finish_download ();
				//bar.set_fraction (1);
				return true;
            }
            loop.run ();
            return true;
        }
        public bool check_updates () {
            if (!Thread.supported ()) {
                warning ("Thread support missing. Please wait for web API access...\n");
                fetch_updates ();
                return true;
            }
            else {
                try {
                    Thread<int> thread_u = new Thread<int>.try ("thread_u", fetch_updates);
                } catch (Error e) {
                    warning ("%s\n", e.message);
                    mycroft_update_failed ();
                    return false;
                }
            }
            return true;
        }
        int fetch_updates () {
            var uri = "https://api.github.com/repos/MycroftAI/mycroft-core/releases/latest";
            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.user_agent = "com.github.SubhadeepJasu.hemera";
            if(session.send_message (message) != 200) {
                mycroft_update_failed ();
                return 1;
            }
            try {
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);
                var root_object = parser.get_root ().get_object();
                var tag = root_object.get_string_member ("tag_name");
                var download_url = root_object.get_string_member ("tarball_url");
                var body = root_object.get_string_member ("body");
                mycroft_update_available (tag.replace ("release/", ""), body, download_url);
            } catch (Error e) {
                warning ("Failed to connect to service: %s", e.message);
                mycroft_update_failed ();
                return 1;
            }
            return 0;
        }
    }
}
