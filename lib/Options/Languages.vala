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
    public class Languages {
        public const string[] lang_code = {
            "en-us",
            "de-de",
            "fr-fr",
            "hu-hu",
            "it-it",
            "pt-pt",
            "sv-fi",
            "da-dk",
            "nl-nl",
            "es-es"
        };

        public const string[] names = {
            "English (US)",
            "German",
            "French",
            "Hungarian",
            "Italian",
            "Portuguese",
            "Swedish",
            "Danish",
            "Dutch",
            "Spanish"
        };

        public static string get_name_from_language_code (string language_code) {
            int i = 0;
            for (; i < lang_code.length; i++) {
                if (language_code == lang_code[i]) {
                    return names[i];
                }
            }
            return "";
        }

        public static int get_language_code_index (string language_code) {
            int i = 0;
            for (; i < lang_code.length; i++) {
                if (language_code == lang_code[i]) {
                    return i;
                }
            }
            return -1;
        }

        public static int length () {
            return lang_code.length;
        }
    }
}