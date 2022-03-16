package net.chikach.submon.mch

import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MessagingMethodChannelHandler : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "requestNotificationPermission" -> {
                requestNotificationPermission(result)
            }
            "getToken" -> {
                FirebaseMessaging.getInstance().token.addOnSuccessListener {
                    result.success(it)
                }.addOnFailureListener {
                    result.error("unknown", it.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        result.success(NotificationPermissionState.GRANTED.ordinal)
    }

    enum class NotificationPermissionState {
        GRANTED,
        DENIED,
    }
}