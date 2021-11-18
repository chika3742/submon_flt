package net.chikach.submon

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel = "submon/main";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "openWebPage" -> {
                    val title = call.argument<String>("title")
                    val url = call.argument<String>("url")
                    startActivity(Intent(this, WebPageActivity::class.java)
                        .putExtra("title", title)
                        .putExtra("url", url))
                }
            }
        }
    }
}
