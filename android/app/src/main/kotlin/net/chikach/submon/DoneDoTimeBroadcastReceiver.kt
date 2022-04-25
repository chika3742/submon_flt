package net.chikach.submon

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import androidx.room.Room
import com.google.firebase.FirebaseException
import com.google.firebase.Timestamp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.SetOptions
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class DoneDigestiveBroadcastReceiver : BroadcastReceiver() {
    companion object {
        const val EXTRA_DO_TIME_ID = "digestiveId"
        const val EXTRA_NOTIFICATION_ID = "notificationId"
    }

    val coroutineScope = CoroutineScope(Dispatchers.IO)

    override fun onReceive(context: Context, intent: Intent) {
        val auth = FirebaseAuth.getInstance()
        val db = FirebaseFirestore.getInstance()

        if (auth.currentUser != null) {
            try {
                val digestiveId = intent.getIntExtra(EXTRA_DO_TIME_ID, -1)
                db.document("users/${auth.currentUser!!.uid}/digestive/$digestiveId")
                    .update("done", 1)
                db.document("users/${auth.currentUser!!.uid}").set(
                    mapOf(
                        "lastChanged" to Timestamp.now()
                    ),
                    SetOptions.merge()
                )
                coroutineScope.launch {
                    val roomDb = Room.databaseBuilder(
                        context.applicationContext,
                        AppDatabase::class.java,
                        "main.db"
                    ).build()
                    roomDb.digestiveDao().updateDone(digestiveId, 1)
                }
            } catch (e: FirebaseException) {
                Log.e("DoneDigestiveBroadcastReceiver", e.toString(), e)
            }
        }

        NotificationManagerCompat.from(context)
            .cancel(intent.getIntExtra(EXTRA_NOTIFICATION_ID, -1))
    }
}