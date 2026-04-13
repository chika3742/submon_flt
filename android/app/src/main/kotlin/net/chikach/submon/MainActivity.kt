package net.chikach.submon

import DndApi
import android.app.NotificationManager
import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationChannelGroupCompat
import androidx.core.app.NotificationManagerCompat
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import net.chikach.submon.eventapi.UriEventApi
import net.chikach.submon.pigeonimpl.DndApiImplementation

const val REMINDER_CHANNEL = "reminder"
const val TIMETABLE_CHANNEL = "timetable"
const val DO_TIME_CHANNEL = "digestive"
const val DEFAULT_CHANNEL = "default"

class MainActivity : FlutterActivity() {
    var uriEventApi: UriEventApi? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Utils.initAppCheck()

        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        uriEventApi = UriEventApi(binaryMessenger)
        uriEventApi!!.initHandler()

        if (intent.data != null) {
            uriEventApi!!.onUri(intent.data.toString())
        }

        DndApi.setUp(binaryMessenger, DndApiImplementation(this))

        val notificationMgr = NotificationManagerCompat.from(context)
        notificationMgr.createNotificationChannelGroup(
            NotificationChannelGroupCompat.Builder("main")
                .setName("メイン")
                .build()
        )
        notificationMgr.createNotificationChannel(
            NotificationChannelCompat.Builder(REMINDER_CHANNEL, NotificationManager.IMPORTANCE_HIGH)
                .setName("リマインダー通知")
                .setGroup("main")
                .build()
        )
        notificationMgr.createNotificationChannel(
            NotificationChannelCompat.Builder(
                TIMETABLE_CHANNEL,
                NotificationManager.IMPORTANCE_DEFAULT
            )
                .setName("時間割通知")
                .setGroup("main")
                .build()
        )
        notificationMgr.createNotificationChannel(
            NotificationChannelCompat.Builder(
                DO_TIME_CHANNEL,
                NotificationManager.IMPORTANCE_DEFAULT
            )
                .setName("Digestive通知")
                .setGroup("main")
                .build()
        )
        notificationMgr.createNotificationChannel(
            NotificationChannelCompat.Builder(
                DEFAULT_CHANNEL,
                NotificationManager.IMPORTANCE_DEFAULT
            )
                .setName("その他")
                .setGroup("main")
                .build()
        )
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)

        if (GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(this) != ConnectionResult.SUCCESS) {
            GoogleApiAvailability.getInstance().makeGooglePlayServicesAvailable(this)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) {
            uriEventApi?.onUri(intent.data.toString())
        }
    }
}
