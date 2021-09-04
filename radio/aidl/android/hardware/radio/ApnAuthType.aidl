/*
 * Copyright (C) 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.hardware.radio;

@VintfStability
@Backing(type="int")
enum ApnAuthType {
    /**
     * PAP and CHAP is never performed.
     */
    NO_PAP_NO_CHAP,
    /**
     * PAP may be performed; CHAP is never performed.
     */
    PAP_NO_CHAP,
    /**
     * CHAP may be performed; PAP is never performed.
     */
    NO_PAP_CHAP,
    /**
     * PAP / CHAP may be performed - baseband dependent.
     */
    PAP_CHAP,
}