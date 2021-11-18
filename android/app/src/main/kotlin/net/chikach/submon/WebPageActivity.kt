package net.chikach.submon

import android.annotation.SuppressLint
import android.os.Bundle
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
            webView.loadUrl(url)
        }

        setContentView(binding.root)
    }

    override fun onSupportNavigateUp(): Boolean {
        finish()
        return true
    }
}