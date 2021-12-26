package net.chikach.submon

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.AlarmManagerCompat
import io.flutter.embedding.android.FlutterActivity
import java.util.*

object Utils {
    private const val REMINDER_REQUEST_CODE = 3304

    fun registerReminderNotification(
        context: Context,
        title: String,
        body: String,
        hour: Int,
        minute: Int,
        reRegister: Boolean = false
    ) {
        val am = context.getSystemService(FlutterActivity.ALARM_SERVICE) as AlarmManager
        val time: Long
        val intent = Intent(context, ReminderNotificationBroadcastReceiver::class.java)
            .putExtra("NOTIFICATION_TITLE", title)
            .putExtra("NOTIFICATION_TEXT", body)

        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
        }
        if (calendar.timeInMillis < System.currentTimeMillis() || reRegister) calendar.add(
            Calendar.DATE,
            1
        )
        time = calendar.timeInMillis

        intent.putExtra("REPEAT_HOUR", hour)
            .putExtra("REPEAT_MINUTE", minute)

//        context.sendBroadcast(intent)

        AlarmManagerCompat.setExactAndAllowWhileIdle(
            am, AlarmManager.RTC_WAKEUP, time,
            PendingIntent.getBroadcast(
                context, REMINDER_REQUEST_CODE,
                intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        )
    }

    fun cancelReminderNotification(context: Context) {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ReminderNotificationBroadcastReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            REMINDER_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        am.cancel(pendingIntent)
    }
}