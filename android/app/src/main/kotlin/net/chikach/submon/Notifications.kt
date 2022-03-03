package net.chikach.submon

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.icu.text.SimpleDateFormat
import androidx.core.app.AlarmManagerCompat
import androidx.room.Room
import io.flutter.embedding.android.FlutterActivity
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.*

object Notifications {
    private const val REMINDER_REQUEST_CODE = 3304

    private const val SHARED_PREFERENCES_NAME = "FlutterSharedPreferences"
    private const val PREFERENCE_REMINDER_TIME_HOUR = "flutter.REMINDER_TIME_HOUR"
    private const val PREFERENCE_REMINDER_TIME_MINUTE = "flutter.REMINDER_TIME_MINUTE"

    fun registerReminderNotification(
        context: Context,
        reRegister: Boolean = false
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            val pref = context.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
            val notificationHour = if (pref.contains(PREFERENCE_REMINDER_TIME_HOUR)) {
                pref.getLong(PREFERENCE_REMINDER_TIME_HOUR, 0)
            } else null
            val notificationMinute = if (pref.contains(PREFERENCE_REMINDER_TIME_MINUTE)) {
                pref.getLong(PREFERENCE_REMINDER_TIME_MINUTE, 0)
            } else null

            if (notificationHour != null && notificationMinute != null) {
                val db = Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "main.db"
                ).build()
                val submissions = db.submissionDao().getAllUndone()

                val notificationTime = Calendar.getInstance().apply {
                    set(Calendar.HOUR_OF_DAY, notificationHour.toInt())
                    set(Calendar.MINUTE, notificationMinute.toInt())
                    set(Calendar.SECOND, 0)
                    set(Calendar.MILLISECOND, 0)

                    if (timeInMillis < System.currentTimeMillis()) {
                        add(Calendar.DATE, 1)
                    }
                }

                val dateFormat = SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.JAPAN)
                val nearSubmissions = submissions.filter {
                    val deadline = Calendar.getInstance()
                    deadline.time = dateFormat.parse(it.date)
                    val diff = deadline.timeInMillis - notificationTime.timeInMillis
                    diff > 0 && diff < 1000 * 60 * 60 * 24 * 2
                }

                // TODO: テキストのカスタム
                // TODO: 期限が近いとして扱う日数のカスタム

                val title = if (nearSubmissions.isEmpty()) {
                    "リマインダー通知"
                } else {
                    "期限が近い提出物があります！"
                }

                val body = if (nearSubmissions.isEmpty()) {
                    "提出物リストを見るのを忘れていませんか？未完了の提出物をチェックしましょう！"
                } else {
                    "${nearSubmissions.joinToString(separator = ", ") { it.title }} の期限は2日を切っています"
                }

                val alarmManager =
                    context.getSystemService(FlutterActivity.ALARM_SERVICE) as AlarmManager
                val intent = Intent(context, ReminderNotificationBroadcastReceiver::class.java)
                    .putExtra(ReminderNotificationBroadcastReceiver.EXTRA_NOTIFICATION_TITLE, title)
                    .putExtra(ReminderNotificationBroadcastReceiver.EXTRA_NOTIFICATION_BODY, body)

                AlarmManagerCompat.setExactAndAllowWhileIdle(
                    alarmManager, AlarmManager.RTC_WAKEUP, notificationTime.timeInMillis,
                    PendingIntent.getBroadcast(
                        context, REMINDER_REQUEST_CODE,
                        intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                )
            }

        }


//        val am = context.getSystemService(FlutterActivity.ALARM_SERVICE) as AlarmManager
//        val intent = Intent(context, ReminderNotificationBroadcastReceiver::class.java)
//            .putExtra(ReminderNotificationBroadcastReceiver.EXTRA_NOTIFICATION_TITLE, title)
//            .putExtra(ReminderNotificationBroadcastReceiver.EXTRA_NOTIFICATION_BODY, body)
//
//        val calendar = Calendar.getInstance().apply {
//            set(Calendar.HOUR_OF_DAY, hour)
//            set(Calendar.MINUTE, minute)
//            set(Calendar.SECOND, 0)
//        }
//        if (calendar.timeInMillis < System.currentTimeMillis() || reRegister) {
//            calendar.add(Calendar.DATE, 1)
//        }
//        val time = calendar.timeInMillis
//
//        intent.putExtra(ReminderNotificationBroadcastReceiver.EXTRA_REPEAT_HOUR, hour)
//            .putExtra(ReminderNotificationBroadcastReceiver.EXTRA_REPEAT_MINUTE, minute)
//
//        AlarmManagerCompat.setExactAndAllowWhileIdle(
//            am, AlarmManager.RTC_WAKEUP, time,
//            PendingIntent.getBroadcast(
//                context, REMINDER_REQUEST_CODE,
//                intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
//            )
//        )
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