package net.chikach.submon

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.coroutines.*
import java.io.Serializable
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
                if (FirebaseAuth.getInstance().currentUser != null) {
                    setEmptyView(R.id.listView, R.id.emptyText)
                    setViewVisibility(R.id.notSignedInText, View.GONE)
                    setViewVisibility(R.id.emptyTextParent, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.notSignedInText, View.VISIBLE)
                    setViewVisibility(R.id.emptyTextParent, View.GONE)
                }

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
            appWidgetManager?.notifyAppWidgetViewDataChanged(widgetId, R.id.listView)
        }
    }
}

class AppWidgetSubmissionListService : RemoteViewsService() {
    val coroutineScope = CoroutineScope(Dispatchers.Default)

    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        return Factory(this)
    }

    inner class Factory(private val context: Context) :
        RemoteViewsFactory {
        private var list: List<SubmissionData> = listOf()

        override fun onCreate() {
        }

        override fun onDataSetChanged() {
            val user = FirebaseAuth.getInstance().currentUser
            if (user != null) {
                val deferred = CompletableDeferred<Unit>()
                FirebaseFirestore.getInstance().collection("users/${user.uid}/submission")
                    .whereEqualTo("done", 0)
                    .get()
                    .addOnSuccessListener { snapshot ->
                        val list = snapshot.documents.map {
                            SubmissionData(
                                it["id"] as Long,
                                it["title"] as String,
                                it["date"] as String
                            )
                        }
                        this.list = list
                        deferred.complete(Unit)
                    }
                    .addOnFailureListener {
                        Log.e("AppWidget", "Failed to get firestore", it)
                        deferred.complete(Unit)
                    }
                runBlocking {
                    deferred.await()
                }
            }
        }

        override fun onDestroy() {}

        override fun getCount(): Int = list.size

        override fun getViewAt(position: Int): RemoteViews {
            val views =
                RemoteViews(context.packageName, R.layout.appwidget_submission_list_item).apply {
                    setTextViewText(R.id.dateTextView, list[position].date)
                    setTextViewText(R.id.titleTextView, list[position].title)
                    setOnClickFillInIntent(
                        R.id.listItemLayout, Intent()
                            .putExtra(
                                MainActivity.EXTRA_FLUTTER_ACTION_ARGUMENT_ID,
                                list[position].id.toInt()
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

class SubmissionData(val id: Long, val title: String, val date: String) : Serializable