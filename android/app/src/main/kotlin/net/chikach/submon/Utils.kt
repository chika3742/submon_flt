package net.chikach.submon

import android.content.Context
import android.graphics.Color
import android.icu.text.SimpleDateFormat
import android.icu.util.TimeZone
import java.util.*

object Utils {
    fun getDateDiff(dateString: String, context: Context): Long {
        val date = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.sssZ", Locale.US).apply {
            timeZone = TimeZone.getTimeZone("Asia/Tokyo")
        }.parse(dateString)
        return date.time - System.currentTimeMillis()
    }

    fun getDateDiffString(dateString: String, context: Context): String {
        val diff = getDateDiff(dateString, context)
        val diffHours = diff / (60L * 60 * 1000) % 24
        val diffDays = diff / (24L * 60 * 60 * 1000)
        val diffWeeks = diff / (7L * 24 * 60 * 60 * 1000)
        val diffMonths = diff / (30L * 24 * 60 * 60 * 1000)
        return when {
            diffMonths > 0 -> "$diffMonths ヶ月"
            diffWeeks > 0 -> "$diffWeeks 週間"
            diffDays > 0 -> "$diffDays 日"
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
}