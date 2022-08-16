package net.chikach.submon.mch

import android.Manifest
import android.os.Build
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.chikach.submon.MainActivity

const val REQUEST_CODE_NOTIFICATION_PERMISSION = 16

class MessagingMethodChannelHandler(private val activity: MainActivity) : MethodChannel.MethodCallHandler {
    var methodResult: MethodChannel.Result? = null

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
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQUEST_CODE_NOTIFICATION_PERMISSION)
            methodResult = result
        } else {
            result.success(NotificationPermissionState.GRANTED.ordinal)
        }
    }

    fun completeRequestNotificationPermission(granted: Boolean) {
        if (granted) {
            methodResult?.success(NotificationPermissionState.GRANTED.ordinal)
        } else {
            methodResult?.success(NotificationPermissionState.DENIED.ordinal)
        }
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