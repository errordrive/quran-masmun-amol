// Pure-Dart prayer-time calculation (PrayTimes-style solar algorithm).
// No network, no native plugins. Method angles follow the standard tables.
import 'dart:math';

import 'strings.dart';

enum PrayerMethod { karachi, mwl, isna, egypt, ummAlQura }

extension PrayerMethodInfo on PrayerMethod {
  String get label {
    switch (this) {
      case PrayerMethod.karachi:
        return 'Karachi (Univ. of Islamic Sciences)';
      case PrayerMethod.mwl:
        return 'Muslim World League';
      case PrayerMethod.isna:
        return 'ISNA (North America)';
      case PrayerMethod.egypt:
        return 'Egyptian General Authority';
      case PrayerMethod.ummAlQura:
        return 'Umm al-Qura (Makkah)';
    }
  }

  double get fajrAngle {
    switch (this) {
      case PrayerMethod.karachi:
        return 18;
      case PrayerMethod.mwl:
        return 18;
      case PrayerMethod.isna:
        return 15;
      case PrayerMethod.egypt:
        return 19.5;
      case PrayerMethod.ummAlQura:
        return 18.5;
    }
  }

  /// Isha angle in degrees, or null when Isha is a fixed interval after Maghrib.
  double? get ishaAngle {
    switch (this) {
      case PrayerMethod.karachi:
        return 18;
      case PrayerMethod.mwl:
        return 17;
      case PrayerMethod.isna:
        return 15;
      case PrayerMethod.egypt:
        return 17.5;
      case PrayerMethod.ummAlQura:
        return null;
    }
  }

  int get ishaMinutesAfterMaghrib => this == PrayerMethod.ummAlQura ? 90 : 0;
}

class DayPrayerTimes {
  final DateTime date;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  const DayPrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  List<(String, DateTime)> get ordered => [
        ('Fajr', fajr),
        ('Sunrise', sunrise),
        ('Dhuhr', dhuhr),
        ('Asr', asr),
        ('Maghrib', maghrib),
        ('Isha', isha),
      ];

  List<(String, DateTime)> get prayers => [
        ('Fajr', fajr),
        ('Dhuhr', dhuhr),
        ('Asr', asr),
        ('Maghrib', maghrib),
        ('Isha', isha),
      ];
}

double _fixAngle(double a) {
  a %= 360;
  if (a < 0) a += 360;
  return a;
}

double _fixHour(double h) {
  h %= 24;
  if (h < 0) h += 24;
  return h;
}

double _d2r(double d) => d * pi / 180;
double _r2d(double r) => r * 180 / pi;
double _clamp(double v) => v < -1 ? -1 : (v > 1 ? 1 : v);

double _julianDate(int y, int m, int d) {
  if (m <= 2) {
    y -= 1;
    m += 12;
  }
  final a = (y / 100).floor();
  final b = 2 - a + (a / 4).floor();
  return (365.25 * (y + 4716)).floor() +
      (30.6001 * (m + 1)).floor() +
      d +
      b -
      1524.5;
}

({double decl, double eqt}) _sunPosition(double jd) {
  final d = jd - 2451545.0;
  final g = _fixAngle(357.529 + 0.98560028 * d);
  final q = _fixAngle(280.459 + 0.98564736 * d);
  final l = _fixAngle(q + 1.915 * sin(_d2r(g)) + 0.020 * sin(_d2r(2 * g)));
  final e = 23.439 - 0.00000036 * d;
  final ra = _fixHour(_r2d(atan2(
          cos(_d2r(e)) * sin(_d2r(l)), cos(_d2r(l)))) /
      15);
  final decl = _r2d(asin(sin(_d2r(e)) * sin(_d2r(l))));
  final eqt = q / 15 - ra;
  return (decl: decl, eqt: eqt);
}

double _midDay(double jd) => _fixHour(12 - _sunPosition(jd).eqt);

double _sunAngleTime(double angle, double jd, double lat, {bool ccw = false}) {
  final pos = _sunPosition(jd);
  final noon = _midDay(jd);
  final t = (1 / 15) *
      _r2d(acos(_clamp((sin(_d2r(angle)) -
              sin(_d2r(pos.decl)) * sin(_d2r(lat))) /
          (cos(_d2r(pos.decl)) * cos(_d2r(lat))))));
  return noon + (ccw ? -t : t);
}

double _asrTime(double factor, double jd, double lat) {
  final decl = _sunPosition(jd).decl;
  // Asr altitude is ABOVE the horizon: arccot(factor + tan(|lat - decl|)).
  // (A negative sign here would put Asr after Maghrib — wrong.)
  final angle =
      _r2d(atan(1 / (factor + tan(_d2r((lat - decl).abs())))));
  return _sunAngleTime(angle, jd, lat);
}

DayPrayerTimes computePrayerTimes(
  DateTime date,
  double lat,
  double lon,
  double tzOffset, {
  PrayerMethod method = PrayerMethod.karachi,
  bool asrHanafi = false,
}) {
  final jd = _julianDate(date.year, date.month, date.day);

  // Two-pass refinement (second pass uses jd + time/24).
  Map<String, double> pass(double baseJd) {
    final fajr = _sunAngleTime(-method.fajrAngle, baseJd, lat, ccw: true);
    final sunrise = _sunAngleTime(-0.833, baseJd, lat, ccw: true);
    final dhuhr = _midDay(baseJd);
    final asr = _asrTime(asrHanafi ? 2 : 1, baseJd, lat);
    final maghrib = _sunAngleTime(-0.833, baseJd, lat);
    final isha = method.ishaAngle != null
        ? _sunAngleTime(-method.ishaAngle!, baseJd, lat)
        : maghrib + method.ishaMinutesAfterMaghrib / 60.0;
    return {
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
    };
  }

  final first = pass(jd);
  final refined = pass(jd + first['dhuhr']! / 24);

  DateTime toTime(double hours) {
    final adjusted = _fixHour(hours + tzOffset - lon / 15);
    final midnight = DateTime(date.year, date.month, date.day);
    return midnight.add(Duration(minutes: (adjusted * 60).round()));
  }

  return DayPrayerTimes(
    date: DateTime(date.year, date.month, date.day),
    fajr: toTime(refined['fajr']!),
    sunrise: toTime(refined['sunrise']!),
    dhuhr: toTime(refined['dhuhr']!),
    asr: toTime(refined['asr']!),
    maghrib: toTime(refined['maghrib']!),
    isha: toTime(refined['isha']!),
  );
}

// ---------------- Hijri date (Kuwaiti algorithm, approximate) ----------------

const List<String> hijriMonthNames = [
  'Muharram',
  'Safar',
  'Rabi al-Awwal',
  'Rabi al-Thani',
  'Jumada al-Ula',
  'Jumada al-Akhirah',
  'Rajab',
  "Sha'ban",
  'Ramadan',
  'Shawwal',
  "Dhul-Qa'dah",
  'Dhul-Hijjah',
];

({int year, int month, int day}) hijriFromGregorian(DateTime date) {
  final jd = _julianDate(date.year, date.month, date.day).floor();
  var l = jd - 1948440 + 10632;
  final n = ((l - 1) / 10631).floor();
  l = l - 10631 * n + 354;
  final j = (((10985 - l) / 5316).floor()) * (((50 * l) / 17719).floor()) +
      ((l / 5670).floor()) * (((43 * l) / 15238).floor());
  l = l -
      (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
      ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
      29;
  final month = ((24 * l) / 709).floor();
  final day = l - ((709 * month) / 24).floor();
  final year = 30 * n + j - 30;
  return (year: year, month: month, day: day);
}

String hijriDateString(DateTime date) {
  final h = hijriFromGregorian(date);
  return '${h.day} ${hijriMonthNames[h.month - 1]} ${h.year} AH (approx.)';
}

/// Hijri month names in Arabic script, index 0 = Muharram.
const List<String> hijriMonthNamesArabic = [
  'محرم',
  'صفر',
  'ربيع الأول',
  'ربيع الثاني',
  'جمادى الأولى',
  'جمادى الآخرة',
  'رجب',
  'شعبان',
  'رمضان',
  'شوال',
  'ذو القعدة',
  'ذو الحجة',
];

/// Hijri date with the Arabic month name, e.g. "17 جمادى الأولى 1447".
String hijriDateStringArabic(DateTime date) {
  final h = hijriFromGregorian(date);
  return '${h.day} ${hijriMonthNamesArabic[h.month - 1]} ${h.year}';
}

/// Display name for a prayer on a given [date]: 'জুম'আ' when the prayer
/// is Dhuhr on a Friday, otherwise [prayerName] (Bangla in Bangla mode,
/// English otherwise). The azan for that slot still fires at Dhuhr time.
String displayPrayerName(String english, DateTime date) {
  if (english == 'Dhuhr' && date.weekday == DateTime.friday) {
    return 'জুম\'আ';
  }
  return prayerName(english);
}

// ---------------- Formatting helpers (no intl dependency) ----------------

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

String gregorianDateString(DateTime date) =>
    '${_weekdayNames[date.weekday - 1]}, ${date.day} ${_monthNames[date.month - 1]} ${date.year}';

String formatTime(DateTime t, {bool use24h = false}) {
  if (use24h) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
  final h12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final m = t.minute.toString().padLeft(2, '0');
  final ap = t.hour < 12 ? 'AM' : 'PM';
  return '$h12:$m $ap';
}

String formatCountdown(Duration d) {
  if (d.isNegative) d = Duration.zero;
  final h = d.inHours.toString().padLeft(2, '0');
  final m = (d.inMinutes % 60).toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

/// Returns (current prayer name, next prayer name, next prayer time) for [now].
(String, String, DateTime) currentAndNextPrayer(
    DayPrayerTimes today, DayPrayerTimes tomorrow, DateTime now) {
  final prayers = today.prayers;
  String current = 'Isha';
  for (var i = 0; i < prayers.length; i++) {
    if (!now.isBefore(prayers[i].$2)) {
      current = prayers[i].$1;
    }
  }
  for (var i = 0; i < prayers.length; i++) {
    if (now.isBefore(prayers[i].$2)) {
      return (current, prayers[i].$1, prayers[i].$2);
    }
  }
  return (current, 'Fajr', tomorrow.fajr);
}
