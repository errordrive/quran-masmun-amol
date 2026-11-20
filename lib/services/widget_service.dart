// Home-screen widget (v2.0, Android only): shows the next prayer name,
// its time and the countdown. Data is pushed from Flutter whenever the
// app opens (and whenever the city changes); the native widget provider
// (PrayerWidgetProvider) reads the same values from SharedPreferences.
// The countdown text is therefore as fresh as the last app open, and
// the system also refreshes the widget every 30 minutes
// (updatePeriodMillis in prayer_widget_info.xml).
import 'package:home_widget/home_widget.dart';
import 'app_state.dart';
import 'prayer.dart';
import 'strings.dart';

class HomeWidgetService {
  static const String _providerName = 'PrayerWidgetProvider';
  static const String _qualifiedName =
      'com.nayem.quranamol.PrayerWidgetProvider';

  static Future<void> update() async {
    try {
      final state = AppState.instance;
      final now = DateTime.now();
      final today = state.prayerTimesFor(now);
      final tomorrow =
          state.prayerTimesFor(now.add(const Duration(days: 1)));
      final (_, next, nextTime) = currentAndNextPrayer(today, tomorrow, now);
      await HomeWidget.saveWidgetData<String>(
          'next_prayer', prayerName(next));
      await HomeWidget.saveWidgetData<String>(
          'next_time', formatTime(nextTime, use24h: state.use24h));
      await HomeWidget.saveWidgetData<String>(
          'countdown', formatCountdown(nextTime.difference(now)));
      await HomeWidget.saveWidgetData<String>('city', state.cityName);
      await HomeWidget.updateWidget(
        name: _providerName,
        androidName: _providerName,
        qualifiedAndroidName: _qualifiedName,
      );
    } catch (_) {
      // The widget must never break the app.
    }
  }
}
