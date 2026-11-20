// Home tab (v3.0 redesign, reference layout): location row + search,
// Hijri/Gregorian date header, Next Prayer hero, prayer strip,
// Jumu'ah card on Fridays, 3-column category grid (incl. the 3 new
// v3.0 tiles), Daily Dua + Daily Hadith cards, Khatam progress.
// v1.1: Bangla by default. v1.2: daily dua is date-seeded random.
import 'dart:async';
import 'package:flutter/material.dart';
import '../data/duas.dart';
import '../data/hadith.dart';
import '../data/surah_ayah_counts.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/navigation.dart';
import '../services/prayer.dart';
import '../services/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/date_header.dart';
import 'content.dart';
import 'events.dart';
import 'khatam.dart';
import 'knowledge.dart';
import 'quran.dart';
import 'stories.dart';
import 'zakat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final now = DateTime.now();
    final today = state.prayerTimesFor(now);
    final tomorrow = state.prayerTimesFor(now.add(const Duration(days: 1)));
    final (_, next, nextTime) = currentAndNextPrayer(today, tomorrow, now);
    final countdown = nextTime.difference(now);
    final dailyDua = state.dailyDua(now);
    final dailyHadith = state.dailyHadith(now);
    final isFriday = now.weekday == DateTime.friday;

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          color: primaryGreen,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              // Location row + avatar (reference layout).
              Row(
                children: [
                  InkWell(
                    onTap: () => showLocationPicker(context),
                    borderRadius: BorderRadius.circular(24),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on,
                            size: 20, color: primaryGreen),
                        const SizedBox(width: 4),
                        Text(state.cityName,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700)),
                        const Icon(Icons.keyboard_arrow_down,
                            size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TonalIconButton(
                    icon: Icons.person,
                    tooltip: tr('tab_me'),
                    onPressed: () => goToTab(2),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Search bar (wired to the existing search screen).
              InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color:
                            Theme.of(context).dividerColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(tr('search_hint'),
                            style: TextStyle(color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Hijri + Gregorian date header (v3.0, other builder).
              const DateHeader(),
              const SizedBox(height: 16),
              // Next Prayer hero card.
              NextPrayerHero(
                prayerEnglish: next,
                prayerDate: nextTime,
                time: nextTime,
                countdown: countdown,
                cityName: state.cityName,
                onTap: () => goToTab(1),
              ),
              const SizedBox(height: 12),
              // Prayer strip (Fajr..Isha + Sunrise).
              PrayerStrip(
                times: today,
                nextEnglish: next,
                date: now,
                onTap: () => goToTab(1),
              ),
              // Jumu'ah reminder, Fridays only (v3.0).
              if (isFriday) ...[
                const SizedBox(height: 16),
                _JumuahCard(onTap: () => goToTab(1)),
              ],
              const SizedBox(height: 28),
              SectionTitle(title: tr('categories')),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.92,
                children: [
                  CategoryTile(
                    icon: Icons.menu_book,
                    label: tr('cat_quran'),
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const QuranListScreen()),
                    ),
                  ),
                  CategoryTile(
                    icon: Icons.auto_stories,
                    label: tr('cat_hadith'),
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const HadithCollectionScreen()),
                    ),
                  ),
                  CategoryTile(
                    icon: Icons.volunteer_activism,
                    label: AppState.instance.isBangla ? 'দুয়া' : 'Dua',
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: tr('cat_daily_dua'),
                              duas: duas,
                              subtitle: tr('all_duas'))),
                    ),
                  ),
                  CategoryTile(
                    icon: Icons.fingerprint,
                    label: tr('cat_tasbih'),
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const TasbihListScreen()),
                    ),
                  ),
                  CategoryTile(
                    icon: Icons.handshake,
                    label: AppState.instance.isBangla
                        ? 'মাসনুন আমল'
                        : 'Masnun Amol',
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: tr('cat_masnun'),
                              duas: duasByCategory('daily'),
                              subtitle: tr('daily_sub'))),
                    ),
                  ),
                  CategoryTile(
                    icon: Icons.auto_awesome,
                    label: AppState.instance.isBangla
                        ? 'আসমাউল হুসনা'
                        : 'Asma ul Husna',
                    badge: AppState.instance.isBangla ? '৯৯' : '99',
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const AsmaulHusnaScreen()),
                    ),
                  ),
                  // ---- v3.0 new tiles ----
                  CategoryTile(
                    icon: Icons.calculate,
                    label: AppState.instance.isBangla
                        ? 'যাকাত ক্যালকুলেটর'
                        : 'Zakat Calculator',
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const ZakatCalculatorScreen()),
                    ),
                  ),
                  CategoryTile(
                    icon: Icons.lightbulb,
                    label: AppState.instance.isBangla
                        ? 'ইসলামিক জ্ঞান'
                        : 'Islamic Knowledge',
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const IslamicKnowledgeScreen()),
                    ),
                  ),
                  CategoryTile(
                    icon: Icons.menu_book_outlined,
                    label: AppState.instance.isBangla
                        ? 'নবীদের গল্প'
                        : 'Stories of Prophets',
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const ProphetStoriesScreen()),
                    ),
                  ),
                  CategoryTile(
                    icon: Icons.calendar_month,
                    label: tr('cat_events'),
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const IslamicEventsScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SectionTitle(
                title: tr('daily_dua'),
                action: TextButton(
                  onPressed: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (_) => CategoryListScreen(
                            title: tr('cat_daily_dua'),
                            duas: duas,
                            subtitle: tr('all_duas'))),
                  ),
                  child: Text(tr('see_all')),
                ),
              ),
              const SizedBox(height: 12),
              DailyDuaCard(dua: dailyDua),
              const SizedBox(height: 28),
              SectionTitle(
                title: tr('daily_hadith'),
                action: TextButton(
                  onPressed: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (_) => const HadithCollectionScreen()),
                  ),
                  child: Text(tr('see_all')),
                ),
              ),
              const SizedBox(height: 12),
              DailyHadithCard(hadith: dailyHadith),
              const SizedBox(height: 28),
              const KhatamProgressCard(),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- Jumu'ah reminder card (v3.0, Fridays only) ----------------

class _JumuahCard extends StatelessWidget {
  final VoidCallback onTap;
  const _JumuahCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: greenHeroDecoration(),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.mosque, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bn ? "জুম'আর দিন" : "Jumu'ah Day",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bn
                        ? 'আজ পবিত্র জুম\'আর দিন। সূরা কাহফ তিলাওয়াত করুন, বেশি বেশি দরুদ শরীফ পাঠ করুন এবং জুম\'আর নামাজের জন্য প্রস্তুতি নিন।'
                        : 'Today is blessed Jumu\'ah. Recite Surah Al-Kahf, send abundant salawat upon the Prophet, and prepare for the Jumu\'ah prayer.',
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyDuaCard extends StatelessWidget {
  final Dua dua;
  const DailyDuaCard({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final bn = state.isBangla;
    final title = bn ? dua.banglaTitle : dua.title;
    final meaning = bn ? dua.banglaMeaning : dua.meaning;
    final fav = state.favoriteDuas.contains(dua.id);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.volunteer_activism,
                      color: primaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w800)),
                ),
                TonalIconButton(
                  icon: fav ? Icons.favorite : Icons.favorite_border,
                  filled: fav,
                  tooltip: tr('favorite'),
                  onPressed: () => state.toggleFavoriteDua(dua.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(dua.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: state.arabicSize, height: 1.9)),
            const SizedBox(height: 12),
            Text(dua.transliteration,
                style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(meaning, style: const TextStyle(fontSize: 15, height: 1.6)),
            const SizedBox(height: 4),
            Text(dua.reference,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            CopyShareRow(
              onCopy: () =>
                  copyText(context, '${dua.arabic}\n$meaning', title),
              onShare: () =>
                  shareText(context, '$title\n${dua.arabic}\n$meaning'),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: tr('open'),
              icon: Icons.arrow_forward,
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => DuaDetailScreen(dua: dua)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Daily Hadith card (v2.0) ----------------

class DailyHadithCard extends StatelessWidget {
  final Hadith hadith;
  const DailyHadithCard({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final bn = state.isBangla;
    final meaning = bn ? hadith.banglaMeaning : hadith.english;
    final fav =
        state.favoriteHadiths.contains('${hadith.collection}|${hadith.number}');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_stories, color: primaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('${hadith.collection} ${hadith.number}',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w800)),
                ),
                TonalIconButton(
                  icon: fav ? Icons.favorite : Icons.favorite_border,
                  filled: fav,
                  tooltip: tr('favorite'),
                  onPressed: () => state.toggleFavoriteHadith(
                      '${hadith.collection}|${hadith.number}'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(hadith.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style:
                    TextStyle(fontSize: state.arabicSize, height: 1.9)),
            const SizedBox(height: 12),
            Text(meaning, style: const TextStyle(fontSize: 15, height: 1.6)),
            const SizedBox(height: 4),
            Text('${tr('narrated_by')} ${hadith.narrator} · ${hadith.grade}',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            CopyShareRow(
              onCopy: () => copyText(
                  context,
                  '${hadith.arabic}\n$meaning\n(${hadith.collection} ${hadith.number})',
                  tr('hadith_word')),
              onShare: () => shareText(
                  context,
                  '${hadith.arabic}\n$meaning\n(${hadith.collection} ${hadith.number})'),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: tr('open'),
              icon: Icons.arrow_forward,
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (_) => HadithDetailScreen(hadith: hadith)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Khatam progress card (v2.0) ----------------

class KhatamProgressCard extends StatelessWidget {
  const KhatamProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final bn = state.isBangla;
        final read = state.khatamReadAyahs();
        final progress = read / totalQuranAyahs;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(Icons.checklist, color: primaryGreen),
                    ),
                    const SizedBox(width: 12),
                    Text(tr('khatam'),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text('${(progress * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
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
                    backgroundColor: primaryGreen.withOpacity(0.15),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(primaryGreen),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                    '$read / $totalQuranAyahs ${bn ? 'আয়াত পড়া হয়েছে' : 'ayahs read'}',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                TonalButton(
                  label: bn ? 'খতম ট্র্যাকার খুলুন' : 'Open Khatam Tracker',
                  icon: Icons.arrow_forward,
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (_) => const KhatamScreen()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
