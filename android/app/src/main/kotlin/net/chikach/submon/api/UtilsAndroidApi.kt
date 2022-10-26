package net.chikach.submon.api

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.view.View
import android.view.WindowInsets
import android.view.WindowInsetsController
import android.view.WindowManager
import android.widget.Toast
import androidx.browser.customtabs.CustomTabsIntent
import net.chikach.submon.Messages.*
import net.chikach.submon.*

const val REQUEST_CODE_CUSTOM_TABS = 15

class UtilsAndroidApi(private val activity: MainActivity) : UtilsApi {
    private var signInCustomTabResult: Result<SignInCallback>? = null

    /**
     * Opens web page with WebActivity
     *
     * @param title Activity title
     * @param url Url to open
     */
    override fun openWebPage(title: String, url: String) {
        activity.startActivity(
            Intent(activity, WebPageActivity::class.java)
                .putExtra("title", title)
                .putExtra("url", url)
        )
    }

    override fun openSignInCustomTab(
        url: String,
        result: Result<SignInCallback>
    ) {
        val ctIntent = CustomTabsIntent.Builder().build()

        // Browser installation check
        val pm = activity.packageManager
        if (!chromiumBrowserPackages.contains(
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    pm.resolveActivity(
                        Intent("android.intent.action.VIEW", Uri.parse("http://")),
                        PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_DEFAULT_ONLY.toLong())
                    )
                } else {
                    @Suppress("DEPRECATION")
                    pm.resolveActivity(
                        Intent("android.intent.action.VIEW", Uri.parse("http://")),
                        PackageManager.MATCH_DEFAULT_ONLY
                    )
                }?.activityInfo?.packageName
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
                    "Google Chromeをインストールする必要があります",
                    Toast.LENGTH_SHORT
                ).show()
                result.error(Exception("Compatible browser not installed"))
            }
        }

        ctIntent.intent.data = Uri.parse(url)
        activity.startActivityForResult(ctIntent.intent, REQUEST_CODE_CUSTOM_TABS)
        signInCustomTabResult = result
    }

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

    override fun requestIDFA(result: Result<Boolean>) {
        // Do nothing
        result.success(true)
    }

    override fun setFullscreen(fullscreen: Boolean) {
        if (fullscreen) {
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
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                activity.window.decorView.windowInsetsController?.show(WindowInsets.Type.statusBars())
            } else {
                @Suppress("DEPRECATION")
                activity.window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_VISIBLE
            }
        }
    }

    override fun setWakeLock(wakeLock: Boolean) {
        if (wakeLock) {
            activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        } else {
            activity.window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }
    }

    fun completeOpenSignInCustomTabWithError(error: Throwable) {
        signInCustomTabResult?.error(error)
        signInCustomTabResult = null
    }

    fun completeOpenSignInCustomTabWithUri(uri: String) {
        signInCustomTabResult?.success(SignInCallback.Builder().setUri(uri).build())
        signInCustomTabResult = null
    }
}

class SignInCustomTabException(code: String) : Exception(code) {
    companion object {
        const val canceled = "canceled"
    }
}
