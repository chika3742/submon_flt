package net.chikach.submon.pigeonimpl

import FlutterError
import GeneralApi
import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.view.View
import android.view.WindowInsets
import android.view.WindowInsetsController
import android.view.WindowManager
import net.chikach.submon.SubmissionListAppWidgetProvider

class GeneralApiImplementation(val activity: Activity) : GeneralApi {
    override fun updateWidgets() {
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

    override fun requestIDFA(callback: (Result<Boolean>) -> Unit) {
        throw FlutterError("unsupported", "This method is not supported on Android", null)
    }

    override fun setWakeLock(enabled: Boolean) {
        val flag = WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON

        if (enabled) {
            activity.window.addFlags(flag)
        } else {
            activity.window.clearFlags(flag)
        }
    }

    override fun setFullscreen(isFullscreen: Boolean) {
        if (isFullscreen) {
            // enter fullscreen
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                activity.window.decorView.windowInsetsController?.hide(WindowInsets.Type.statusBars())
                activity.window.decorView.windowInsetsController?.systemBarsBehavior =
                    WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
            } else {
                @Suppress("DEPRECATION")
                activity.window.decorView.systemUiVisibility =
                    View.SYSTEM_UI_FLAG_IMMERSIVE or View.SYSTEM_UI_FLAG_FULLSCREEN
            }
        } else {
            // exit fullscreen
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                activity.window.decorView.windowInsetsController?.show(WindowInsets.Type.statusBars())
            } else {
                @Suppress("DEPRECATION")
                activity.window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_VISIBLE
            }
        }
    }
}