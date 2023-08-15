package net.chikach.submon

import BrowserApi
import GeneralApi
import MessagingApi
import android.app.NotificationManager
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Handler
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationChannelGroupCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import net.chikach.submon.eventapi.FcmTokenRefreshEventApi
import net.chikach.submon.eventapi.UriEventApi
import net.chikach.submon.pigeonimpl.BrowserApiImplementation
import net.chikach.submon.pigeonimpl.GeneralApiImplementation
import net.chikach.submon.pigeonimpl.MessagingApiImplementation
import net.chikach.submon.pigeonimpl.MessagingApiImplementation.Companion.REQUEST_CODE_NOTIFICATION_PERMISSION

const val REMINDER_CHANNEL = "reminder"
const val TIMETABLE_CHANNEL = "timetable"
const val DO_TIME_CHANNEL = "digestive"
const val DEFAULT_CHANNEL = "default"

const val REQUEST_CODE_TAKE_PICTURE = 1

class MainActivity : FlutterActivity() {
    private val messagingApiImpl = MessagingApiImplementation(this)
    private val browserApiImpl = BrowserApiImplementation(this)

    var uriEventApi: UriEventApi? = null

    companion object {
        var fcmTokenRefreshEventApi: FcmTokenRefreshEventApi? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Utils.initAppCheck()

        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        uriEventApi = UriEventApi(binaryMessenger)
        uriEventApi!!.initHandler()
        fcmTokenRefreshEventApi = FcmTokenRefreshEventApi(binaryMessenger)
        fcmTokenRefreshEventApi!!.initHandler()

        if (intent.data != null) {
            uriEventApi!!.onUri(intent.data.toString())
        }

        GeneralApi.setUp(binaryMessenger, GeneralApiImplementation(this))
        MessagingApi.setUp(binaryMessenger, messagingApiImpl)
        BrowserApi.setUp(binaryMessenger, browserApiImpl)

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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQUEST_CODE_TAKE_PICTURE -> {
//                mainMethodChannelHandler.takePictureCallback(resultCode)
            }

            BrowserApiImplementation.REQUEST_CODE_CUSTOM_TABS -> {
                // wait for new intent
                Handler(mainLooper).postDelayed({
                    // if no new intent is received, complete with null
                    browserApiImpl.completeAuthCustomTab(null)
                }, 3000)
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == REQUEST_CODE_NOTIFICATION_PERMISSION) {
            messagingApiImpl.completeRequestNotificationPermission(
                grantResults.all { it == PackageManager.PERMISSION_GRANTED }
            )
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) {
            if (intent.data.toString().startsWith("submon://auth-callback/")) {
                // auth callback
                browserApiImpl.completeAuthCustomTab(intent.data)
            } else {
                uriEventApi?.onUri(intent.data.toString())
            }
        }
    }

}
