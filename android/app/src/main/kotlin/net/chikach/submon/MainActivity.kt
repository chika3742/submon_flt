package net.chikach.submon

import android.app.Activity
import android.app.NotificationManager
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationChannelGroupCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import net.chikach.submon.mch.ActionMethodChannelHandler
import net.chikach.submon.mch.MainMethodChannelHandler
import net.chikach.submon.mch.MessagingMethodChannelHandler

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
const val DO_TIME_CHANNEL = "doTime"

const val METHOD_CHANNEL_MAIN = "net.chikach.submon/main"
const val METHOD_CHANNEL_ACTION = "net.chikach.submon/action"
const val METHOD_CHANNEL_MESSAGING = "net.chikach.submon/messaging"
const val EVENT_CHANNEL_URI_INTENT = "net.chikach.submon/uriIntent"

const val REQUEST_CODE_TAKE_PICTURE = 1

class MainActivity : FlutterActivity() {
    private var mainMethodChannelHandler = MainMethodChannelHandler(this)
    private var actionMethodChannelHandler = ActionMethodChannelHandler()
    private var messagingMethodChannelHandler = MessagingMethodChannelHandler()
    var uriIntentEventSink: EventChannel.EventSink? = null

    companion object {
        /**
         * Type: [String]
         */
        const val EXTRA_FLUTTER_ACTION = "flutterAction"

        /**
         * Type: [HashMap]
         */
        const val EXTRA_FLUTTER_ACTION_ARGUMENTS = "flutterActionArguments"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        if (intent.hasExtra(EXTRA_FLUTTER_ACTION)) {
            Log.d("action", intent.getStringExtra(EXTRA_FLUTTER_ACTION).toString())
            actionMethodChannelHandler.pendingAction = mapOf(
                "actionName" to intent.getStringExtra(EXTRA_FLUTTER_ACTION)!!,
                "arguments" to intent.getSerializableExtra(EXTRA_FLUTTER_ACTION_ARGUMENTS)
            )
        }

        // main method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_MAIN).apply {
            setMethodCallHandler(mainMethodChannelHandler)
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_ACTION).apply {
            setMethodCallHandler(actionMethodChannelHandler)
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_MESSAGING).apply {
            setMethodCallHandler(messagingMethodChannelHandler)
        }

        val uriIntentEventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_URI_INTENT)
        uriIntentEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                uriIntentEventSink = events
            }

            override fun onCancel(arguments: Any?) {
                uriIntentEventSink = null
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
                .setName("DoTime通知")
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
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        when {
            intent.hasExtra(EXTRA_FLUTTER_ACTION) -> {
                actionMethodChannelHandler.pendingAction = mapOf(
                    "actionName" to intent.getStringExtra(EXTRA_FLUTTER_ACTION)!!,
                    "arguments" to intent.getSerializableExtra(EXTRA_FLUTTER_ACTION_ARGUMENTS),
                )
                actionMethodChannelHandler.invokeIntentAction(flutterEngine)
            }

            intent.data != null -> {
                uriIntentEventSink?.success(intent.data!!.query)
            }
        }
    }

}
