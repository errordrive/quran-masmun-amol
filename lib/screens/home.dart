// Home tab (v3.3 redesign, approved dark emerald preview): header
// with location + bell/settings, search, Hijri/Gregorian date chips,
// Next Prayer hero (mosque silhouette, live countdown, day-progress
// bar, azan pill), full prayer list, Jumu'ah card on Fridays, quick
// actions (Tasbih, Quran, Duas, Calendar, Qibla, Zakat), daily hadith
// gold card, and an "আরও" section for the remaining entry points
// (Azkar, Asmaul Husna, Khatam, Knowledge, Stories, Events, Fasting).
// v1.1: Bangla by default. v1.2: daily dua is date-seeded random.
import 'dart:async';
import 'package:flutter/material.dart';
import '../data/duas.dart';
import '../services/app_state.dart';
import '../services/navigation.dart';
import '../services/prayer.dart';
import '../services/strings.dart';
import '../widgets/common.dart';
import '../widgets/dark_ui.dart';
import 'content.dart';
import 'events.dart';
import 'khatam.dart';
import 'knowledge.dart';
import 'me.dart';
import 'month_calendar.dart';
import 'qibla.dart';
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

  void _openSettings() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _openSearch() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final now = DateTime.now();
    final today = state.prayerTimesFor(now);
    final yesterday =
        state.prayerTimesFor(now.subtract(const Duration(days: 1)));
    final tomorrow = state.prayerTimesFor(now.add(const Duration(days: 1)));
    final (_, next, nextTime) = currentAndNextPrayer(today, tomorrow, now);
    final countdown = nextTime.difference(now);
    final progress = prayerDayProgress(today, yesterday, tomorrow, now);
    final dailyHadith = state.dailyHadith(now);
    final isFriday = now.weekday == DateTime.friday;
    final bn = state.isBangla;

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          color: v33Green,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              // Header: location + bell/settings (preview .header).
              Row(
                children: [
                  InkWell(
                    onTap: () => showLocationPicker(context),
                    borderRadius: BorderRadius.circular(24),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: v33Green.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.location_on,
                              size: 18, color: v33GreenLight),
                        ),
                        const SizedBox(width: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(state.cityName,
                                    style: const TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w800,
                                        color: v33Text)),
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 18, color: v33Muted),
                              ],
                            ),
                            Text(
                              bn
                                  ? 'নামাজের সময় • বাংলাদেশ'
                                  : 'Prayer times • Bangladesh',
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF9DB8AD)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Bell: gold dot while azan is on; opens Settings
                  // (the azan notification settings live there).
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      V33RoundButton(
                        icon: Icons.notifications_outlined,
                        onTap: _openSettings,
                      ),
                      if (state.azanEnabled)
                        Positioned(
                          top: 7,
                          right: 8,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: v33GoldDeep,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: v33Background, width: 1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  V33RoundButton(
                    icon: Icons.settings_outlined,
                    onTap: _openSettings,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Search bar (real Quran search).
              V33SearchBar(
                hint: tr('search_hint'),
                onTap: _openSearch,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: v33Green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    bn ? 'সূরা • আয়াত' : 'Surah • Ayah',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: v33GreenLight),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Hijri + Gregorian date chips.
              V33DateChips(date: now),
              const SizedBox(height: 10),
              // Next Prayer hero.
              V33Hero(
                prayerEnglish: next,
                prayerDate: nextTime,
                time: nextTime,
                countdown: countdown,
                progress: progress,
                onTap: () => goToTab(1),
              ),
              const SizedBox(height: 10),
              // Full prayer list (bell + prayed checkbox per prayer).
              V33PrayerList(
                times: today,
                date: now,
                nextEnglish: next,
              ),
              // Jumu'ah reminder, Fridays only.
              if (isFriday) ...[
                const SizedBox(height: 10),
                _JumuahCard(onTap: () => goToTab(1)),
              ],
              const SizedBox(height: 11),
              // Quick actions (preview .quick): 6 items.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  V33QuickAction(
                    icon: Icons.fingerprint,
                    label: tr('tasbih'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const TasbihListScreen()),
                    ),
                  ),
                  V33QuickAction(
                    icon: Icons.menu_book,
                    label: tr('cat_quran'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const QuranListScreen()),
                    ),
                  ),
                  V33QuickAction(
                    icon: Icons.volunteer_activism,
                    label: tr('quick_duas'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: tr('cat_daily_dua'),
                              duas: duas,
                              subtitle: tr('all_duas'))),
                    ),
                  ),
                  V33QuickAction(
                    icon: Icons.calendar_month,
                    label: tr('quick_calendar'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const MonthlyCalendarScreen()),
                    ),
                  ),
                  V33QuickAction(
                    icon: Icons.explore,
                    label: tr('cat_qibla'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const QiblaScreen()),
                    ),
                  ),
                  V33QuickAction(
                    icon: Icons.calculate,
                    label: bn ? 'যাকাত' : 'Zakat',
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const ZakatCalculatorScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              // Daily hadith gold card (compact, preview .daily).
              InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => HadithDetailScreen(hadith: dailyHadith)),
                ),
                borderRadius: BorderRadius.circular(18),
                child: V33GoldCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      V33GoldLabel('✦ ${tr('daily_hadith')}'),
                      const SizedBox(height: 5),
                      Text(
                        bn ? dailyHadith.banglaMeaning : dailyHadith.english,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.45,
                            color: v33Text),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dailyHadith.collection} • ${dailyHadith.number} • ${tr('see_all')} →',
                        style: const TextStyle(
                            fontSize: 11.5, color: Color(0xFF9DB8AD)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // "আরও" — remaining entry points that have no quick
              // action: Azkar, Asmaul Husna, Khatam, Knowledge,
              // Stories, Events, Fasting.
              V33SectionLabel(tr('more_section')),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.35,
                children: [
                  _MoreTile(
                    icon: Icons.wb_sunny,
                    label: tr('azkar'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: tr('cat_morning'),
                              duas: duasByCategory('morning'),
                              subtitle: tr('morning_sub'))),
                    ),
                  ),
                  _MoreTile(
                    icon: Icons.auto_awesome,
                    label: tr('quick_names'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const AsmaulHusnaScreen()),
                    ),
                  ),
                  _MoreTile(
                    icon: Icons.checklist,
                    label: tr('quick_tracker'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const KhatamScreen()),
                    ),
                  ),
                  _MoreTile(
                    icon: Icons.lightbulb,
                    label: bn ? 'ইসলামিক জ্ঞান' : 'Islamic Knowledge',
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const IslamicKnowledgeScreen()),
                    ),
                  ),
                  _MoreTile(
                    icon: Icons.menu_book_outlined,
                    label: bn ? 'নবীদের গল্প' : 'Prophet Stories',
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const ProphetStoriesScreen()),
                    ),
                  ),
                  _MoreTile(
                    icon: Icons.calendar_month,
                    label: tr('cat_events'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const IslamicEventsScreen()),
                    ),
                  ),
                  _MoreTile(
                    icon: Icons.nightlight_round,
                    label: tr('quick_fasting'),
                    onTap: () => goToTab(1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- Jumu'ah reminder card (Fridays only) ----------------

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
        decoration: BoxDecoration(
          gradient: v33HeroGradient,
          borderRadius: BorderRadius.circular(20),
        ),
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

// ---------------- "আরও" mini tile ----------------

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MoreTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.09)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: v33GreenLight, size: 24),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: v33Sub),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
