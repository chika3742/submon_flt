package net.chikach.submon.mch

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.chikach.submon.METHOD_CHANNEL_ACTION

class ActionMethodChannelHandler : MethodChannel.MethodCallHandler {
    var pendingAction: Map<String, Any?>? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPendingAction" -> {
                result.success(pendingAction)
                pendingAction = null
            }
            else -> result.notImplemented()
        }
    }

    fun invokeIntentAction(flutterEngine: FlutterEngine?) {
        if (flutterEngine != null && pendingAction != null) {
            val mc =
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_ACTION)
            mc.invokeMethod(pendingAction!!["actionName"] as String, pendingAction!!["arguments"])
            pendingAction = null
        }
    }
}