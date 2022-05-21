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
                getToken(result)
            }
            else -> result.notImplemented()
        }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        result.success(NotificationPermissionState.GRANTED.ordinal)
    }

    private fun getToken(result: MethodChannel.Result) {
        FirebaseMessaging.getInstance().token.addOnSuccessListener {
            result.success(it)
        }.addOnFailureListener {
            result.error("unknown", it.message, null)
        }
    }

    enum class NotificationPermissionState {
        GRANTED,
        DENIED,
    }
}