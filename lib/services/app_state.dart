// App-wide state: settings, credits, favorites, bookmarks, tasbih counts.
// Everything is persisted locally with SharedPreferences. No account, no
// network: Google sign-in and Play Billing are wired later (see README).
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cities.dart';
import '../data/duas.dart';
import '../data/hadith.dart';
import '../data/surah_ayah_counts.dart';
import '../models/models.dart';
import 'prayer.dart';

String dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  late SharedPreferences _prefs;
  bool _ready = false;
  bool get ready => _ready;

  // ---- Settings ----
  ThemeMode themeMode = ThemeMode.system;
  double arabicSize = 24;
  bool showTranslation = true;
  String translationLang = 'bn'; // 'bn' | 'en' — Bangla is the default
  String uiLang = 'bn'; // 'bn' | 'en' — Bangla UI by default
  bool use24h = false; // false = 12-hour (AM/PM), the default
  PrayerMethod prayerMethod = PrayerMethod.karachi;
  bool asrHanafi = false;
  bool vibrationOn = true;
  // 3D tasbih bead color (v3.1): 'black' | 'green' | 'amber' | 'white'.
  String beadColor = 'black';
  String cityName = 'Dhaka';

  // ---- Azan notifications (v2.0) ----
  bool azanEnabled = true; // master toggle
  // Per-prayer toggles, index 0..4 = Fajr, Dhuhr, Asr, Maghrib, Isha.
  final List<bool> azanPrayers = [true, true, true, true, true];
  bool azanPermAsked = false; // notification permission asked once
  // Real azan sound for notifications (true = azan.mp3, false = default).
  bool azanSoundEnabled = true;

  // ---- Khatam tracker (v2.0) ----
  final Set<int> readSurahs = {}; // surah numbers marked as read
  int khatamDailyGoal = 20; // ayahs per day

  // ---- Local account data (guest) ----
  int credits = 0;
  final Set<String> favoriteDuas = {};
  final Set<String> favoriteHadiths = {}; // "collection|number"
  final Set<String> bookmarks = {}; // "surah:ayah"
  final Map<String, int> tasbihCounts = {}; // tasbih id -> count
  final List<TasbihItem> customTasbihs = [];
  final List<PurchaseRecord> purchases = [];
  // Per-date prayer marks: dateKey -> set of prayer indices 0..4 (Fajr..Isha).
  final Map<String, Set<int>> prayerMarks = {};
  // Per-date tasbih totals: dateKey -> total taps that day.
  final Map<String, int> tasbihDaily = {};

  // Last read position
  int lastSurah = 0;
  int lastAyah = 0;

  City get city => cityByName(cityName);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final theme = _prefs.getString('theme') ?? 'system';
    themeMode = theme == 'light'
        ? ThemeMode.light
        : theme == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
    arabicSize = _prefs.getDouble('arabicSize') ?? 24;
    showTranslation = _prefs.getBool('showTranslation') ?? true;
    translationLang = _prefs.getString('translationLang') ?? 'bn';
    uiLang = _prefs.getString('uiLang') ?? 'bn';
    use24h = _prefs.getBool('use24h') ?? false;
    prayerMethod = PrayerMethod.values[_prefs.getInt('prayerMethod') ?? 0];
    asrHanafi = _prefs.getBool('asrHanafi') ?? false;
    vibrationOn = _prefs.getBool('vibrationOn') ?? true;
    beadColor = _prefs.getString('beadColor') ?? 'black';
    cityName = _prefs.getString('city') ?? 'Dhaka';
    azanEnabled = _prefs.getBool('azanEnabled') ?? true;
    azanPermAsked = _prefs.getBool('azanPermAsked') ?? false;
    azanSoundEnabled = _prefs.getBool('azanSoundEnabled') ?? true;
    final azanList = _prefs.getStringList('azanPrayers');
    if (azanList != null && azanList.length == 5) {
      for (var i = 0; i < 5; i++) {
        azanPrayers[i] = azanList[i] == '1';
      }
    }
    readSurahs.addAll((_prefs.getStringList('readSurahs') ?? const [])
        .map((e) => int.tryParse(e) ?? -1)
        .where((n) => n >= 1 && n <= 114));
    khatamDailyGoal = _prefs.getInt('khatamDailyGoal') ?? 20;
    credits = _prefs.getInt('credits') ?? 0;
    favoriteDuas.addAll(_prefs.getStringList('favoriteDuas') ?? const []);
    favoriteHadiths.addAll(_prefs.getStringList('favoriteHadiths') ?? const []);
    bookmarks.addAll(_prefs.getStringList('bookmarks') ?? const []);
    for (final e in (_prefs.getStringList('tasbihCounts') ?? const [])) {
      final parts = e.split(':');
      if (parts.length == 2) {
        tasbihCounts[parts[0]] = int.tryParse(parts[1]) ?? 0;
      }
    }
    for (final raw in (_prefs.getStringList('customTasbihs') ?? const [])) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        customTasbihs.add(TasbihItem(
          id: j['id'] as String,
          arabicName: j['arabicName'] as String,
          englishName: j['englishName'] as String,
          target: j['target'] as int,
          custom: true,
        ));
      } catch (_) {}
    }
    for (final raw in (_prefs.getStringList('purchases') ?? const [])) {
      try {
        purchases.add(PurchaseRecord.fromJson(jsonDecode(raw)));
      } catch (_) {}
    }
    lastSurah = _prefs.getInt('lastSurah') ?? 0;
    lastAyah = _prefs.getInt('lastAyah') ?? 0;
    for (final e in (_prefs.getStringList('prayerMarks') ?? const [])) {
      final parts = e.split(':');
      if (parts.length == 2 && parts[1].isNotEmpty) {
        prayerMarks[parts[0]] = parts[1]
            .split(',')
            .map((x) => int.tryParse(x) ?? -1)
            .where((x) => x >= 0 && x < 5)
            .toSet();
      }
    }
    for (final e in (_prefs.getStringList('tasbihDaily') ?? const [])) {
      final parts = e.split(':');
      if (parts.length == 2) {
        tasbihDaily[parts[0]] = int.tryParse(parts[1]) ?? 0;
      }
    }
    _ready = true;
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs.setString(
        'theme',
        themeMode == ThemeMode.light
            ? 'light'
            : themeMode == ThemeMode.dark
                ? 'dark'
                : 'system');
    await _prefs.setDouble('arabicSize', arabicSize);
    await _prefs.setBool('showTranslation', showTranslation);
    await _prefs.setString('translationLang', translationLang);
    await _prefs.setString('uiLang', uiLang);
    await _prefs.setBool('use24h', use24h);
    await _prefs.setInt('prayerMethod', prayerMethod.index);
    await _prefs.setBool('asrHanafi', asrHanafi);
    await _prefs.setBool('vibrationOn', vibrationOn);
    await _prefs.setString('beadColor', beadColor);
    await _prefs.setString('city', cityName);
    await _prefs.setBool('azanEnabled', azanEnabled);
    await _prefs.setBool('azanPermAsked', azanPermAsked);
    await _prefs.setBool('azanSoundEnabled', azanSoundEnabled);
    await _prefs.setStringList('azanPrayers',
        azanPrayers.map((v) => v ? '1' : '0').toList());
    await _prefs.setStringList(
        'readSurahs', readSurahs.map((n) => '$n').toList());
    await _prefs.setInt('khatamDailyGoal', khatamDailyGoal);
    await _prefs.setInt('credits', credits);
    await _prefs.setStringList('favoriteDuas', favoriteDuas.toList());
    await _prefs.setStringList('favoriteHadiths', favoriteHadiths.toList());
    await _prefs.setStringList('bookmarks', bookmarks.toList());
    await _prefs.setStringList('tasbihCounts',
        tasbihCounts.entries.map((e) => '${e.key}:${e.value}').toList());
    await _prefs.setStringList(
        'customTasbihs',
        customTasbihs
            .map((t) => jsonEncode({
                  'id': t.id,
                  'arabicName': t.arabicName,
                  'englishName': t.englishName,
                  'target': t.target,
                }))
            .toList());
    await _prefs.setStringList(
        'purchases', purchases.map((p) => jsonEncode(p.toJson())).toList());
    await _prefs.setInt('lastSurah', lastSurah);
    await _prefs.setInt('lastAyah', lastAyah);
    await _prefs.setStringList(
        'prayerMarks',
        prayerMarks.entries
            .map((e) => '${e.key}:${e.value.join(',')}')
            .toList());
    await _prefs.setStringList('tasbihDaily',
        tasbihDaily.entries.map((e) => '${e.key}:${e.value}').toList());
  }

  // ---- Settings setters ----
  void setThemeMode(ThemeMode m) {
    themeMode = m;
    _save();
    notifyListeners();
  }

  void setArabicSize(double s) {
    arabicSize = s;
    _save();
    notifyListeners();
  }

  void setShowTranslation(bool v) {
    showTranslation = v;
    _save();
    notifyListeners();
  }

  void setTranslationLang(String lang) {
    translationLang = lang;
    showTranslation = true;
    _save();
    notifyListeners();
  }

  void setUiLang(String lang) {
    uiLang = lang;
    _save();
    notifyListeners();
  }

  bool get isBangla => uiLang == 'bn';

  void setUse24h(bool v) {
    use24h = v;
    _save();
    notifyListeners();
  }

  void setPrayerMethod(PrayerMethod m) {
    prayerMethod = m;
    _save();
    notifyListeners();
  }

  void setAsrHanafi(bool v) {
    asrHanafi = v;
    _save();
    notifyListeners();
  }

  void setVibration(bool v) {
    vibrationOn = v;
    _save();
    notifyListeners();
  }

  void setBeadColor(String color) {
    beadColor = color;
    _save();
    notifyListeners();
  }

  void setCity(String name) {
    cityName = name;
    _save();
    notifyListeners();
  }

  // ---- Azan notifications (v2.0) ----
  bool azanFor(int index) =>
      azanEnabled && index >= 0 && index < 5 && azanPrayers[index];

  void setAzanEnabled(bool v) {
    azanEnabled = v;
    _save();
    notifyListeners();
  }

  void setAzanPrayer(int index, bool v) {
    if (index < 0 || index >= 5) return;
    azanPrayers[index] = v;
    _save();
    notifyListeners();
  }

  void markAzanPermAsked() {
    azanPermAsked = true;
    _save();
  }

  /// Real azan sound on/off for azan notifications. The Settings toggle
  /// (added by the other builder) binds to this.
  Future<void> setAzanSoundEnabled(bool v) async {
    azanSoundEnabled = v;
    await _save();
    notifyListeners();
  }

  // ---- Khatam tracker (v2.0) ----
  bool isSurahRead(int surahNumber) => readSurahs.contains(surahNumber);

  void toggleSurahRead(int surahNumber) {
    if (readSurahs.contains(surahNumber)) {
      readSurahs.remove(surahNumber);
    } else {
      readSurahs.add(surahNumber);
    }
    _save();
    notifyListeners();
  }

  int khatamReadAyahs() {
    var total = 0;
    for (final n in readSurahs) {
      total += ayahsInSurah(n);
    }
    return total;
  }

  void setKhatamDailyGoal(int goal) {
    khatamDailyGoal = goal;
    _save();
    notifyListeners();
  }

  // ---- Favorites / bookmarks ----
  void toggleFavoriteDua(String id) {
    if (favoriteDuas.contains(id)) {
      favoriteDuas.remove(id);
    } else {
      favoriteDuas.add(id);
    }
    _save();
    notifyListeners();
  }

  void toggleFavoriteHadith(String key) {
    if (favoriteHadiths.contains(key)) {
      favoriteHadiths.remove(key);
    } else {
      favoriteHadiths.add(key);
    }
    _save();
    notifyListeners();
  }

  void toggleBookmark(int surah, int ayah) {
    final key = '$surah:$ayah';
    if (bookmarks.contains(key)) {
      bookmarks.remove(key);
    } else {
      bookmarks.add(key);
    }
    _save();
    notifyListeners();
  }

  bool isBookmarked(int surah, int ayah) => bookmarks.contains('$surah:$ayah');

  // ---- Last read ----
  void saveLastRead(int surah, int ayah) {
    lastSurah = surah;
    lastAyah = ayah;
    _save();
    notifyListeners();
  }

  // ---- Tasbih ----
  int tasbihCount(String id) => tasbihCounts[id] ?? 0;

  void setTasbihCount(String id, int count) {
    tasbihCounts[id] = count;
    _save();
    notifyListeners();
  }

  void resetTasbih(String id) {
    tasbihCounts[id] = 0;
    _save();
    notifyListeners();
  }

  void addCustomTasbih(String arabicName, String englishName, int target) {
    customTasbihs.add(TasbihItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      arabicName: arabicName,
      englishName: englishName,
      target: target,
      custom: true,
    ));
    _save();
    notifyListeners();
  }

  void removeCustomTasbih(String id) {
    customTasbihs.removeWhere((t) => t.id == id);
    tasbihCounts.remove(id);
    _save();
    notifyListeners();
  }

  // ---- Namaz tracker ----
  bool isPrayerMarked(DateTime date, int index) =>
      prayerMarks[dateKey(date)]?.contains(index) ?? false;

  int prayerMarkCount(DateTime date) =>
      prayerMarks[dateKey(date)]?.length ?? 0;

  void togglePrayerMark(DateTime date, int index) {
    final key = dateKey(date);
    final set = prayerMarks.putIfAbsent(key, () => <int>{});
    if (set.contains(index)) {
      set.remove(index);
    } else {
      set.add(index);
    }
    _save();
    notifyListeners();
  }

  /// Counts for the last 7 days, oldest first.
  List<({DateTime date, int count})> last7PrayerCounts([DateTime? today]) {
    final now = today ?? DateTime.now();
    final out = <({DateTime date, int count})>[];
    for (var i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      out.add((date: d, count: prayerMarkCount(d)));
    }
    return out;
  }

  // ---- Tasbih history + streak ----
  void recordTasbihTap() {
    final key = dateKey(DateTime.now());
    tasbihDaily[key] = (tasbihDaily[key] ?? 0) + 1;
    _save();
    notifyListeners();
  }

  int tasbihTodayTotal([DateTime? date]) =>
      tasbihDaily[dateKey(date ?? DateTime.now())] ?? 0;

  /// Consecutive days with at least 1 tasbih, ending today (or yesterday
  /// if nothing has been counted today yet).
  int tasbihStreak() {
    var streak = 0;
    var d = DateTime.now();
    if (tasbihTodayTotal(d) == 0) {
      d = d.subtract(const Duration(days: 1));
    }
    while (tasbihTodayTotal(d) > 0) {
      streak++;
      d = d.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Totals for the last 7 days, oldest first.
  List<({DateTime date, int count})> last7TasbihTotals() {
    final now = DateTime.now();
    final out = <({DateTime date, int count})>[];
    for (var i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      out.add((date: d, count: tasbihTodayTotal(d)));
    }
    return out;
  }

  // ---- Credits (demo mode: local only until Play Billing is wired) ----
  void addCredits(CreditPackage pkg) {
    credits += pkg.credits;
    purchases.add(PurchaseRecord(
      packageName: pkg.name,
      credits: pkg.credits,
      priceText: pkg.priceText,
      date: DateTime.now(),
      status: 'Completed (Demo)',
    ));
    _save();
    notifyListeners();
  }

  // ---- Daily Dua (v1.2): a different dua every day, picked by a
  // date-seeded pseudo-random draw — same dua all day, a random-feeling
  // (never sequential) one each day, fully offline and deterministic
  // for a given date. Seed: year * 372 + month * 31 + day.
  Dua dailyDua([DateTime? date]) {
    final d = date ?? DateTime.now();
    final seed = d.year * 372 + d.month * 31 + d.day;
    return duas[Random(seed).nextInt(duas.length)];
  }

  /// Daily Hadith (v2.0): same date-seeded random pattern as the daily
  /// dua — same hadith all day, a different random-feeling one each
  /// day, from the bundled 48 hadiths, fully offline.
  Hadith dailyHadith([DateTime? date]) {
    final d = date ?? DateTime.now();
    final seed = d.year * 372 + d.month * 31 + d.day;
    return hadiths[Random(seed).nextInt(hadiths.length)];
  }

  DayPrayerTimes prayerTimesFor(DateTime date) => computePrayerTimes(
        date,
        city.lat,
        city.lon,
        city.tzOffset,
        method: prayerMethod,
        asrHanafi: asrHanafi,
      );
}
