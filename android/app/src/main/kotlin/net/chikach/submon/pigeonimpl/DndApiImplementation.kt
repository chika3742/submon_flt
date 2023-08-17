package net.chikach.submon.pigeonimpl

import DndApi
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.provider.Settings

class DndApiImplementation(private val context: Context) : DndApi {
    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    override fun isAccessGranted(): Boolean {
        return notificationManager.isNotificationPolicyAccessGranted
    }

    override fun goToPolicySettings() {
        context.startActivity(Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS))
    }

    override fun setDndEnabled(enabled: Boolean) {
        if (enabled) {
            notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_NONE)
        } else {
            notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
        }
    }
}