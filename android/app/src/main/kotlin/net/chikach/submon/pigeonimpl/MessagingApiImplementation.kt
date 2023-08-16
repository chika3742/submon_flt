package net.chikach.submon.pigeonimpl

import MessagingApi
import NotificationPermissionState
import NotificationPermissionStateWrapper
import android.Manifest
import android.app.Activity
import android.os.Build
import com.google.firebase.messaging.FirebaseMessaging

class MessagingApiImplementation(private val activity: Activity) : MessagingApi {
    companion object {
        const val REQUEST_CODE_NOTIFICATION_PERMISSION = 20
    }

    private var requestNotificationCallback: ((Result<NotificationPermissionStateWrapper?>) -> Unit)? = null

    override fun getToken(callback: (Result<String>) -> Unit) {
        FirebaseMessaging.getInstance().token.addOnSuccessListener {
            callback(Result.success(it))
        }.addOnFailureListener {
            callback(Result.failure(it))
        }
    }

    override fun requestNotificationPermission(callback: (Result<NotificationPermissionStateWrapper?>) -> Unit) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.requestPermissions(
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                REQUEST_CODE_NOTIFICATION_PERMISSION
            )
            requestNotificationCallback = callback
        } else {
            callback(Result.success(NotificationPermissionStateWrapper(NotificationPermissionState.GRANTED)))
        }
    }

    fun completeRequestNotificationPermission(granted: Boolean) {
        requestNotificationCallback?.invoke(
            Result.success(
                NotificationPermissionStateWrapper(
                    if (granted) NotificationPermissionState.GRANTED else NotificationPermissionState.DENIED
                )
            )
        )
    }
}