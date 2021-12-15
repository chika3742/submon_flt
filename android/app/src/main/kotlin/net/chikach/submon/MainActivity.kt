package net.chikach.submon

import android.app.NotificationChannelGroup
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationChannelGroupCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

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

class MainActivity : FlutterActivity() {
    private val channel = "submon/main"
    lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "openWebPage" -> {
                    val title = call.argument<String>("title")
                    val url = call.argument<String>("url")
                    startActivity(
                        Intent(this, WebPageActivity::class.java)
                            .putExtra("title", title)
                            .putExtra("url", url)
                    )
                }
                "openCustomTabs" -> {
                    val ctIntent = CustomTabsIntent.Builder().build()
                    val pm = packageManager
                    if (!chromiumBrowserPackages.contains(
                            pm.resolveActivity(
                                Intent("android.intent.action.VIEW", Uri.parse("http://")),
                                PackageManager.MATCH_DEFAULT_ONLY
                            )?.activityInfo?.packageName
                        )
                    ) {
                        val `package` = chromiumBrowserPackages.firstOrNull {
                            try {
                                pm.getApplicationEnabledSetting(it) == PackageManager.COMPONENT_ENABLED_STATE_DEFAULT
                            } catch (e: IllegalArgumentException) {
                                false
                            }
                        }
                        if (`package` != null) {
                            ctIntent.intent.setPackage(`package`)
                        } else {
                            Toast.makeText(
                                this,
                                "Google Chromeもしくは、それ以外のChromium系ブラウザーをインストールする必要があります",
                                Toast.LENGTH_SHORT
                            ).show()
                            return@setMethodCallHandler
                        }
                    }
                    ctIntent.launchUrl(this, Uri.parse(call.argument("url")))
                }
            }
        }

        val notificationMgr = NotificationManagerCompat.from(context)
        notificationMgr.createNotificationChannelGroup(
            NotificationChannelGroupCompat.Builder("main")
                .setName("メイン")
                .build()
        )
        notificationMgr.createNotificationChannel(
            NotificationChannelCompat.Builder("reminder", NotificationManager.IMPORTANCE_HIGH)
                .setName("リマインダー通知")
                .setGroup("main")
                .build()
        )
        notificationMgr.createNotificationChannel(
            NotificationChannelCompat.Builder("timetable", NotificationManager.IMPORTANCE_DEFAULT)
                .setName("時間割通知")
                .setGroup("main")
                .build()
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 10) {
            Log.d("result", data.toString())
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("called", "called")
        if (intent.data != null) methodChannel.invokeMethod("onUriData", intent.data!!.query)
    }

}
