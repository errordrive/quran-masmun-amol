// Home tab: top bar, Namaz Time card, category grid, Daily Dua card.
import 'dart:async';
import 'package:flutter/material.dart';
import '../data/duas.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/navigation.dart';
import '../services/prayer.dart';
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

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
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
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: primaryGreen),
                            const SizedBox(width: 8),
                            const Text('Namaz Time',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            const Spacer(),
                            Text(state.cityName,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Now',
                                      style: TextStyle(color: Colors.grey)),
                                  Text(current,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700)),
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
                                  Text('Next · $next',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  Text(countdown,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: primaryGreen)),
                                  Text(formatTime(nextTime,
                                      use24h: state.use24h)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Tap to see the full day',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
                    label: 'Quran',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const QuranListScreen()),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.auto_stories,
                    label: 'Hadith',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const HadithCollectionScreen()),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.fingerprint,
                    label: 'Tasbih',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const TasbihListScreen()),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.favorite,
                    label: 'Daily Dua',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: 'Daily Dua',
                              duas: duas,
                              subtitle: 'All duas')),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.wb_sunny,
                    label: 'Morning & Evening Amol',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: 'Morning & Evening Amol',
                              duas: duasByCategory('morning'),
                              subtitle: 'Adhkar for morning and evening')),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.auto_awesome,
                    label: 'Asmaul Husna',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const AsmaulHusnaScreen()),
                    ),
                  ),
                  _CategoryTile(
                    icon: Icons.handshake,
                    label: 'Masnun Dua',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: 'Masnun Dua',
                              duas: duasByCategory('daily'),
                              subtitle: 'Duas for daily life')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Daily Dua',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => CategoryListScreen(
                              title: 'Daily Dua',
                              duas: duas,
                              subtitle: 'All duas')),
                    ),
                    child: const Text('See all'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
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
      borderRadius: BorderRadius.circular(16),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryGreen, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(dua.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  icon: Icon(
                    state.favoriteDuas.contains(dua.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: primaryGreen,
                  ),
                  onPressed: () => state.toggleFavoriteDua(dua.id),
                  tooltip: 'Favorite',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(dua.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontSize: state.arabicSize, height: 1.9)),
            const SizedBox(height: 8),
            Text(dua.transliteration,
                style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(dua.meaning),
            const SizedBox(height: 4),
            Text(dua.reference,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => copyText(
                        context, '${dua.arabic}\n${dua.meaning}', dua.title),
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => shareText(
                        context, '${dua.title}\n${dua.arabic}\n${dua.meaning}'),
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => DuaDetailScreen(dua: dua)),
                    ),
                    child: const Text('Open'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
