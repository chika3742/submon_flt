package net.chikach.submon

import android.content.Context
import android.graphics.Color
import android.icu.text.SimpleDateFormat
import android.icu.util.TimeZone
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
import com.google.firebase.appcheck.playintegrity.PlayIntegrityAppCheckProviderFactory
import java.util.*
import kotlin.math.abs

object Utils {
    fun getDateDiff(dateString: String): Long {
        val date = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.sssZ", Locale.US).apply {
            timeZone = TimeZone.getTimeZone("Asia/Tokyo")
        }.parse(dateString)
        return date.time - System.currentTimeMillis()
    }

    fun getDateDiffString(dateString: String, context: Context): String {
        val diff = getDateDiff(dateString)

        val diffHours = diff / (60L * 60 * 1000) % 24
        val diffDays = diff / (24L * 60 * 60 * 1000)
        val diffWeeks = diff / (7L * 24 * 60 * 60 * 1000)
        val diffMonths = diff / (30L * 24 * 60 * 60 * 1000)
        return when {
            abs(diffMonths) > 0 -> "$diffMonths ヶ月"
            abs(diffWeeks) > 0 -> "$diffWeeks 週間"
            abs(diffDays) > 0 -> "$diffDays 日"
            else -> "$diffHours 時間"
        }
    }

    fun getDateDiffColor(dateDiff: Long): Int {
        return when {
            dateDiff < 0 -> Color.parseColor("#F44336")
            dateDiff < 2 * 24 * 60 * 60 * 1000 -> Color.parseColor("#FF9800")
            else -> Color.parseColor("#4CAF50")
        }
    }

    fun initAppCheck(): Unit {
        @Suppress("KotlinConstantConditions")
        if (BuildConfig.BUILD_TYPE == "release") {
            FirebaseAppCheck.getInstance().installAppCheckProviderFactory(
                PlayIntegrityAppCheckProviderFactory.getInstance()
            )
        } else {
            FirebaseAppCheck.getInstance().installAppCheckProviderFactory(
                DebugAppCheckProviderFactory.getInstance()
            )
        }
    }
}