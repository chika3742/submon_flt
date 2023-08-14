//
//  FcmTokenRefreshUri.swift
//  Runner
//
//  Created by Kazuya Chikamatsu on 2023/08/14.
//
import Flutter

class FcmTokenRefreshEventApi: NSObject {
    let channelName = "net.chikach.submon.event/fcm_token_refresh"
    var channel: FlutterEventChannel
    var eventSink: FlutterEventSink?
    var pendingFcmToken: String?
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterEventChannel(name: channelName, binaryMessenger: binaryMessenger)
    }
    
    func initHandler() {
        channel.setStreamHandler(self)
    }
    
    func onFcmTokenRefresh(token: String) {
        if (eventSink != nil) {
            eventSink!(token)
        } else {
            pendingFcmToken = token
        }
    }
}

extension FcmTokenRefreshEventApi: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        if (pendingFcmToken != nil) {
            eventSink!(pendingFcmToken)
            pendingFcmToken = nil
        }
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
