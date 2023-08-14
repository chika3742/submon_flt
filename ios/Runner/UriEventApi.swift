//
//  UriEventHandler.swift
//  Runner
//
//  Created by Kazuya Chikamatsu on 2022/05/12.
//

import Foundation
import Flutter

class UriEventApi: NSObject {
    static let channelName = "net.chikach.submon.event/uri"
    var channel: FlutterEventChannel
    var eventSink: FlutterEventSink?
    var pendingUri: String?
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterEventChannel(name: UriEventApi.channelName, binaryMessenger: binaryMessenger)
    }
    
    func initHandler() {
        channel.setStreamHandler(self)
    }
    
    func onUri(uri: String) {
        if (eventSink != nil) {
            eventSink!(uri)
        } else {
            pendingUri = uri
        }
    }
}

extension UriEventApi: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        if (pendingUri != nil) {
            eventSink!(pendingUri)
            pendingUri = nil
        }
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
