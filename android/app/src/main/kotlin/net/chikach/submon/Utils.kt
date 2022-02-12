package net.chikach.submon

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.icu.text.SimpleDateFormat
import android.text.format.DateFormat
import android.util.Log
import androidx.core.app.AlarmManagerCompat
import io.flutter.embedding.android.FlutterActivity
import java.util.*
import kotlin.math.floor
import kotlin.math.round

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

    fun getDateDiff(dateString: String, context: Context): Long {
        val date = SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.JAPAN).parse(dateString)!!
        return date.time - System.currentTimeMillis()
    }

    fun getDateDiffString(dateString: String, context: Context): String {
        val diff = getDateDiff(dateString, context)
        val diffHours = diff / (60L * 60 * 1000) % 24
        val diffDays = diff / (24L * 60 * 60 * 1000)
        val diffWeeks = diff / (7L * 24 * 60 * 60 * 1000)
        val diffMonths = diff / (30L * 24 * 60 * 60 * 1000)
        return when {
            diffMonths > 0 -> "${diffMonths}ヶ月"
            diffWeeks > 0 -> "${diffWeeks}週間"
            diffDays > 0 -> "${diffDays}日"
            else -> "${diffHours}時間"
        }
    }

    fun getDateDiffColor(dateDiff: Long): Int {
        return when {
            dateDiff < 0 -> Color.parseColor("#F44336")
            dateDiff < 2 * 24 * 60 * 60 * 1000 -> Color.parseColor("#FF9800")
            else -> Color.parseColor("#4CAF50")
        }
    }
}