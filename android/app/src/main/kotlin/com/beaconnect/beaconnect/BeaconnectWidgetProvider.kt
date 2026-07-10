package com.beaconnect.beaconnect

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONObject

class BeaconnectWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.beaconnect_widget)
            val prefs = HomeWidgetPlugin.getData(context)
            val rawData = prefs.getString("beaconnect_widget_data", null)

            var partnerName = "Welcome."
            var status = "Pair when you are ready."
            var freshness = "No current place yet."

            if (rawData != null) {
                try {
                    val json = JSONObject(rawData)
                    partnerName = json.optString("partnerName", partnerName)
                    status = json.optString("statusSentence", status)
                    freshness = json.optString("freshnessSentence", freshness)
                } catch (_: Exception) {
                    // Use defaults if JSON parsing fails.
                }
            }

            views.setTextViewText(R.id.widget_partner_name, partnerName)
            views.setTextViewText(R.id.widget_status, status)
            views.setTextViewText(R.id.widget_freshness, freshness)

            val tapIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (tapIntent != null) {
                views.setOnClickPendingIntent(
                    R.id.widget_partner_name,
                    PendingIntent.getActivity(
                        context,
                        appWidgetId,
                        tapIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                    ),
                )
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
