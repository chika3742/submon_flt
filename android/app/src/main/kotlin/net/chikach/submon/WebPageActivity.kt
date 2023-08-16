package net.chikach.submon

import android.animation.ObjectAnimator
import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import net.chikach.submon.databinding.ActivityWebPageBinding

class WebPageActivity : AppCompatActivity() {
    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        title = intent.getStringExtra("title")

        val binding = ActivityWebPageBinding.inflate(layoutInflater)

        binding.run {
            val url = intent.getStringExtra("url") ?: return
            webView.settings.domStorageEnabled = true
            webView.settings.javaScriptEnabled = true

            webView.webViewClient = object : WebViewClient() {
                override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                    super.onPageStarted(view, url, favicon)
                    ObjectAnimator.ofFloat(progressBar, "scaleY", 1F).apply {
                        duration = 300
                    }.start()
                }

                override fun onPageFinished(view: WebView?, url: String?) {
                    super.onPageFinished(view, url)
                    ObjectAnimator.ofFloat(progressBar, "scaleY", 0F).apply {
                        duration = 300
                    }.start()
                }
            }

            webView.loadUrl(url)
        }

        setContentView(binding.root)
    }

    override fun onSupportNavigateUp(): Boolean {
        finish()
        return true
    }
}