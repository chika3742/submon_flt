package net.chikach.submon

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.browser.customtabs.CustomTabsIntent
import net.chikach.submon.mch.REQUEST_CODE_CUSTOM_TABS

class UtilsAndroidApi(private val activity: MainActivity) : Messages.UtilsApi {
    private var signInCustomTabResult: Messages.Result<Messages.SignInCallback>? = null

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
        result: Messages.Result<Messages.SignInCallback>
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

    fun completeOpenSignInCustomTabWithError(error: Throwable) {
        signInCustomTabResult?.error(error)
        signInCustomTabResult = null
    }

    fun completeOpenSignInCustomTabWithResponseUri(responseUri: String) {
        signInCustomTabResult?.success(Messages.SignInCallback().also {
            it.uri = responseUri
        })
        signInCustomTabResult = null
    }
}

class SignInCustomTabException(code: String) : Exception(code) {
    companion object {
        const val canceled = "canceled"
    }
}
