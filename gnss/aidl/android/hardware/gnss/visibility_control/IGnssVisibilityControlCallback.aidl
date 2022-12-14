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

package android.hardware.gnss.visibility_control;

/**
 * GNSS location reporting permissions and notification callback interface.
 *
 * @hide
 */
@VintfStability
interface IGnssVisibilityControlCallback {
    /**
     * Protocol stack that is requesting the non-framework location information.
     */
    @VintfStability
    @Backing(type="int")
    enum NfwProtocolStack {
        /** Cellular control plane requests */
        CTRL_PLANE = 0,

        /** All types of SUPL requests */
        SUPL = 1,

        /** All types of requests from IMS */
        IMS = 10,

        /** All types of requests from SIM */
        SIM = 11,

        /** Requests from other protocol stacks */
        OTHER_PROTOCOL_STACK = 100
    }

    /**
     * Entity that is requesting/receiving the location information.
     */
    @VintfStability
    @Backing(type="int")
    enum NfwRequestor {
        /** Wireless service provider */
        CARRIER = 0,

        /** Device manufacturer */
        OEM = 10,

        /** Modem chipset vendor */
        MODEM_CHIPSET_VENDOR = 11,

        /** GNSS chipset vendor */
        GNSS_CHIPSET_VENDOR = 12,

        /** Other chipset vendor */
        OTHER_CHIPSET_VENDOR = 13,

        /** Automobile client */
        AUTOMOBILE_CLIENT = 20,

        /** Other sources */
        OTHER_REQUESTOR = 100
    }

    /**
     * GNSS response type for non-framework location requests.
     */
    @VintfStability
    @Backing(type="int")
    enum NfwResponseType {
        /** Request rejected because framework has not given permission for this use case */
        REJECTED = 0,

        /** Request accepted but could not provide location because of a failure */
        ACCEPTED_NO_LOCATION_PROVIDED = 1,

        /** Request accepted and location provided */
        ACCEPTED_LOCATION_PROVIDED = 2,
    }

    /**
     * Represents a non-framework location information request/response notification.
     */
    @VintfStability
    parcelable NfwNotification {
        /**
         * Package name of the Android proxy application representing the non-framework
         * entity that requested location. Set to empty string if unknown.
         *
         * For user-initiated emergency use cases, this field must be set to empty string
         * and the inEmergencyMode field must be set to true.
         */
        String proxyAppPackageName;

        /** Protocol stack that initiated the non-framework location request. */
        NfwProtocolStack protocolStack;

        /**
         * Name of the protocol stack if protocolStack field is set to OTHER_PROTOCOL_STACK.
         * Otherwise, set to empty string.
         *
         * This field is opaque to the framework and used for logging purposes.
         */
        String otherProtocolStackName;

        /** Source initiating/receiving the location information. */
        NfwRequestor requestor;

        /**
         * Identity of the endpoint receiving the location information. For example, carrier
         * name, OEM name, SUPL SLP/E-SLP FQDN, chipset vendor name, etc.
         *
         * This field is opaque to the framework and used for logging purposes.
         */
        String requestorId;

        /** Indicates whether location information was provided for this request. */
        NfwResponseType responseType;

        /** Is the device in user initiated emergency session. */
        boolean inEmergencyMode;

        /** Is cached location provided */
        boolean isCachedLocation;
    }

    /**
     * Callback to report a non-framework delivered location.
     *
     * The GNSS HAL implementation must call this method to notify the framework whenever
     * a non-framework location request is made to the GNSS HAL.
     *
     * Non-framework entities like low power sensor hubs that request location from GNSS and
     * only pass location information through Android framework controls are exempt from this
     * power-spending reporting. However, low power sensor hubs or other chipsets which may send
     * the location information to anywhere other than Android framework (which provides user
     * visibility and control), must report location information use through this API whenever
     * location information (or events driven by that location such as "home" location detection)
     * leaves the domain of that low power chipset.
     *
     * To avoid overly spamming the framework, high speed location reporting of the exact same
     * type may be throttled to report location at a lower rate than the actual report rate, as
     * long as the location is reported with a latency of no more than the larger of 5 seconds,
     * or the next the Android processor awake time. For example, if an Automotive client is
     * getting location information from the GNSS location system at 20Hz, this method may be
     * called at 1Hz. As another example, if a low power processor is getting location from the
     * GNSS chipset, and the Android processor is asleep, the notification to the Android HAL may
     * be delayed until the next wake of the Android processor.
     *
     * @param notification Non-framework delivered location request/response description.
     */
    void nfwNotifyCb(in NfwNotification notification);

    /**
     * Tells if the device is currently in an emergency session.
     *
     * Emergency session is defined as the device being actively in a user initiated emergency
     * call or in post emergency call extension time period.
     *
     * If the GNSS HAL implementation cannot determine if the device is in emergency session
     * mode, it must call this method to confirm that the device is in emergency session before
     * serving network initiated emergency SUPL and Control Plane location requests.
     *
     * @return success True if the framework determines that the device is in emergency session.
     */
    boolean isInEmergencySession();
}
