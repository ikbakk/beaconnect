import 'dart:convert';
import 'dart:io' show Platform;

import 'package:home_widget/home_widget.dart';

import '../domain/widget_snapshot.dart';

class WidgetUpdater {
  static const _widgetId = 'beaconnect_widget_data';

  static bool get isAvailable => Platform.isAndroid || Platform.isIOS;

  static Future<void> update(WidgetSnapshot snapshot) async {
    if (!isAvailable) {
      return;
    }

    try {
      await HomeWidget.saveWidgetData<String>(
        _widgetId,
        jsonEncode({
          'partnerName': snapshot.name,
          'statusSentence': snapshot.statusSentence,
          'freshnessSentence': snapshot.freshnessSentence,
        }),
      );
      await HomeWidget.updateWidget(
        androidName: 'BeaconnectWidgetProvider',
      );
    } catch (_) {
      // Widget updates are best-effort.
      // If the widget is not placed or the plugin is not available,
      // we silently skip.
    }
  }
}
