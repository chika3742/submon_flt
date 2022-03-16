package net.chikach.submon

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationManagerCompat
import androidx.room.Room
import com.google.firebase.Timestamp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore

class DeleteDoTimeBroadcastReceiver : BroadcastReceiver() {
    companion object {
        const val EXTRA_DO_TIME_ID = "doTimeId"
        const val EXTRA_NOTIFICATION_ID = "notificationId"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val auth = FirebaseAuth.getInstance()
        val db = FirebaseFirestore.getInstance()

        if (auth.currentUser != null) {
            val doTimeId = intent.getIntExtra(EXTRA_DO_TIME_ID, -1)
            db.document("users/${auth.currentUser!!.uid}/doTime/$doTimeId").delete()
            db.document("users/${auth.currentUser!!.uid}").set(
                mapOf(
                    "lastChanged" to Timestamp.now()
                )
            )
            val roomDb = Room.databaseBuilder(
                context.applicationContext,
                AppDatabase::class.java,
                "main.db"
            ).build()
            roomDb.doTimeDao().delete(doTimeId)
        }

        NotificationManagerCompat.from(context)
            .cancel(intent.getIntExtra(EXTRA_NOTIFICATION_ID, -1))
    }
}