package net.chikach.submon.api

import android.Manifest
import android.app.Activity
import android.os.Build
import com.google.firebase.messaging.FirebaseMessaging
import net.chikach.submon.Messages.*

const val REQUEST_CODE_NOTIFICATION_PERMISSION = 16

class FirebaseMessagingAndroidApi(private val activity: Activity) : FirebaseMessagingApi {
    private var requestNotificationPermissionResult: Result<Boolean>? = null

    override fun getToken(result: Result<String>) {
        FirebaseMessaging.getInstance().token.addOnSuccessListener {
            result.success(it)
        }.addOnFailureListener {
            result.error(it)
        }
    }

    override fun requestNotificationPermission(result: Result<Boolean>) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.requestPermissions(
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                REQUEST_CODE_NOTIFICATION_PERMISSION
            )
            requestNotificationPermissionResult = result
        } else {
            result.success(true)
        }
    }

    fun completeRequestNotificationPermissionWithResult(result: Boolean) {
        requestNotificationPermissionResult?.success(result)
    }
}