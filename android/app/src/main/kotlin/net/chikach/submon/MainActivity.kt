package net.chikach.submon

import android.app.NotificationManager
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Handler
import android.util.Log
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationChannelGroupCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import net.chikach.submon.Messages.AppLinkHandlerApi
import net.chikach.submon.Messages.UtilsApi
import net.chikach.submon.mch.MessagingMethodChannelHandler
import net.chikach.submon.mch.REQUEST_CODE_NOTIFICATION_PERMISSION

val chromiumBrowserPackages = listOf(
    "com.android.chrome",
    "com.chrome.beta",
    "com.chrome.dev",
    "com.chrome.canary",
    "com.microsoft.emmx",
    "com.microsoft.emmx.beta",
    "com.microsoft.emmx.dev",
    "com.microsoft.emmx.canary",
    "com.brave.browser",
    "com.vivaldi.browser",
    "com.opera.browser",
    "com.sec.android.app.sbrowser",
    "com.sec.android.app.sbrowser.beta",
)

const val REMINDER_CHANNEL = "reminder"
const val TIMETABLE_CHANNEL = "timetable"
const val DO_TIME_CHANNEL = "digestive"
const val DEFAULT_CHANNEL = "default"

const val METHOD_CHANNEL_MESSAGING = "net.chikach.submon/messaging"
const val EVENT_CHANNEL_SIGN_IN_URI = "net.chikach.submon/signInUri"
const val EVENT_CHANNEL_URI = "net.chikach.submon/uri"

class MainActivity : FlutterActivity() {
    private val utilsApi = UtilsAndroidApi(this)
    lateinit var binaryMessenger: BinaryMessenger
    private val messagingMethodChannelHandler = MessagingMethodChannelHandler(this)
    var twitterSignInUriEventSink: EventChannel.EventSink? = null
    var uriEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        binaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        Utils.initAppCheck()

        if (intent.data != null) {
            Log.d("intent", intent.data.toString())
            AppLinkHandlerApi(binaryMessenger).handleUri(intent.data!!.toString()) {}
        }

        // main method channel
        UtilsApi.setup(flutterEngine.dartExecutor.binaryMessenger, utilsApi)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_MESSAGING).apply {
            setMethodCallHandler(messagingMethodChannelHandler)
        }

        val twitterSignInUriEventChannel =
            EventChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                EVENT_CHANNEL_SIGN_IN_URI
            )
        twitterSignInUriEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                twitterSignInUriEventSink = events
            }

            override fun onCancel(arguments: Any?) {
                twitterSignInUriEventSink = null
            }
        })

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL_URI
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                uriEventSink = events
            }

            override fun onCancel(arguments: Any?) {
                uriEventSink = null
            }
        })

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
            REQUEST_CODE_CUSTOM_TABS -> {
                Handler(mainLooper).postDelayed({
                    utilsApi.completeOpenSignInCustomTabWithError(
                        SignInCustomTabException(SignInCustomTabException.canceled)
                    )
                }, 1000)
            }
        }
    }

    override fun onFlutterUiDisplayed() {
        super.onFlutterUiDisplayed()
        if (intent.data != null) {
            AppLinkHandlerApi(binaryMessenger).handleUri(intent.data!!.toString()) {}
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_NOTIFICATION_PERMISSION) {
            messagingMethodChannelHandler
                .completeRequestNotificationPermission(grantResults.all { it == PackageManager.PERMISSION_GRANTED })
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) {
            if (intent.data!!.host == "auth-callback") {
                utilsApi.completeOpenSignInCustomTabWithUri(intent.data!!.toString())
            } else {
                AppLinkHandlerApi(binaryMessenger).handleUri(intent.data.toString()) {}
                uriEventSink?.success(intent.data.toString())
            }
        }
    }
}
