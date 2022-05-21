//
//  UriEventHandler.swift
//  Runner
//
//  Created by 近松 和矢 on 2022/05/12.
//

import Foundation
import Flutter

class UriEventChannelHandler: NSObject {
    let channelName = "net.chikach.submon/uri"
    var channel: FlutterEventChannel
    var eventSink: FlutterEventSink?
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterEventChannel(name: channelName, binaryMessenger: binaryMessenger)
        super.init()
        channel.setStreamHandler(self)
    }
}

extension UriEventChannelHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
