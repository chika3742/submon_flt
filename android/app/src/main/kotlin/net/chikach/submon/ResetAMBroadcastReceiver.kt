package net.chikach.submon

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel

class ResetAMBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val executor = FlutterEngine(context).dartExecutor
        executor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())

        val mc = MethodChannel(executor.binaryMessenger, METHOD_CHANNEL_ACTIONS)
        mc.setMethodCallHandler { call, result ->
            Utils.registerReminderNotification(
                context,
                call.argument("title")!!,
                call.argument("body")!!,
                call.argument("hour")!!,
                call.argument("minute")!!,
            )
            result.success(null)
        }

        mc.invokeMethod("resetNotifications", null);
    }
}