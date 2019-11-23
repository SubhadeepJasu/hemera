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

    public struct HotWord {
        string name;
        string module;
        string phonemes;
        double threshold;
        string lang;
        string local_model_file;
        float  sensitivity;
        int    trigger_level; 
    }
    public struct STT_Module {
        string name;
        string uri;
        string credentials0_token;
    }

    public struct TTS_Module {
        string name;
        string voice;
        string lang;
        string url;
        string preloaded_cache;
    }

    public struct AudioBackend {
        string name;
        string type;
        bool   active;
        bool   duck;
    }

    public class MycroftSettingsModel {
        public string   lang { get; set; }

        public string   system_unit { get; set; }

        public string   time_format { get; set; }
        public string   date_format { get; set; }

        public bool     opt_in { get; set; }

        public bool     confirm_listening { get; set; }

        public string   sounds0_start_listening { get; set; }
        public string   sounds0_end_listening { get; set; }
        public string   sounds0_acknowledge { get; set; }

        public string   play_wav_cmdline { get; set; }
        public string   play_mp3_cmdline { get; set; }
        public string   play_ogg_cmdline { get; set; }

        public string   location0_city0_code { get; set; }
        public string   location0_city0_name { get; set; }
        public string   location0_city0_state0_code { get; set; }
        public string   location0_city0_state0_name { get; set; }
        public string   location0_city0_state0_country0_code { get; set; }
        public string   location0_city0_state0_country0_name { get; set; }
        public float    location0_coordinate0_latitude { get; set; }
        public float    location0_coordinate0_longitude { get; set; }
        public string   location0_timezone0_code { get; set; }
        public string   location0_timezone0_name { get; set; }
        public float    location0_timezone0_dstOffset { get; set; }
        public float    location0_timezone0_offset { get; set; }

        public string   data_dir { get; set; }

        public string   skills0_msm0_directory { get; set; }
        public string   skills0_msm0_versioned { get; set; }
        public string   skills0_msm0_repo0_cache { get; set; }
        public string   skills0_msm0_repo0_url { get; set; }
        public string   skills0_msm0_repo0_branch { get; set; }
        public bool     skills0_upload_skill_manifest { get; set; }
        public string   skills0_directory { get; set; }
        public bool     skills0_auto_update { get; set; }
        public string   skills0_blacklisted_skills [] { get; set; }
        public string   skills0_priority_skills [] { get; set; }
        public float    skills0_update_interval { get; set; }

        public string   websocket0_host { get; set; }
        public string   websocket0_port { get; set; }
        public string   websocket0_route { get; set; }
        public bool     websocket0_ssl  { get; set; }

        public string   gui_websocket0_host { get; set; }
        public string   gui_websocket0_base_port { get; set; }
        public string   gui_websocket0_route { get; set; }
        public bool     gui_websocket0_ssl  { get; set; }

        public int      listener0_sample_rate { get; set; }
        public bool     listener0_record_wake_words { get; set; }
        public bool     listener0_save_utterances { get; set; }
        public bool     listener0_wake_word_upload0_disable { get; set; }
        public bool     listener0_wake_word_upload0_url { get; set; }
        public string   listener0_device_name { get; set; }
        public int      listener0_device_index { get; set; }
        public bool     listener0_mute_during_output { get; set; }
        public float    listener0_duck_while_listening { get; set; }
        public int      listener0_phoneme_duration { get; set; }
        public float    listener0_energy_ratio { get; set; }
        public string   listener0_wake_word { get; set; }
        public string   listener0_stand_up_word { get; set; }
        public string   listener0_precise0_dist_url { get; set; }
        public string   listener0_precise0_model_url { get; set; }
        public HotWord  listener0_hotwords0 [] { get; set; }

        public string   enclosure0_platform { get; set; }
        public bool     enclosure0_platform_enclosure_path { get; set; }
        public string   enclosure0_port { get; set; }
        public string   enclosure0_rate { get; set; }
        public string   enclosure0_timeout { get; set; }
        public bool     enclosure0_update { get; set; }
        public bool     enclosure0_test { get; set; }

        public string   log_level { get; set; }

        public string   ignore_logs[] { get; set; }
        
        public string   session0_ttl { get; set; }

        public string   sst0_module { get; set; }
        public STT_Module stt0 [] { get; set; }

        public bool     tts0_pulse_duck { get; set; }
        public string   tts0_module { get; set; }
        public TTS_Module tts0 [] { get; set; }

        public string   pedatious0_intent_cache { get; set; }
        public string   pedatious0_train_delay { get; set; }

        public AudioBackend audio0_backends [] { get; set; }
        public string   default_backend { get; set; }

        public bool     debug { get; set; }
    }
}