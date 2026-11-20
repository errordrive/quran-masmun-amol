// Azan notifications (v2.0): local notifications fired at the 5 daily
// prayer times, using the app's own on-device prayer-time calculation
// (same source as the Prayer tab: selected city + method). No server,
// no Firebase — everything is scheduled on the device.
//
// - Schedules today + tomorrow on app start (and whenever azan settings,
//   city or method change); after a phone restart, opening the app once
//   re-schedules everything.
// - Sound: the default notification sound only. NO azan audio is bundled
//   (licensing risk) and none is downloaded.
// - Android 13+ POST_NOTIFICATIONS and exact-alarm permission are
//   requested; if exact alarms are denied, scheduling falls back to
//   inexact mode instead of crashing. Sunrise is never notified.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'app_state.dart';
import 'prayer.dart';
import 'strings.dart';

class AzanService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
    );
    _initialized = true;
  }

  /// Asks for notification permission (Android 13+) and, best-effort,
  /// exact-alarm permission. Returns true if notifications are allowed.
  /// Never throws.
  static Future<bool> requestPermissions() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return true;
      final granted =
          await android.requestNotificationsPermission() ?? false;
      // Exact alarms: best effort only — a denial just means the
      // fallback (inexact) scheduling below is used.
      try {
        await android.requestExactAlarmsPermission();
      } catch (_) {}
      return granted;
    } catch (_) {
      return false;
    }
  }

  /// (Re)schedules notifications for today + tomorrow. If the master
  /// toggle is off, all azan notifications are cancelled instead.
  static Future<void> scheduleAll() async {
    try {
      await init();
      final state = AppState.instance;
      await _plugin.cancelAll();
      if (!state.azanEnabled) return;
      final now = DateTime.now();
      for (var d = 0; d < 2; d++) {
        final day = now.add(Duration(days: d));
        final times = state.prayerTimesFor(day);
        final prayers = times.prayers; // Fajr, Dhuhr, Asr, Maghrib, Isha
        for (var i = 0; i < prayers.length; i++) {
          if (!state.azanFor(i)) continue;
          final t = prayers[i].$2;
          if (!t.isAfter(now)) continue;
          final name = prayerName(prayers[i].$1);
          final details = NotificationDetails(
            android: AndroidNotificationDetails(
              'azan_channel',
              'আজান নোটিফিকেশন',
              channelDescription: 'নামাজের সময়ের নোটিফিকেশন',
              importance: Importance.high,
              priority: Priority.high,
            ),
          );
          // Schedule by instant in UTC: tz.local defaults to UTC in the
          // timezone package unless a named zone is set, so converting
          // the device-local prayer time to its UTC instant is exact
          // regardless of the device zone.
          final when = tz.TZDateTime.from(t, tz.UTC);
          final id = 100 + i + d * 10;
          final title = '$name নামাজের সময় হয়েছে';
          final body =
              'এখন $name নামাজের সময় — ${formatTime(t, use24h: state.use24h)}';
          try {
            await _plugin.zonedSchedule(
              id,
              title,
              body,
              when,
              details,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
          } catch (_) {
            // Exact alarm denied on this device — fall back to inexact.
            try {
              await _plugin.zonedSchedule(
                id,
                title,
                body,
                when,
                details,
                androidScheduleMode:
                    AndroidScheduleMode.inexactAllowWhileIdle,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
              );
            } catch (_) {
              // Scheduling unavailable — skip silently, never crash.
            }
          }
        }
      }
    } catch (_) {
      // Notifications must never break the app.
    }
  }
}
