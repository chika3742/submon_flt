package net.chikach.submon

import android.app.Activity
import android.app.NotificationManager
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.net.Uri
import android.os.Handler
import android.provider.MediaStore
import android.util.Log
import android.widget.Toast
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationChannelGroupCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.FileProvider
import androidx.exifinterface.media.ExifInterface
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

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

const val METHOD_CHANNEL_MAIN = "submon/main"
const val METHOD_CHANNEL_NOTIFICATION = "submon/notification"
const val METHOD_CHANNEL_ACTIONS = "submon/actions"

const val REQUEST_CODE_TAKE_PICTURE = 1

class MainActivity : FlutterActivity() {
    lateinit var mainMethodChannel: MethodChannel
    var pendingAction: String? = null
    var pendingActionArgument: Int? = null

    var takePictureResult: MethodChannel.Result? = null
    var pictureFile: File? = null

    companion object {
        const val EXTRA_FLUTTER_ACTION = "FLUTTER_ACTION"
        const val EXTRA_FLUTTER_ACTION_ARGUMENT_ID = "FLUTTER_ACTION_ARGUMENT_ID"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        if (intent.hasExtra(EXTRA_FLUTTER_ACTION)) {
            val mc =
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_ACTIONS)

            pendingAction = intent.getStringExtra(EXTRA_FLUTTER_ACTION)
            pendingActionArgument = intent.getIntExtra(EXTRA_FLUTTER_ACTION_ARGUMENT_ID, -1)
            mc.invokeMethod(pendingAction!!, pendingActionArgument)
        }

        mainMethodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_MAIN)
        mainMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                // Opens web page with WebActivity
                "openWebPage" -> {
                    val title = call.argument<String>("title")
                    val url = call.argument<String>("url")
                    startActivity(
                        Intent(this, WebPageActivity::class.java)
                            .putExtra("title", title)
                            .putExtra("url", url)
                    )
                    result.success(null)
                }
                // Opens Custom Tabs
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
                    result.success(null)
                }
                // Updates App Widgets
                "updateWidgets" -> {
                    Handler(mainLooper).postDelayed({
                        val aws = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
                        val widgetIds = aws.getAppWidgetIds(
                            ComponentName(
                                this,
                                SubmissionListAppWidgetProvider::class.java
                            )
                        )

                        sendBroadcast(
                            Intent(this, SubmissionListAppWidgetProvider::class.java)
                                .setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                                .putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
                        )
                    }, 2000)
                }
                "takePictureNative" -> {
                    takePictureResult = result
                    pictureFile = File(cacheDir, "${System.currentTimeMillis()}.jpg")
                    pictureFile!!.createNewFile()
                    val uri =
                        FileProvider.getUriForFile(this, "$packageName.fileprovider", pictureFile!!)
                    val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                    intent.putExtra(MediaStore.EXTRA_OUTPUT, uri)
                    startActivityForResult(intent, REQUEST_CODE_TAKE_PICTURE)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        val notificationMethodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_NOTIFICATION)
        notificationMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isGranted" -> {
                    result.success(true)
                }
                "registerReminder" -> {
                    Utils.registerReminderNotification(
                        this,
                        call.argument("title")!!,
                        call.argument("body")!!,
                        call.argument("hour")!!,
                        call.argument("minute")!!,
                    )
                    result.success(null)
                }
                "unregisterReminder" -> {
                    Utils.cancelReminderNotification(this)
                    result.success(null)
                }
                "registerTimetable" -> {
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        val amc = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_ACTIONS)
        amc.setMethodCallHandler { call, result ->
            when (call.method) {
                "getPendingAction" -> {
                    result.success(pendingAction)
                    pendingAction = null
                }
                "getPendingActionArgument" -> {
                    result.success(pendingActionArgument)
                    pendingActionArgument = null
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
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQUEST_CODE_TAKE_PICTURE -> {
                if (resultCode == Activity.RESULT_OK && pictureFile != null) {
                    var bmp = BitmapFactory.decodeFile(pictureFile!!.path)
                    var width = bmp.width
                    var height = bmp.height
                    val matrix = Matrix()
//                    val exifInterface = ExifInterface(pictureFile!!.path)
//                    when (exifInterface.getAttribute(ExifInterface.TAG_ORIENTATION)) {
//                        "1" -> {
//                            matrix.postRotate(90F)
//                        }
//                        "6" -> {
//                            matrix.postRotate(0F)
//                        }
//                        "3" -> {
//                            matrix.postRotate(90F)
//                        }
//                        "8" -> {
//                            matrix.postRotate(270F)
//                        }
//                    }
                    Log.d("bitmap size", "${width}x${height}")
                    if (height > width) {
                        if (width > (height * (9 / 16.0)).toInt()) {
                            width = (height * (9 / 16.0)).toInt()
                        } else {
                            height = (width * (16.0 / 9)).toInt()
                        }
                    } else {
                        if (width > (height * (16.0 / 9)).toInt()) {
                            width = (height * (16.0 / 9)).toInt()
                        } else {
                            height = (width * (9 / 16.0)).toInt()
                        }
                        matrix.postRotate(90F)
                    }
                    Log.d("bitmap final size", "${width}x${height}")
                    bmp = Bitmap.createBitmap(bmp, 0, 0, width, height, matrix, false)
                    val stream = FileOutputStream(pictureFile!!)
                    bmp.compress(Bitmap.CompressFormat.JPEG, 80, stream)
                    stream.close()
                    takePictureResult?.success(pictureFile!!.path)
                    bmp.recycle()
                } else {
                    takePictureResult?.success(null)
                }
                takePictureResult = null
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) mainMethodChannel.invokeMethod("onUriData", intent.data!!.query)

        if (intent.hasExtra(EXTRA_FLUTTER_ACTION) && flutterEngine != null) {
            val mc =
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, METHOD_CHANNEL_ACTIONS)
            mc.invokeMethod(
                intent.getStringExtra(EXTRA_FLUTTER_ACTION)!!, intent.getIntExtra(
                    EXTRA_FLUTTER_ACTION_ARGUMENT_ID, -1
                )
            )
        }
    }

}
