package net.chikach.submon

import android.app.NotificationManager
import android.content.Intent
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationChannelGroupCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import net.chikach.submon.mch.MainMethodChannelHandler
import net.chikach.submon.mch.MessagingMethodChannelHandler
import net.chikach.submon.mch.REQUEST_CODE_CUSTOM_TABS

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

const val METHOD_CHANNEL_MAIN = "net.chikach.submon/main"
const val METHOD_CHANNEL_MESSAGING = "net.chikach.submon/messaging"
const val EVENT_CHANNEL_SIGN_IN_URI = "net.chikach.submon/signInUri"
const val EVENT_CHANNEL_URI = "net.chikach.submon/uri"

const val REQUEST_CODE_TAKE_PICTURE = 1

class MainActivity : FlutterActivity() {
    private val mainMethodChannelHandler = MainMethodChannelHandler(this)
    private val messagingMethodChannelHandler = MessagingMethodChannelHandler()
    var twitterSignInUriEventSink: EventChannel.EventSink? = null
    var uriEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        @Suppress("KotlinConstantConditions")
        if (BuildConfig.BUILD_TYPE != "release") {
            FirebaseAppCheck.getInstance().installAppCheckProviderFactory(
                DebugAppCheckProviderFactory.getInstance()
            )
        }

        if (intent.data != null) {
            mainMethodChannelHandler.pendingUri = intent.data
        }

        // main method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_MAIN).apply {
            setMethodCallHandler(mainMethodChannelHandler)
        }

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
            REQUEST_CODE_TAKE_PICTURE -> {
                mainMethodChannelHandler.takePictureCallback(resultCode)
            }
            REQUEST_CODE_CUSTOM_TABS -> {
                mainMethodChannelHandler.completeCustomTabs()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) {
            twitterSignInUriEventSink?.success(intent.data!!.query)
            uriEventSink?.success(intent.data.toString())
        }
    }

}
