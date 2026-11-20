package com.nayem.quranamol

// v2.0: home-screen widget provider (next prayer). Reads the values
// Flutter saves via home_widget (SharedPreferences) and renders them
// into prayer_widget.xml. Tapping the widget opens the app.
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class PrayerWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.prayer_widget).apply {
                setTextViewText(
                    R.id.widget_prayer_name,
                    widgetData.getString("next_prayer", "ফজর") ?: "ফজর"
                )
                setTextViewText(
                    R.id.widget_prayer_time,
                    widgetData.getString("next_time", "") ?: ""
                )
                setTextViewText(
                    R.id.widget_countdown,
                    widgetData.getString("countdown", "") ?: ""
                )
                setTextViewText(
                    R.id.widget_city,
                    widgetData.getString("city", "ঢাকা") ?: "ঢাকা"
                )
            }
            val intent = context.packageManager
                .getLaunchIntentForPackage(context.packageName)
            val pending = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pending)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
