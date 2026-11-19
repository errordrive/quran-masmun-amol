// Loads the bundled Quran JSON (assets/quran.json) once and caches it.
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class QuranService {
  static final QuranService instance = QuranService._();
  QuranService._();

  List<Surah>? _surahs;
  bool _failed = false;

  Future<List<Surah>> loadSurahs() async {
    if (_surahs != null) return _surahs!;
    if (_failed) return const [];
    try {
      final raw = await rootBundle.loadString('assets/quran.json');
      final decoded = jsonDecode(raw) as List;
      _surahs = decoded
          .map((e) => Surah.fromJson(e as Map<String, dynamic>))
          .toList();
      return _surahs!;
    } catch (_) {
      _failed = true;
      return const [];
    }
  }

  Surah? surahByNumber(List<Surah> surahs, int number) {
    for (final s in surahs) {
      if (s.number == number) return s;
    }
    return null;
  }

  // Bangla translations (assets/quran_bn.json), keyed "surah:ayah".
  Map<String, String>? _bangla;
  bool _banglaFailed = false;

  Future<Map<String, String>> loadBangla() async {
    if (_bangla != null) return _bangla!;
    if (_banglaFailed) return const {};
    try {
      final raw = await rootBundle.loadString('assets/quran_bn.json');
      final decoded = jsonDecode(raw) as List;
      final map = <String, String>{};
      for (final s in decoded) {
        final surahNo = (s as Map<String, dynamic>)['number'] as int;
        for (final a in s['ayahs'] as List) {
          final ayah = a as Map<String, dynamic>;
          map['$surahNo:${ayah['numberInSurah']}'] =
              ayah['translation'] as String;
        }
      }
      _bangla = map;
      return map;
    } catch (_) {
      _banglaFailed = true;
      return const {};
    }
  }

  List<Surah> searchSurahs(List<Surah> surahs, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return surahs;
    return surahs.where((s) {
      return s.englishName.toLowerCase().contains(q) ||
          s.englishNameTranslation.toLowerCase().contains(q) ||
          s.name.contains(query.trim()) ||
          s.number.toString() == q;
    }).toList();
  }
}
