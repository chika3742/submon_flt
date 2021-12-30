package net.chikach.submon

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import java.util.*

class SubmissionListAppWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager?,
        appWidgetIds: IntArray?
    ) {
        appWidgetIds?.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.submission_list_appwidget).apply {
                val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
                    PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                else PendingIntent.FLAG_UPDATE_CURRENT

                setPendingIntentTemplate(
                    R.id.listView, PendingIntent.getActivity(
                        context,
                        UUID.randomUUID().hashCode(), Intent(context, MainActivity::class.java)
                            .putExtra(
                                MainActivity.EXTRA_FLUTTER_ACTION,
                                Action.openSubmissionDetailPage.name
                            ), flags
                    )
                )
                setRemoteAdapter(
                    R.id.listView,
                    Intent(context, AppWidgetSubmissionListService::class.java)
                )

                setOnClickPendingIntent(
                    R.id.addBtn, PendingIntent.getActivity(
                        context, UUID.randomUUID().hashCode(),
                        Intent(
                            context,
                            MainActivity::class.java
                        ).putExtra(
                            MainActivity.EXTRA_FLUTTER_ACTION,
                            Action.openCreateNewPage.name
                        ),
                        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                    )
                )
                setOnClickPendingIntent(
                    R.id.titleBar, PendingIntent.getActivity(
                        context, UUID.randomUUID().hashCode(),
                        Intent(context, MainActivity::class.java),
                        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                    )
                )
            }

            appWidgetManager?.updateAppWidget(widgetId, views)
        }
    }
}

class AppWidgetSubmissionListService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        return Factory(
            this, listOf(
                mapOf("id" to 0, "title" to "title1", "date" to "1/13 (月)"),
                mapOf("id" to 1, "title" to "title2", "date" to "1/14 (火)"),
                mapOf("id" to 1, "title" to "title2", "date" to "1/14 (火)"),
                mapOf("id" to 1, "title" to "title2", "date" to "1/14 (火)"),
                mapOf("id" to 1, "title" to "title2", "date" to "1/14 (火)"),
            )
        )
    }

    inner class Factory(val context: Context, private val list: List<Map<String, Any>>) :
        RemoteViewsFactory {
        override fun onCreate() {}

        override fun onDataSetChanged() {

        }

        override fun onDestroy() {}

        override fun getCount(): Int = list.size

        override fun getViewAt(position: Int): RemoteViews {
            val views =
                RemoteViews(context.packageName, R.layout.appwidget_submission_list_item).apply {
                    setTextViewText(R.id.dateTextView, list[position]["date"] as String)
                    setTextViewText(R.id.titleTextView, list[position]["title"] as String)
                    setOnClickFillInIntent(
                        R.id.listItemLayout, Intent()
                            .putExtra(
                                MainActivity.EXTRA_FLUTTER_ACTION_ARGUMENT_ID,
                                list[position]["id"] as Int
                            )
                    )
                }

            return views
        }

        override fun getLoadingView(): RemoteViews {
            return RemoteViews(context.packageName, R.layout.appwidget_loading)
        }

        override fun getViewTypeCount(): Int = 1

        override fun getItemId(position: Int): Long = 0

        override fun hasStableIds(): Boolean = false
    }
}