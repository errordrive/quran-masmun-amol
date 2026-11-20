// Khatam tracker (v2.0): mark whole surahs as read, see total ayahs
// read / 6,236 with a progress bar, set a daily ayah goal and get an
// estimated completion date. Everything is stored locally in
// SharedPreferences (via AppState); the Home tab shows a small
// progress card too.
import 'package:flutter/material.dart';
import '../data/surah_ayah_counts.dart';
import '../data/surah_names_bn.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/quran_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'quran.dart';

class KhatamScreen extends StatefulWidget {
  const KhatamScreen({super.key});
  @override
  State<KhatamScreen> createState() => _KhatamScreenState();
}

class _KhatamScreenState extends State<KhatamScreen> {
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final bn = state.isBangla;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final read = state.khatamReadAyahs();
        final remaining = totalQuranAyahs - read;
        final progress = read / totalQuranAyahs;
        final goal = state.khatamDailyGoal;
        final daysLeft = remaining <= 0 ? 0 : (remaining / goal).ceil();
        final eta = DateTime.now().add(Duration(days: daysLeft));
        final etaText =
            '${eta.day}/${eta.month}/${eta.year}';
        return AppScaffold(
          appBar: AppBar(title: Text(bn ? 'খতম ট্র্যাকার' : 'Khatam Tracker')),
          body: FutureBuilder<List<Surah>>(
            future: QuranService.instance.loadSurahs(),
            builder: (context, snap) {
              final surahs = snap.data ?? const [];
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('$read',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: primaryGreen)),
                              Text(' / $totalQuranAyahs ${bn ? 'আয়াত' : 'ayahs'}',
                                  style: const TextStyle(fontSize: 16)),
                              const Spacer(),
                              Text('${(progress * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: primaryGreen)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor:
                                  primaryGreen.withOpacity(0.15),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  primaryGreen),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            remaining <= 0
                                ? (bn
                                    ? 'আলহামদুলিল্লাহ! খতম সম্পূর্ণ হয়েছে।'
                                    : 'Alhamdulillah! Khatam complete.')
                                : (bn
                                    ? 'বাকি $remaining আয়াত · প্রতিদিন $goal আয়াত পড়লে আনুমানিক শেষ: $etaText ($daysLeft দিন)'
                                    : '$remaining ayahs left · at $goal ayahs/day, estimated finish: $etaText ($daysLeft days)'),
                            style: const TextStyle(height: 1.6),
                          ),
                          const SizedBox(height: 16),
                          Text(bn ? 'প্রতিদিনের লক্ষ্য' : 'Daily goal',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [10, 20, 50, 100].map((g) {
                              final selected = goal == g;
                              return ChoiceChip(
                                label: Text('$g ${bn ? 'আয়াত' : 'ayahs'}'),
                                selected: selected,
                                selectedColor: primaryGreen,
                                labelStyle: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : null,
                                    fontWeight: FontWeight.w600),
                                onSelected: (_) =>
                                    state.setKhatamDailyGoal(g),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionTitle(
                      title: bn
                          ? 'সূরা ধরে ধরে চিহ্ন দিন'
                          : 'Mark surahs as read'),
                  const SizedBox(height: 8),
                  Text(
                    bn
                        ? 'যে সূরাটি পড়া শেষ হয়েছে, সেটিতে ট্যাপ করে চিহ্ন দিন।'
                        : 'Tap a surah you have finished reading to mark it.',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  if (surahs.isEmpty)
                    const LoadingState()
                  else
                    for (final s in surahs)
                      _SurahRow(
                        surahNumber: s.number,
                        arabicName: s.name,
                        read: state.isSurahRead(s.number),
                        onTap: () =>
                            state.toggleSurahRead(s.number),
                        onOpen: () => Navigator.of(context,
                                rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (_) => QuranReaderScreen(
                                    surah: s, surahs: surahs))),
                      ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _SurahRow extends StatelessWidget {
  final int surahNumber;
  final String arabicName;
  final bool read;
  final VoidCallback onTap;
  final VoidCallback onOpen;
  const _SurahRow({
    required this.surahNumber,
    required this.arabicName,
    required this.read,
    required this.onTap,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    final name = bn ? bnSurahName(surahNumber) : '';
    return Card(
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: read
                ? primaryGreen
                : primaryGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: read
              ? const Icon(Icons.check, color: Colors.white)
              : Text('$surahNumber',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: primaryGreen)),
        ),
        title: Text(
          name.isEmpty ? arabicName : name,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              decoration: read ? TextDecoration.lineThrough : null),
        ),
        subtitle: Text(
            '${ayahsInSurah(surahNumber)} ${bn ? 'আয়াত' : 'ayahs'} · $arabicName'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.menu_book_outlined),
              tooltip: bn ? 'পড়ুন' : 'Read',
              onPressed: onOpen,
            ),
            Checkbox(
              value: read,
              activeColor: primaryGreen,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
