package net.chikach.submon

import android.app.PendingIntent
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.SetOptions
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.util.*

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        val data = message.data

        val notificationManager = NotificationManagerCompat.from(this)

        val channelId = data["notificationChannelId"] ?: "default"
        val notificationId = UUID.randomUUID().hashCode()
        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle(data["title"])
            .setContentText(data["body"])
            .setStyle(NotificationCompat.BigTextStyle().bigText(data["body"]))
            .setSmallIcon(R.drawable.ic_stat_submon_icon)
            .setColor(resources.getColor(R.color.ic_launcher_background, theme))
            .also {
                when (channelId) {
                    REMINDER_CHANNEL -> {
                        it.setContentIntent(
                            createActivityPendingIntentForUri("")
                        )
                        it.addAction(
                            NotificationCompat.Action(
                                null, "新規作成",
                                createActivityPendingIntentForUri("/create-submission")
                            )
                        )
                    }
                    TIMETABLE_CHANNEL -> {
                        it.setAutoCancel(true)
                        createActivityPendingIntentForUri("/tab/timetable")
                    }
                    DO_TIME_CHANNEL -> {
                        it.setContentIntent(
                            createActivityPendingIntentForUri("/submission?id=${data["submissionId"]}")
                        )
                        it.addAction(
                            NotificationCompat.Action(
                                null, "集中タイマー",
                                createActivityPendingIntentForUri("/focus-timer?digestiveId=${data["digestiveId"]}")
                            )
                        )
                        it.addAction(
                            NotificationCompat.Action(
                                null, "完了",
                                createBroadcastPendingIntent(
                                    Intent(this, DoneDigestiveBroadcastReceiver::class.java)
                                        .putExtra(
                                            DoneDigestiveBroadcastReceiver.EXTRA_DO_TIME_ID,
                                            data["digestiveId"]?.toInt()
                                        )
                                        .putExtra(
                                            DoneDigestiveBroadcastReceiver.EXTRA_NOTIFICATION_ID,
                                            notificationId
                                        )
                                )
                            )
                        )
                    }
                }
            }
            .build()

        notificationManager.notify(notificationId, notification)
    }

    private fun createActivityPendingIntentForUri(afterPath: String): PendingIntent {
        return PendingIntent.getActivity(
            this, UUID.randomUUID().hashCode(),
            Intent.parseUri(
                "android-app://${packageName}/submon/${afterPath}",
                Intent.URI_ANDROID_APP_SCHEME
            )
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    }

    private fun createBroadcastPendingIntent(intent: Intent): PendingIntent {
        return PendingIntent.getBroadcast(
            this, UUID.randomUUID().hashCode(), intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        val user = FirebaseAuth.getInstance().currentUser
        if (user != null) {
            val db = FirebaseFirestore.getInstance()
            val doc = db.document("users/${user.uid}")

            doc.set(mapOf("notificationTokens" to FieldValue.arrayUnion(token)), SetOptions.merge())
        }
    }
}