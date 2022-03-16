package net.chikach.submon

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.text.format.DateFormat
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.google.android.gms.tasks.Tasks
import com.google.firebase.Timestamp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import net.chikach.submon.Utils.getDateDiff
import net.chikach.submon.Utils.getDateDiffColor
import net.chikach.submon.Utils.getDateDiffString
import java.io.Serializable
import java.util.*

class SubmissionListAppWidgetProvider : AppWidgetProvider() {
    @SuppressLint("WrongConstant")
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
                    R.id.listView, PendingIntent.getBroadcast(
                        context,
                        UUID.randomUUID().hashCode(), Intent(
                            context,
                            ListItemActionBroadcastReceiver::class.java
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
                        }.sortedBy { DateFormat.getDateFormat(context).parse(it.date) }
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
                    val date = getDateDiffString(list[position].date, context)
                    setTextViewText(R.id.dateTextView, date)
                    setTextColor(
                        R.id.dateTextView,
                        getDateDiffColor(getDateDiff(list[position].date, context))
                    )
                    setTextViewText(R.id.titleTextView, list[position].title)
                    setOnClickFillInIntent(
                        R.id.listItemLayout, Intent()
                            .setAction(ListItemActionBroadcastReceiver.ACTION_LIST_ITEM_CLICK)
                            .putExtra(
                                MainActivity.EXTRA_FLUTTER_ACTION_ARGUMENTS,
                                hashMapOf(
                                    "submissionId" to list[position].id.toInt()
                                )
                            )
                    )
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        setCompoundButtonChecked(R.id.listCheckBox, false)
                        setOnCheckedChangeResponse(
                            R.id.listCheckBox, RemoteViews.RemoteResponse.fromFillInIntent(
                                Intent(context, ListItemActionBroadcastReceiver::class.java)
                                    .setAction(ListItemActionBroadcastReceiver.ACTION_CHECK_BOX_CHANGE)
                                    .putExtra(
                                        ListItemActionBroadcastReceiver.EXTRA_SUBMISSION_ID,
                                        list[position].id
                                    )
                            )
                        )
                    }
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

class ListItemActionBroadcastReceiver : BroadcastReceiver() {
    companion object {
        const val ACTION_LIST_ITEM_CLICK = "net.chikach.submon.action.LIST_ITEM_CLICK"
        const val ACTION_CHECK_BOX_CHANGE = "net.chikach.submon.action.CHECK_BOX_CHANGE"

        const val EXTRA_SUBMISSION_ID = "net.chikach.submon.extra.SUBMISSION_ID"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_LIST_ITEM_CLICK) {
            Log.d(
                "appwidget",
                intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1).toString()
            )
            val intent1 = Intent(context, MainActivity::class.java)
                .putExtra(
                    MainActivity.EXTRA_FLUTTER_ACTION,
                    Action.openSubmissionDetailPage.name
                )
                .putExtra(
                    MainActivity.EXTRA_FLUTTER_ACTION_ARGUMENTS,
                    intent.getSerializableExtra(MainActivity.EXTRA_FLUTTER_ACTION_ARGUMENTS)
                )
                .putExtra(
                    AppWidgetManager.EXTRA_APPWIDGET_ID,
                    intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1)
                )
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent1.data = Uri.parse(intent1.toUri(Intent.URI_INTENT_SCHEME))
            context.startActivity(intent1)
        } else if (intent.action == ACTION_CHECK_BOX_CHANGE && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (intent.getBooleanExtra(RemoteViews.EXTRA_CHECKED, false)) {
                val submissionId = intent.getLongExtra(EXTRA_SUBMISSION_ID, -1)
                val user = FirebaseAuth.getInstance().currentUser

                if (submissionId != -1L && user != null) {
                    val db = FirebaseFirestore.getInstance()
                    Tasks.whenAll(
                        listOf(
                            db.document("users/${user.uid}/submission/${submissionId}")
                                .update("done", 1),
                            db.document("users/${user.uid}")
                                .update("lastChanged", Timestamp.now())
                        )
                    ).addOnSuccessListener {
                        // update widgets
                        val aws =
                            context.getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
                        val widgetIds = aws.getAppWidgetIds(
                            ComponentName(
                                context,
                                SubmissionListAppWidgetProvider::class.java
                            )
                        )

                        aws.notifyAppWidgetViewDataChanged(widgetIds, R.id.listView)
                    }
                }
            }
        }
    }
}