// Standard 30 juz start points: (surah number, ayah number) where each juz begins.
// Juz 30 ends at Surah 114, Ayah 6.
import '../models/models.dart';

class JuzInfo {
  final int number;
  final int startSurah;
  final int startAyah;
  final int endSurah;
  final int endAyah;
  const JuzInfo({
    required this.number,
    required this.startSurah,
    required this.startAyah,
    required this.endSurah,
    required this.endAyah,
  });
}

const List<(int, int)> _juzStarts = [
  (1, 1), // 1
  (2, 142), // 2
  (2, 253), // 3
  (3, 93), // 4
  (4, 24), // 5
  (4, 148), // 6
  (5, 82), // 7
  (6, 111), // 8
  (7, 88), // 9
  (8, 41), // 10
  (9, 93), // 11
  (11, 6), // 12
  (12, 53), // 13
  (15, 1), // 14
  (17, 1), // 15
  (18, 75), // 16
  (21, 1), // 17
  (23, 1), // 18
  (25, 21), // 19
  (27, 56), // 20
  (29, 46), // 21
  (33, 31), // 22
  (36, 28), // 23
  (39, 32), // 24
  (41, 47), // 25
  (46, 1), // 26
  (51, 31), // 27
  (58, 1), // 28
  (67, 1), // 29
  (78, 1), // 30
];

/// Builds the 30 juz with end ranges computed from the next juz start
/// (or Surah 114 Ayah 6 for the last juz). [surahAyahCounts] maps surah
/// number -> ayah count.
List<JuzInfo> buildJuzList(Map<int, int> surahAyahCounts) {
  final out = <JuzInfo>[];
  for (var i = 0; i < 30; i++) {
    final (sSurah, sAyah) = _juzStarts[i];
    int eSurah;
    int eAyah;
    if (i < 29) {
      final (nSurah, nAyah) = _juzStarts[i + 1];
      if (nAyah == 1) {
        eSurah = nSurah - 1;
        eAyah = surahAyahCounts[eSurah] ?? 1;
      } else {
        eSurah = nSurah;
        eAyah = nAyah - 1;
      }
    } else {
      eSurah = 114;
      eAyah = surahAyahCounts[114] ?? 6;
    }
    out.add(JuzInfo(
      number: i + 1,
      startSurah: sSurah,
      startAyah: sAyah,
      endSurah: eSurah,
      endAyah: eAyah,
    ));
  }
  return out;
}

String juzRangeText(JuzInfo j, List<Surah> surahs) {
  String name(int n) =>
      surahs.firstWhere((s) => s.number == n, orElse: () => surahs.first).englishName;
  if (j.startSurah == j.endSurah) {
    return '${name(j.startSurah)} ${j.startAyah}–${j.endAyah}';
  }
  return '${name(j.startSurah)} ${j.startAyah} – ${name(j.endSurah)} ${j.endAyah}';
}
