package net.chikach.submon

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.Color
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import java.util.*

class ReminderNotificationBroadcastReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra("NOTIFICATION_TITLE")!!
        val content = intent.getStringExtra("NOTIFICATION_TEXT")!!
        val notif = NotificationCompat.Builder(context, REMINDER_CHANNEL)
            .setContentTitle(title)
            .setContentIntent(
                PendingIntent.getActivity(
                    context,
                    UUID.randomUUID().hashCode(),
                    Intent(context, MainActivity::class.java),
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
            )
            .setStyle(NotificationCompat.BigTextStyle().bigText(content))
            .setContentText(content)
            .setAutoCancel(true)
            .addAction(
                NotificationCompat.Action(
                    null, "新規作成",
                    PendingIntent.getActivity(
                        context, UUID.randomUUID().hashCode(),
                        Intent(
                            context,
                            MainActivity::class.java
                        ).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            .putExtra(
                                MainActivity.EXTRA_FLUTTER_ACTION,
                                Action.openCreateNewPage.name
                            ),
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                )
            )
            .setColor(Color.parseColor("#DC6F3D"))
            .setSmallIcon(R.drawable.ic_stat_submon_icon)
            .build()
        val id = if (intent.hasExtra("NOTIFICATION_ID")) intent.getStringExtra("NOTIFICATION_ID")
            .hashCode()
        else UUID.randomUUID().hashCode()
        NotificationManagerCompat.from(context).notify(id, notif)

        Utils.registerReminderNotification(
            context,
            title,
            content,
            intent.getIntExtra("REPEAT_HOUR", 0),
            intent.getIntExtra("REPEAT_MINUTE", 0),
            true
        )
    }

}