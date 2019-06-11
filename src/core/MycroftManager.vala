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

    /**
     * The {@code MycroftManager} class is responsible for managing Mycroft:
     * - Starting
     * - Stopping
     * - Installing
     *
     * @since 1.0.0
     */
    public class MycroftManager {
        public signal void mycroft_launch_failed ();
        public signal void mycroft_launched ();
        public signal void mycroft_launch_error ();
        public signal void mycroft_update_available (string tag, string body, string download_url);
        public signal void mycroft_update_failed ();
        public signal void mycroft_finish_download ();
        public signal void mycroft_downloading (double progress);
        public signal void mycroft_extracting (double progress);
        public signal void mycroft_finished_extraction (string path);
        public signal void mycroft_installing ();
        public signal void mycroft_finished_installation ();

        public string mycroft_install_location = "~/mycroft-core";
        private string user_home_directory = "~/";

        /**
         * Constructs a new {@code MycroftManager} object
         */
        public MycroftManager () {
            user_home_directory = GLib.Environment.get_home_dir ();
            mycroft_install_location = user_home_directory.concat ("/mycroft-core");
        }

        /**
         * Start Mycroft asynchronously
         * @return {@code bool}.
         */
        public bool start_mycroft () {
            string mc_stdout = "", ms_stderr = "";
            int mc_status = 0;
            bool b_status = true;

            // Launch as a subroutine
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

                // Lazily verify that Mycroft as indeed started the websocket
                if (mc_stdout.contains ("Starting background service enclosure")) {
                    mycroft_launched ();
                } else {
                    mycroft_launch_failed ();
                }
                return false;
            });
            return b_status;
        }

        /**
         * Stop Mycroft asynchronously
         * @return {@code void}.
         */
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

        /**
         * Download the given version of Mycroft
         * @return {@code bool}.
         */
        public bool download_mycroft (string uri_endpoint) {
            MainLoop loop = new MainLoop ();
            var file_path = File.new_for_path ("/tmp/.mycroft-core.tar.gz");
            var file_from_uri = File.new_for_uri (uri_endpoint);
            var progress = 0.0;

            // Don't redownload if the same file exist
            if (!file_path.query_exists ()) {
                print ("Downloading...");
                file_from_uri.copy_async.begin (file_path, 
                    FileCopyFlags.OVERWRITE | FileCopyFlags.ALL_METADATA, GLib.Priority.DEFAULT, 
                    null, (current_num_bytes, total_num_bytes) => {
                        // Report copy-status:
                        total_num_bytes = total_num_bytes == 0 ? Hemera.Configs.Constants.MYCROFT_TAR_SIZE : total_num_bytes;
                        print ("%" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n", current_num_bytes, total_num_bytes);
                        progress = (double)(current_num_bytes) / (double)total_num_bytes;
                        mycroft_downloading (progress);
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

        /**
         * Extract the Mycroft tar package
         * @return {@code bool}.
         */
        public void extract_mycroft (string filename) {
            // Select which attributes we want to restore.
            warning ("Extracting...");

            // Wait for the file to close, not a proper way, but it works
            Posix.sleep (2);
            Archive.ExtractFlags flags;
            flags = Archive.ExtractFlags.TIME;
            flags |= Archive.ExtractFlags.PERM;
            flags |= Archive.ExtractFlags.ACL;
            flags |= Archive.ExtractFlags.FFLAGS;

            Archive.Read archive = new Archive.Read ();
            archive.support_format_all ();
            archive.support_compression_all ();

            Archive.WriteDisk extractor = new Archive.WriteDisk ();
            extractor.set_options (flags);
            extractor.set_standard_lookup ();

            if (archive.open_filename (filename, 10240) != Archive.Result.OK) {
                critical ("Error opening %s: %s (%d)", filename, archive.error_string (), archive.errno ());
                return;
            }
            size_t cummulative_size = 0;
            unowned Archive.Entry entry;
            Archive.Result last_result;
            string destination_path = user_home_directory.concat ("/.local/share/hemera_mycroft");
            while ((last_result = archive.next_header (out entry)) == Archive.Result.OK) {

                // Modify the entry path to the destination path
                entry.set_pathname(destination_path.concat("/", entry.pathname ()));
                if (extractor.write_header (entry) != Archive.Result.OK) {
                    continue;
                }
                void* buffer = null;
                size_t buffer_length;
                Posix.off_t offset;
                while (archive.read_data_block (out buffer, out buffer_length, out offset) == Archive.Result.OK) {
                    if (extractor.write_data_block (buffer, buffer_length, offset) != Archive.Result.OK) {
                        break;
                    }

                    // Slow down extraction to prevent segmentation fault
                    Thread.usleep (1000);
                    print (buffer_length.to_string ().concat ("\n"));
                    cummulative_size += buffer_length;
                    double progress = (double)(cummulative_size)/15642892;
                    mycroft_extracting (progress);
                }
            }
            Posix.sleep (1);
            if (last_result != Archive.Result.EOF) {
                critical ("Error: %s (%d)", archive.error_string (), archive.errno ());
            }
            warning ("Extraction Complete");

            // Queue the verify routine
            verify_mycroft_extract ();
        }

        /**
         * Verify that the extract went well and set the mycroft path property
         * @return {@code void}.
         */
        public void verify_mycroft_extract () {
            string mycroft_new_path = "";
            try {
		        string directory = user_home_directory.concat ("/.local/share/hemera_mycroft");
		        Dir dir = Dir.open (directory, 0);
		        string? name = null;

		        while ((name = dir.read_name ()) != null) {
			        string path = Path.build_filename (directory, name);
			        string type = "";

			        if (FileUtils.test (path, FileTest.IS_REGULAR)) {
				        type += "| REGULAR ";
			        }

			        if (FileUtils.test (path, FileTest.IS_SYMLINK)) {
				        type += "| SYMLINK ";
			        }

			        if (FileUtils.test (path, FileTest.IS_DIR)) {
				        type += "| DIR ";
			        }

			        if (FileUtils.test (path, FileTest.IS_EXECUTABLE)) {
				        type += "| EXECUTABLE ";
			        }

			        print ("%s\t%s\n", name, type);
			        mycroft_new_path = user_home_directory.concat ("/.local/share/hemera_mycroft/", name, "/");
			        warning (mycroft_new_path);
			        install_mycroft (mycroft_new_path);
		        }
	        } catch (FileError err) {
		        stderr.printf (err.message);
	        }
        }

        /**
         * Run Mycroft Installation script
         * @return {@code void}.
         */
        public async void install_mycroft (string filepath) {
            mycroft_installing ();
            try {
                string[] command = get_command ();
                Posix.chdir (filepath);

                // Initialize git to this new directory
                Process.spawn_command_line_async ("git init");
                string? input = "nnnnn";
                var subprocess = new Subprocess.newv (command, SubprocessFlags.STDIN_PIPE);
                yield subprocess.communicate_utf8_async (input, null, null, null);

                if (yield subprocess.wait_check_async ()) {
                    stdout.printf ("Installation Done\n");
                    mycroft_finished_installation ();
                }
            } catch (Error e) {
                warning ("Error: '%s'", e.message);
            }
        }

        /**
         * Get Installation script commandline
         * @return {@code string[]}.
         */
        private string[] get_command () {
            /* TODO: Find a new way to run this script that doesn't cause multiple
             *       bash processes to continue running after the main script has
             *       exited and hog CPU
             */
            string command = "bash dev_setup.sh";

            string[]? argv = null;
            try {
                Shell.parse_argv (command, out argv);
            } catch (Error e) {
                warning ("Error: '%s'", e.message);
            }
            return argv;
        }

        /**
         * Get the latest version number of Mycroft and the download url
         * Uses threads
         * @see GLib.Thread
         * @return {@code bool}.
         */
        public bool check_updates () {
            if (!Thread.supported ()) {
                warning ("Thread support missing. Please wait for web API access...\n");
                fetch_updates ();
                return true;
            }
            else {
                try {
                /* TODO: Remove the useless thread reference
                 */
                    Thread<int> thread_u = new Thread<int>.try ("thread_u", fetch_updates);
                } catch (Error e) {
                    warning ("%s\n", e.message);
                    // Thread error, to bad. Update Mycroft manually.
                    mycroft_update_failed ();
                    return false;
                }
            }
            return true;
        }
        /**
         * Threaded Mycroft update subroutine
         * @return {@code int}.
         */
        int fetch_updates () {
            var uri = "https://api.github.com/repos/MycroftAI/mycroft-core/releases/latest";
            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);
            session.user_agent = "com.github.SubhadeepJasu.hemera";
            if(session.send_message (message) != 200) {

                // Failed to fetch updates
                mycroft_update_failed ();
                return 1;
            }
            try {

                // Parse JSON to get the latest update version and url
                var parser = new Json.Parser ();
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);
                var root_object = parser.get_root ().get_object();
                var tag = root_object.get_string_member ("tag_name");
                var download_url = root_object.get_string_member ("tarball_url");
                var body = root_object.get_string_member ("body");
                mycroft_update_available (tag.replace ("release/", ""), body, download_url);
            } catch (Error e) {

                // JSON data is corrupted
                warning ("Failed to connect to service: %s", e.message);
                mycroft_update_failed ();
                return 1;
            }
            return 0;
        }
    }
}
