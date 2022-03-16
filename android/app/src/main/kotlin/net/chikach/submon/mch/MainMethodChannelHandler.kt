package net.chikach.submon.mch

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
import android.widget.Toast
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.content.ContextCompat.startActivity
import androidx.core.content.FileProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.chikach.submon.*
import java.io.File
import java.io.FileOutputStream

class MainMethodChannelHandler(private val activity: MainActivity) :
    MethodChannel.MethodCallHandler {
    private var takePictureResult: MethodChannel.Result? = null
    private var pictureFile: File? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "openWebPage" -> {
                openWebPage(call, result)
            }
            "openCustomTabs" -> {
                openCustomTabs(call, result)
            }
            "updateWidgets" -> {
                updateWidgets()
            }
            "takePictureNative" -> {
                takePictureNative(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    /**
     * Opens web page with WebActivity
     *
     * @param call [MethodCall]
     * @param result [MethodChannel.Result]
     */
    private fun openWebPage(call: MethodCall, result: MethodChannel.Result) {
        val title = call.argument<String>("title")
        val url = call.argument<String>("url")
        activity.startActivity(
            Intent(activity, WebPageActivity::class.java)
                .putExtra("title", title)
                .putExtra("url", url)
        )
        result.success(null)
    }

    /**
     * Opens web page with Custom Tabs for authentication.
     * Firefox custom tabs are not properly called back, so uses other custom tabs to display them.
     *
     * @param call [MethodCall]
     * @param result [MethodChannel.Result]
     */
    private fun openCustomTabs(call: MethodCall, result: MethodChannel.Result) {
        val ctIntent = CustomTabsIntent.Builder().build()
        val pm = activity.packageManager
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
                    activity,
                    "Google Chromeもしくは、それ以外のChromium系ブラウザーをインストールする必要があります",
                    Toast.LENGTH_SHORT
                ).show()
                return
            }
        }
        ctIntent.launchUrl(activity, Uri.parse(call.argument("url")))
        result.success(null)
    }

    /**
     * Updates App Widget on home screen.
     */
    private fun updateWidgets() {
        Handler(activity.mainLooper).postDelayed({
            val aws = activity.getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
            val widgetIds = aws.getAppWidgetIds(
                ComponentName(
                    activity,
                    SubmissionListAppWidgetProvider::class.java
                )
            )

            activity.sendBroadcast(
                Intent(activity, SubmissionListAppWidgetProvider::class.java)
                    .setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                    .putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
            )
        }, 2000)
    }

    /**
     * Launches [Intent] to take picture.
     *
     * @param result [MethodChannel.Result]
     */
    private fun takePictureNative(result: MethodChannel.Result) {
        takePictureResult = result
        pictureFile = File(activity.cacheDir, "${System.currentTimeMillis()}.jpg")
        pictureFile!!.createNewFile()
        val uri =
            FileProvider.getUriForFile(
                activity,
                "${activity.packageName}.fileprovider",
                pictureFile!!
            )
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri)
        activity.startActivityForResult(intent, REQUEST_CODE_TAKE_PICTURE)
    }

    /**
     * Callback of [takePictureNative]
     */
    fun takePictureCallback() {
        if (pictureFile != null) {
            var bmp = BitmapFactory.decodeFile(pictureFile!!.path)
            var width = bmp.width
            var height = bmp.height
            val matrix = Matrix()
//            val exifInterface = ExifInterface(pictureFile!!.path)
//            when (exifInterface.getAttribute(ExifInterface.TAG_ORIENTATION)) {
//                "1" -> {
//                    matrix.postRotate(90F)
//                }
//                "6" -> {
//                    matrix.postRotate(0F)
//                }
//                "3" -> {
//                    matrix.postRotate(90F)
//                }
//                "8" -> {
//                    matrix.postRotate(270F)
//                }
//            }
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