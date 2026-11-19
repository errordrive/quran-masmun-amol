// Home tab: top bar, Namaz Time card, category grid, Daily Dua card.
// v1.1: Bangla by default, premium tonal buttons, section titles.
import 'dart:async';
import 'package:flutter/material.dart';
import '../data/duas.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/navigation.dart';
import '../services/prayer.dart';
import '../services/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'content.dart';
import 'quran.dart';

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
    final (current, next, nextTime) = currentAndNextPrayer(today, tomorrow, now);
    final countdown = formatCountdown(nextTime.difference(now));
    final dailyDua = state.dailyDua(now);
    final bn = state.isBangla;

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          color: primaryGreen,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              AppTopBar(
                onSearchTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
              const SizedBox(height: 16),
              // Namaz Time card
              InkWell(
                onTap: () => goToTab(1),
                borderRadius: BorderRadius.circular(20),
                child: Card(
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
                              child: const Icon(Icons.access_time,
                                  color: primaryGreen),
                            ),
                            const SizedBox(width: 12),
                            Text(tr('namaz_time'),
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800)),
                            const Spacer(),
                            Text(state.cityName,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tr('now'),
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  Text(prayerName(current),
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800)),
                                  Text(
                                      formatTime(
                                          today.prayers.firstWhere(
                                              (p) => p.$1 == current,
                                              orElse: () =>
                                                  today.prayers.first).$2,
                                          use24h: state.use24h),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant)),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 48,
                              color: Theme.of(context).dividerColor,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${tr('next')} · ${prayerName(next)}',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  Text(countdown,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: primaryGreen)),
                                  Text(formatTime(nextTime,
                                      use24h: state.use24h)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(tr('tap_full_day'),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SectionTitle(title: tr('categories')),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  _CategoryTile(
                    icon: Icons.menu_book,
                    label: tr('cat_quran'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const QuranListScreen()),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.auto_stories,
                    label: tr('cat_hadith'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const HadithCollectionScreen()),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.fingerprint,
                    label: tr('cat_tasbih'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const TasbihListScreen()),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.favorite,
                    label: tr('cat_daily_dua'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: tr('cat_daily_dua'),
                              duas: duas,
                              subtitle: tr('all_duas'))),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.wb_sunny,
                    label: tr('cat_morning'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: tr('cat_morning'),
                              duas: duasByCategory('morning'),
                              subtitle: tr('morning_sub'))),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.auto_awesome,
                    label: tr('cat_asmaul'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const AsmaulHusnaScreen()),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.handshake,
                    label: tr('cat_masnun'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: tr('cat_masnun'),
                              duas: duasByCategory('daily'),
                              subtitle: tr('daily_sub'))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SectionTitle(
                title: tr('daily_dua'),
                action: TextButton(
                  onPressed: () => Navigator.of(context).push(
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
            ],
          ),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _CategoryTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: primaryGreen, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
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
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DuaDetailScreen(dua: dua)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
