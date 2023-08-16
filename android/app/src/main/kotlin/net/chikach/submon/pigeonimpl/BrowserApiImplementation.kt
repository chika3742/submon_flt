package net.chikach.submon.pigeonimpl

import BrowserApi
import FlutterError
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.browser.customtabs.CustomTabsIntent
import net.chikach.submon.WebPageActivity

class BrowserApiImplementation(private var activity: Activity) : BrowserApi {
    private var openAuthCustomTabCallback: ((Result<String?>) -> Unit)? = null

    companion object {
        val chromiumBrowsers = listOf(
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
        const val REQUEST_CODE_CUSTOM_TABS = 100
    }

    override fun openAuthCustomTab(url: String, callback: (Result<String?>) -> Unit) {
        val ctIntent = CustomTabsIntent.Builder().build()

        // check if the default browser is a Chromium browser
        val pm = activity.packageManager
        if (!chromiumBrowsers.contains(
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
            // set the first installed and enabled Chromium browser as the Custom Tabs intent target
            val `package` = chromiumBrowsers.firstOrNull {
                try {
                    pm.getApplicationEnabledSetting(it) == PackageManager.COMPONENT_ENABLED_STATE_DEFAULT
                } catch (e: IllegalArgumentException) {
                    false
                }
            }
            if (`package` != null) {
                ctIntent.intent.setPackage(`package`)
            } else {
                // if no Chromium browser is installed, show a toast and return with error
                Toast.makeText(
                    activity,
                    "Google Chromeもしくは、それ以外のChromium系ブラウザーをインストールする必要があります",
                    Toast.LENGTH_SHORT
                ).show()
                callback(
                    Result.failure(
                        FlutterError(
                            "failed-precondition",
                            "No chromium browser is installed. Must be installed any of ${
                                chromiumBrowsers.joinToString(", ")
                            }",
                        )
                    )
                )
                return
            }
        }
        ctIntent.intent.data = Uri.parse(url)
        activity.startActivityForResult(ctIntent.intent, REQUEST_CODE_CUSTOM_TABS)
        openAuthCustomTabCallback = callback
    }

    fun completeAuthCustomTab(callbackUri: Uri?) {
        openAuthCustomTabCallback?.invoke(Result.success(callbackUri?.toString()))
        openAuthCustomTabCallback = null
    }

    override fun openWebPage(title: String, url: String) {
        activity.startActivity(
            Intent(activity, WebPageActivity::class.java)
                .putExtra("title", title)
                .putExtra("url", url)
        )
    }

}