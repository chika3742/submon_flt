package net.chikach.submon.eventapi

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class FcmTokenRefreshEventApi(binaryMessenger: BinaryMessenger) : EventChannel.StreamHandler {
    private val channel = EventChannel(binaryMessenger, CHANNEL_NAME)

    companion object {
        const val CHANNEL_NAME = "net.chikach.submon.event/fcm_token_refresh"
    }

    private var eventSink: EventChannel.EventSink? = null
    private var pendingData: String? = null

    fun initHandler() {
        channel.setStreamHandler(this)
    }

    fun onFcmTokenRefresh(token: String) {
        if (eventSink == null) {
            pendingData = token
        } else {
            eventSink!!.success(token)
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        if (pendingData != null) {
            eventSink!!.success(pendingData)
            pendingData = null
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}