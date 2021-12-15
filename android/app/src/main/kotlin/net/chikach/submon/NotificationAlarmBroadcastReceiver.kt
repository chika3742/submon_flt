package net.chikach.submon

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat

class NotificationAlarmBroadcastReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val mgr = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        NotificationCompat.Builder(context, intent.getStringExtra("NOTIFICATION_CHANNEL")!!)
    }
}