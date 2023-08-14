package net.chikach.submon.eventapi

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class UriEventApi(binaryMessenger: BinaryMessenger) : EventChannel.StreamHandler {
    private val channel = EventChannel(binaryMessenger, CHANNEL_NAME)

    companion object {
        const val CHANNEL_NAME = "net.chikach.submon.event/uri"
    }

    private var eventSink: EventChannel.EventSink? = null
    private var pendingData: String? = null

    fun initHandler() {
        channel.setStreamHandler(this)
    }

    fun onUri(uri: String) {
        if (eventSink == null) {
            pendingData = uri
        } else {
            eventSink!!.success(uri)
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