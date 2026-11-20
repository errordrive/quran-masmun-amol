// Azan notifications (v2.0, auto-reschedule v3.2): local notifications
// fired at the 5 daily prayer times, using the app's own on-device
// prayer-time calculation (same source as the Prayer tab: selected city
// + method). No server, no Firebase — everything is scheduled on the
// device.
//
// - Schedules today + tomorrow on app start (and whenever azan settings,
//   city or method change). After a phone restart, the native
//   BootReceiver runs the `bootReschedule` Dart entrypoint, which
//   re-schedules everything with no UI — the user never has to open
//   the app. TIME_SET / TIMEZONE_CHANGED re-schedule the same way.
// - Sound: the bundled real azan recording (android/.../res/raw/azan.mp3)
//   when AppState.azanSoundEnabled is on, otherwise the default sound.
//   Android fixes a channel's sound at creation time, so the azan sound
//   uses its own channel ('azan_sound_channel'); the pre-existing
//   'azan_channel' (created with the default sound) is kept for the
//   sound-off case, so both paths work on fresh and existing installs.
// - Android 13+ POST_NOTIFICATIONS and exact-alarm permission are
//   requested; if exact alarms are denied, scheduling falls back to
//   inexact mode instead of crashing. Sunrise is never notified:
//   scheduleAll iterates DayPrayerTimes.prayers (Fajr, Dhuhr, Asr,
//   Maghrib, Isha) only — Sunrise is not in that list.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'app_state.dart';
import 'prayer.dart';

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

  /// Whether exact alarms can be scheduled (Android 12+). True on
  /// older Android (no such restriction) and on any error — callers
  /// treat "unknown" as "allowed" and let scheduling fall back.
  static Future<bool> canScheduleExactAlarms() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return true;
      return await android.canScheduleExactNotifications() ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Opens the system "Alarms & reminders" screen so the user can
  /// grant exact-alarm permission. No-op if already granted or
  /// unavailable on this device. Never throws.
  static Future<void> requestExactAlarms() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestExactAlarmsPermission();
    } catch (_) {}
  }

  /// Notification permission only (no exact-alarm prompt). Returns
  /// true if notifications are allowed. Never throws.
  static Future<bool> requestNotificationPermission() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return true;
      return await android.requestNotificationsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Fires a test azan notification ~5 seconds from now, using the
  /// same channel and sound as a real azan (sound toggle respected),
  /// so the user can verify the sound + notification without waiting
  /// for the next prayer. Uses id 999, far from the prayer ids
  /// (100..). Fires even if the master azan toggle is off — it is a
  /// manual sound test, not a prayer reminder. Never throws.
  static Future<void> scheduleTestAzan() async {
    try {
      await init();
      final state = AppState.instance;
      final soundOn = state.azanSoundEnabled;
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          soundOn ? 'azan_sound_channel' : 'azan_channel',
          'আজান নোটিফিকেশন',
          channelDescription: 'নামাজের সময়ের নোটিফিকেশন',
          importance: Importance.high,
          priority: Priority.high,
          sound: soundOn
              ? const RawResourceAndroidNotificationSound('azan')
              : null,
        ),
      );
      final when = tz.TZDateTime.now(tz.UTC).add(const Duration(seconds: 5));
      final title =
          state.isBangla ? 'আজান পরীক্ষা' : 'Azan test';
      final body = state.isBangla
          ? 'এটি একটি পরীক্ষামূলক আজান নোটিফিকেশন — শব্দ শুনতে পাচ্ছেন কি?'
          : 'This is a test azan notification — can you hear the sound?';
      try {
        await _plugin.zonedSchedule(
          999,
          title,
          body,
          when,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (_) {
        try {
          await _plugin.zonedSchedule(
            999,
            title,
            body,
            when,
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        } catch (_) {}
      }
    } catch (_) {}
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
          // Friday Dhuhr is labelled জুম'আ; the notification still
          // fires at the Dhuhr time. Sunrise is never in this list.
          final name = displayPrayerName(prayers[i].$1, t);
          final soundOn = state.azanSoundEnabled;
          final details = NotificationDetails(
            android: AndroidNotificationDetails(
              soundOn ? 'azan_sound_channel' : 'azan_channel',
              'আজান নোটিফিকেশন',
              channelDescription: 'নামাজের সময়ের নোটিফিকেশন',
              importance: Importance.high,
              priority: Priority.high,
              sound: soundOn
                  ? const RawResourceAndroidNotificationSound('azan')
                  : null,
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
