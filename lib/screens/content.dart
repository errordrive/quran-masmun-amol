// Content screens: dua categories + detail, hadith collections + detail,
// tasbih list + counter, and full search (local data only, 300ms debounce).
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/asmaul_husna.dart';
import '../data/duas.dart';
import '../data/hadith.dart';
import '../data/surah_names_bn.dart';
import '../data/tasbih.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/quran_service.dart';
import '../services/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'quran.dart';

// ---------------- Dua category list + detail ----------------

class CategoryListScreen extends StatelessWidget {
  final String title;
  final List<Dua> duas;
  final String subtitle;
  const CategoryListScreen({
    super.key,
    required this.title,
    required this.duas,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    if (duas.isEmpty) {
      return AppScaffold(
        appBar: AppBar(title: Text(title)),
        body: EmptyState(
          icon: Icons.menu_book,
          title: tr('no_duas_yet'),
          subtitle: tr('no_duas_sub'),
        ),
      );
    }
    return AppScaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: duas.length,
        padding: const EdgeInsets.only(bottom: 32),
        itemBuilder: (context, i) {
          final d = duas[i];
          return ListTile(
            title: Text(bn ? d.banglaTitle : d.title,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(d.reference,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => DuaDetailScreen(dua: d)),
            ),
          );
        },
      ),
    );
  }
}

class DuaDetailScreen extends StatelessWidget {
  final Dua dua;
  const DuaDetailScreen({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final bn = state.isBangla;
        final title = bn ? dua.banglaTitle : dua.title;
        final meaning = bn ? dua.banglaMeaning : dua.meaning;
        final fav = state.favoriteDuas.contains(dua.id);
        return AppScaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TonalIconButton(
                  icon: fav ? Icons.favorite : Icons.favorite_border,
                  filled: fav,
                  tooltip: tr('favorite'),
                  onPressed: () => state.toggleFavoriteDua(dua.id),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Text(dua.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style:
                      TextStyle(fontSize: state.arabicSize, height: 2.0)),
              const SizedBox(height: 16),
              Text(tr('transliteration'),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(dua.transliteration,
                  style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
              Text(tr('meaning'),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(meaning, style: const TextStyle(fontSize: 15, height: 1.6)),
              const SizedBox(height: 16),
              Text('${tr('reference')}: ${dua.reference}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              CopyShareRow(
                onCopy: () =>
                    copyText(context, '${dua.arabic}\n$meaning', title),
                onShare: () =>
                    shareText(context, '$title\n${dua.arabic}\n$meaning'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- Hadith ----------------

class HadithCollectionScreen extends StatelessWidget {
  const HadithCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(tr('hadith'))),
      body: ListView.builder(
        itemCount: hadithCollections.length,
        padding: const EdgeInsets.only(bottom: 32),
        itemBuilder: (context, i) {
          final name = hadithCollections[i];
          final count = hadithsByCollection(name).length;
          return ListTile(
            leading: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child:
                  const Icon(Icons.auto_stories, color: primaryGreen),
            ),
            title: Text(name,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('$count ${tr('hadiths_count')}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                  builder: (_) => HadithListScreen(collection: name)),
            ),
          );
        },
      ),
    );
  }
}

class HadithListScreen extends StatelessWidget {
  final String collection;
  const HadithListScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final list = hadithsByCollection(collection);
    final bn = AppState.instance.isBangla;
    if (list.isEmpty) {
      return AppScaffold(
        appBar: AppBar(title: Text(collection)),
        body: EmptyState(
          icon: Icons.auto_stories,
          title: tr('no_hadiths_yet'),
          subtitle: tr('no_hadiths_sub'),
        ),
      );
    }
    // Group by book, preserving first-seen order.
    final books = <String>[];
    for (final h in list) {
      if (!books.contains(h.book)) books.add(h.book);
    }
    return AppScaffold(
      appBar: AppBar(title: Text(collection)),
      body: ListView.builder(
        itemCount: books.length,
        padding: const EdgeInsets.only(bottom: 32),
        itemBuilder: (context, bi) {
          final book = books[bi];
          final inBook = list.where((h) => h.book == book).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(book,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: primaryGreen)),
              ),
              for (final h in inBook)
                ListTile(
                  title: Text('${tr('hadith_word')} ${h.number}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(bn ? h.banglaMeaning : h.english,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (_) => HadithDetailScreen(hadith: h)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class HadithDetailScreen extends StatelessWidget {
  final Hadith hadith;
  const HadithDetailScreen({super.key, required this.hadith});

  String get _key => '${hadith.collection}|${hadith.number}';

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final bn = state.isBangla;
        final meaning = bn ? hadith.banglaMeaning : hadith.english;
        final fav = state.favoriteHadiths.contains(_key);
        return AppScaffold(
          appBar: AppBar(
            title: Text('${hadith.collection} ${hadith.number}'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TonalIconButton(
                  icon: fav ? Icons.favorite : Icons.favorite_border,
                  filled: fav,
                  tooltip: tr('favorite'),
                  onPressed: () => state.toggleFavoriteHadith(_key),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Row(
                children: [
                  Chip(label: Text(hadith.grade)),
                  const SizedBox(width: 8),
                  Chip(label: Text(hadith.book)),
                ],
              ),
              const SizedBox(height: 16),
              Text(hadith.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style:
                      TextStyle(fontSize: state.arabicSize, height: 2.0)),
              const SizedBox(height: 16),
              Text(tr('translation'),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(meaning, style: const TextStyle(fontSize: 15, height: 1.6)),
              if (bn) ...[
                const SizedBox(height: 12),
                Text(hadith.english,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
              const SizedBox(height: 16),
              Text('${tr('narrated_by')} ${hadith.narrator}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text('${tr('reference')}: ${hadith.collection} ${hadith.number}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              CopyShareRow(
                onCopy: () => copyText(
                    context,
                    '${hadith.arabic}\n$meaning\n(${hadith.collection} ${hadith.number})',
                    tr('hadith_word')),
                onShare: () => shareText(
                    context,
                    '${hadith.arabic}\n$meaning\n(${hadith.collection} ${hadith.number})'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- Asmaul Husna (99 Names of Allah) ----------------

class AsmaulHusnaScreen extends StatelessWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    return AppScaffold(
      appBar: AppBar(title: Text(tr('asmaul_husna'))),
      body: ListView.builder(
        itemCount: asmaulHusna.length,
        padding: const EdgeInsets.only(bottom: 32),
        itemBuilder: (context, i) {
          final name = asmaulHusna[i];
          return ListTile(
            leading: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('${name.number}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: primaryGreen)),
            ),
            title: Text(name.transliteration,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(bn ? name.banglaMeaning : name.meaning),
            trailing: Text(name.arabic,
                style: const TextStyle(fontSize: 22, color: primaryGreen)),
            onTap: () => _showNameActions(context, name),
          );
        },
      ),
    );
  }

  Future<void> _showNameActions(BuildContext context, AsmaulHusna name) async {
    final bn = AppState.instance.isBangla;
    final meaning = bn ? name.banglaMeaning : name.meaning;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name.arabic,
                    style: const TextStyle(fontSize: 36, color: primaryGreen)),
                const SizedBox(height: 8),
                Text(name.transliteration,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                Text(meaning,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                CopyShareRow(
                  onCopy: () {
                    Navigator.of(sheetContext).pop();
                    copyText(context,
                        '${name.arabic} — ${name.transliteration} ($meaning)',
                        name.transliteration);
                  },
                  onShare: () {
                    Navigator.of(sheetContext).pop();
                    shareText(context,
                        '${name.arabic}\n${name.transliteration} — $meaning');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------- Tasbih ----------------

class TasbihListScreen extends StatelessWidget {
  const TasbihListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final items = [...defaultTasbihs, ...state.customTasbihs];
        final todayTotal = state.tasbihTodayTotal();
        final streak = state.tasbihStreak();
        final last7 = state.last7TasbihTotals();
        final maxCount =
            last7.map((e) => e.count).fold<int>(0, (a, b) => a > b ? a : b);
        final bn = state.isBangla;
        final weekdays = bn
            ? ['সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র', 'শনি', 'রবি']
            : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return AppScaffold(
          appBar: AppBar(
            title: Text(tr('tasbih')),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TonalIconButton(
                  icon: Icons.add,
                  tooltip: tr('add_custom_tasbih'),
                  onPressed: () => _showAddCustom(context),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // History + streak header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tr('todays_total'),
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  Text('$todayTotal',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: primaryGreen)),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Theme.of(context).dividerColor,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(tr('daily_streak'),
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  Text(
                                      streak == 0
                                          ? tr('no_streak_yet')
                                          : '$streak ${streak == 1 ? tr('day') : tr('days')}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: primaryGreen)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final e in last7)
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('${e.count}',
                                        style: const TextStyle(fontSize: 11)),
                                    const SizedBox(height: 4),
                                    Container(
                                      height: maxCount == 0
                                          ? 4
                                          : (e.count / maxCount * 48)
                                                  .clamp(4, 48)
                                                  .toDouble(),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: e.count > 0
                                            ? primaryGreen
                                            : Theme.of(context).dividerColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(weekdays[e.date.weekday - 1],
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Dhikr preset quick chips: tap a preset to open its counter.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final t in defaultTasbihs.take(5))
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            avatar: const Icon(Icons.fingerprint,
                                size: 16, color: primaryGreen),
                            label: Text(t.englishName),
                            onPressed: () => Navigator.of(context,
                                    rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (_) =>
                                        TasbihCounterScreen(item: t))),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  padding: const EdgeInsets.only(bottom: 32),
                  itemBuilder: (context, i) {
                    final t = items[i];
                    final count = state.tasbihCount(t.id);
                    return ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            const Icon(Icons.fingerprint, color: primaryGreen),
                      ),
                      title: Text(t.englishName,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                          '${tr('target')}: ${t.target} · ${tr('count')}: $count'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(t.arabicName,
                              style: const TextStyle(
                                  fontSize: 18, color: primaryGreen)),
                          if (t.custom)
                            IconButton(
                              icon:
                                  const Icon(Icons.delete_outline, size: 20),
                              tooltip: tr('delete'),
                              onPressed: () =>
                                  state.removeCustomTasbih(t.id),
                            )
                          else
                            const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (_) => TasbihCounterScreen(item: t)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddCustom(BuildContext context) async {
    final state = AppState.instance;
    final arabicCtrl = TextEditingController();
    final englishCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '100');
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(tr('add_custom_tasbih')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: arabicCtrl,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration:
                    InputDecoration(labelText: tr('arabic_name')),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: englishCtrl,
                decoration:
                    InputDecoration(labelText: tr('english_name')),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: targetCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: tr('target_count')),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(tr('cancel')),
            ),
            FilledButton(
              onPressed: () {
                final target = int.tryParse(targetCtrl.text.trim()) ?? 100;
                final english = englishCtrl.text.trim();
                final arabic = arabicCtrl.text.trim();
                if (english.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(tr('enter_english_name'))));
                  return;
                }
                state.addCustomTasbih(
                    arabic.isEmpty ? english : arabic, english, target);
                Navigator.of(dialogContext).pop();
              },
              child: Text(tr('add')),
            ),
          ],
        );
      },
    );
  }
}

class TasbihCounterScreen extends StatefulWidget {
  final TasbihItem item;
  const TasbihCounterScreen({super.key, required this.item});
  @override
  State<TasbihCounterScreen> createState() => _TasbihCounterScreenState();
}

class _TasbihCounterScreenState extends State<TasbihCounterScreen> {
  bool _pressed = false;
  // Session target override (33/99/100/500/1000 selector). Null = the
  // dhikr's own stored target. The stored TasbihItem is never mutated.
  int? _targetOverride;
  // Animated progress value for the smooth bead ring.
  double _animatedProgress = 0;
  // Count value the celebration dialog was last shown for (so it fires
  // once per target reach, not on every rebuild).
  int? _celebratedFor;

  int get _target => _targetOverride ?? widget.item.target;

  static const List<int> _targetOptions = [33, 99, 100, 500, 1000];

  void _onTap(int count) {
    final state = AppState.instance;
    final next = count + 1;
    final reached = next == _target;
    state.setTasbihCount(widget.item.id, next);
    state.recordTasbihTap();
    if (state.vibrationOn) {
      if (reached) {
        // Distinct buzz on target reached: heavy impact + vibration.
        HapticFeedback.heavyImpact();
        HapticFeedback.vibrate();
      } else {
        HapticFeedback.lightImpact();
      }
    }
    if (reached && _celebratedFor != next) {
      _celebratedFor = next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showCelebration(next);
      });
    }
  }

  Future<void> _showCelebration(int count) async {
    final again = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (d) => _CelebrationDialog(
        dhikrName: widget.item.englishName,
        arabicName: widget.item.arabicName,
        count: count,
      ),
    );
    if (again == true && mounted) {
      AppState.instance.resetTasbih(widget.item.id);
      setState(() => _celebratedFor = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final count = state.tasbihCount(widget.item.id);
        final done = count >= _target;
        final progress =
            (count / _target).clamp(0.0, 1.0).toDouble();
        final todayTotal = state.tasbihTodayTotal();
        final streak = state.tasbihStreak();
        final bn = state.isBangla;
        return AppScaffold(
          appBar: AppBar(title: Text(widget.item.englishName)),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(widget.item.arabicName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30, color: primaryGreen, height: 1.8)),
                const SizedBox(height: 8),
                Text('${widget.item.englishName} · ${tr('target')} $_target',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                // Today's total + streak.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MiniStat(
                      icon: Icons.today,
                      label: tr('todays_total'),
                      value: '$todayTotal',
                    ),
                    const SizedBox(width: 12),
                    _MiniStat(
                      icon: Icons.local_fire_department,
                      label: tr('daily_streak'),
                      value: streak == 0
                          ? tr('no_streak_yet')
                          : '$streak ${streak == 1 ? tr('day') : tr('days')}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Target selector: 33 / 99 / 100 / 500 / 1000.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final opt in _targetOptions)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('$opt'),
                            selected: _target == opt,
                            onSelected: (_) => setState(() {
                              _targetOverride = opt;
                              _celebratedFor = null;
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
                // Target-reached banner.
                if (done) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.celebration,
                            color: Color(0xFFFFD54F), size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            bn
                                ? 'মাশাআল্লাহ! লক্ষ্য পূরণ হয়েছে — $_target বার'
                                : 'MashaAllah! Target reached — $_target times',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => _pressed = true),
                      onTapUp: (_) => setState(() => _pressed = false),
                      onTapCancel: () => setState(() => _pressed = false),
                      onTap: () => _onTap(count),
                      child: AnimatedScale(
                        scale: _pressed ? 0.94 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Smooth bead ring: 33 beads fill as progress
                            // grows; the value animates instead of jumping.
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                  begin: _animatedProgress, end: progress),
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOut,
                              onEnd: () => _animatedProgress = progress,
                              builder: (context, value, _) => SizedBox(
                                width: 284,
                                height: 284,
                                child: CustomPaint(
                                  painter: _BeadRingPainter(
                                      progress: value, beadCount: 33),
                                ),
                              ),
                            ),
                            Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                color: done
                                    ? primaryGreen
                                    : primaryGreen.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: primaryGreen, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        primaryGreen.withOpacity(0.25),
                                    blurRadius: 28,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$count',
                                      style: TextStyle(
                                          fontSize: 64,
                                          fontWeight: FontWeight.w800,
                                          color: done
                                              ? Colors.white
                                              : primaryGreen)),
                                  Text('/ $_target',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: done
                                              ? Colors.white70
                                              : Colors.grey)),
                                  const SizedBox(height: 8),
                                  Text(done ? tr('completed') : tr('tap_to_count'),
                                      style: TextStyle(
                                          color: done
                                              ? Colors.white
                                              : primaryGreen)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TonalButton(
                        label: tr('reset'),
                        icon: Icons.refresh,
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (d) => AlertDialog(
                              title: Text(tr('reset_counter_q')),
                              content: Text(tr('reset_counter_sub')),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(d).pop(false),
                                  child: Text(tr('cancel')),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(d).pop(true),
                                  child: Text(tr('reset')),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            state.resetTasbih(widget.item.id);
                            setState(() => _celebratedFor = null);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TonalButton(
                        label: state.vibrationOn
                            ? tr('vibration_on')
                            : tr('vibration_off'),
                        icon: state.vibrationOn
                            ? Icons.vibration
                            : Icons.volume_off,
                        onPressed: () =>
                            state.setVibration(!state.vibrationOn),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Small today-total / streak pill used above the tasbih counter.
class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MiniStat(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: primaryGreen),
          const SizedBox(width: 6),
          Text('$label: ',
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: primaryGreen)),
        ],
      ),
    );
  }
}

/// Bead ring: [beadCount] beads arranged in a circle; beads up to
/// [progress] are filled green, the rest are faint. Drawn with widgets
/// only — no new packages.
class _BeadRingPainter extends CustomPainter {
  final double progress;
  final int beadCount;
  const _BeadRingPainter({required this.progress, required this.beadCount});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    // Faint track circle.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = primaryGreen.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final filled = (progress * beadCount).round();
    for (var i = 0; i < beadCount; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / beadCount);
      final pos = center +
          Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      final isFilled = i < filled;
      canvas.drawCircle(
        pos,
        isFilled ? 6 : 4.5,
        Paint()
          ..color = isFilled
              ? primaryGreen
              : primaryGreen.withOpacity(0.18),
      );
      if (isFilled) {
        canvas.drawCircle(
          pos + const Offset(-1.5, -1.5),
          2,
          Paint()..color = Colors.white.withOpacity(0.7),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_BeadRingPainter old) =>
      old.progress != progress || old.beadCount != beadCount;
}

/// Completion celebration dialog: gold + green, with a widget-only
/// confetti animation (falling dots, no new packages).
class _CelebrationDialog extends StatefulWidget {
  final String dhikrName;
  final String arabicName;
  final int count;
  const _CelebrationDialog({
    required this.dhikrName,
    required this.arabicName,
    required this.count,
  });

  @override
  State<_CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<_CelebrationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) => CustomPaint(
                painter: _ConfettiPainter(progress: _ctrl.value),
              ),
            ),
          ),
          const Icon(Icons.celebration, size: 48, color: primaryGreen),
          const SizedBox(height: 8),
          Text(
            bn ? 'মাশাআল্লাহ!' : 'MashaAllah!',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: primaryGreen),
          ),
          const SizedBox(height: 4),
          Text(
            bn
                ? 'লক্ষ্য পূরণ হয়েছে — ${widget.count} বার'
                : 'Target reached — ${widget.count} times',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            widget.arabicName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: primaryGreen),
          ),
          Text(widget.dhikrName,
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(bn ? 'চালিয়ে যান' : 'Continue'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(bn ? 'আবার শুরু করুন' : 'Start again'),
        ),
      ],
    );
  }
}

/// Falling confetti dots (green + gold), driven by [progress] 0..1.
class _ConfettiPainter extends CustomPainter {
  final double progress;
  const _ConfettiPainter({required this.progress});

  static const List<Color> _colors = [
    primaryGreen,
    Color(0xFFC9A227),
    Color(0xFF2E7D32),
    Color(0xFFFFD54F),
    Color(0xFF66BB6A),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 42; i++) {
      final rnd = math.Random(i * 7 + 3);
      final x = rnd.nextDouble() * size.width;
      final startY = rnd.nextDouble() * size.height * 0.4;
      final speed = 0.5 + rnd.nextDouble();
      final y = (startY + progress * speed * size.height) % size.height;
      final sway = math.sin((progress * 6 + i) * 1.3) * 8;
      final color = _colors[i % _colors.length];
      final r = 3 + rnd.nextDouble() * 3;
      if (i % 3 == 0) {
        canvas.drawRect(
          Rect.fromCenter(
              center: Offset(x + sway, y), width: r * 2, height: r * 1.4),
          Paint()..color = color,
        );
      } else {
        canvas.drawCircle(
          Offset(x + sway, y),
          r,
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

// ---------------- Search ----------------

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Surah> _surahResults = [];
  List<Hadith> _hadithResults = [];
  List<Dua> _duaResults = [];
  List<Surah> _allSurahs = [];
  bool _searched = false;
  bool _loadingSurahs = true;

  @override
  void initState() {
    super.initState();
    QuranService.instance.loadSurahs().then((s) {
      if (mounted) {
        setState(() {
          _allSurahs = s;
          _loadingSurahs = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _runSearch(q);
    });
  }

  void _runSearch(String raw) {
    final q = raw.trim().toLowerCase();
    if (q.length < 2) {
      setState(() {
        _surahResults = [];
        _hadithResults = [];
        _duaResults = [];
        _searched = false;
      });
      return;
    }
    final rawQ = raw.trim();
    final surahs = _allSurahs.where((s) {
      if (s.englishName.toLowerCase().contains(q) ||
          s.englishNameTranslation.toLowerCase().contains(q) ||
          bnSurahName(s.number).contains(rawQ) ||
          bnSurahMeaning(s.number).contains(rawQ)) {
        return true;
      }
      // Search ayah translations.
      for (final a in s.ayahs) {
        if (a.translation.toLowerCase().contains(q)) return true;
      }
      return false;
    }).toList();
    final hadithList = hadiths.where((h) {
      return h.english.toLowerCase().contains(q) ||
          h.banglaMeaning.contains(rawQ) ||
          h.collection.toLowerCase().contains(q) ||
          h.book.toLowerCase().contains(q) ||
          h.narrator.toLowerCase().contains(q);
    }).toList();
    final duaList = duas.where((d) {
      return d.title.toLowerCase().contains(q) ||
          d.banglaTitle.contains(rawQ) ||
          d.meaning.toLowerCase().contains(q) ||
          d.banglaMeaning.contains(rawQ) ||
          d.transliteration.toLowerCase().contains(q) ||
          d.reference.toLowerCase().contains(q);
    }).toList();
    setState(() {
      _surahResults = surahs;
      _hadithResults = hadithList;
      _duaResults = duaList;
      _searched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasResults = _surahResults.isNotEmpty ||
        _hadithResults.isNotEmpty ||
        _duaResults.isNotEmpty;
    final bn = AppState.instance.isBangla;
    return AppScaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: tr('search_hint'),
            border: InputBorder.none,
          ),
          onChanged: _onQueryChanged,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _runSearch('');
              },
            ),
        ],
      ),
      body: _loadingSurahs
          ? const LoadingState()
          : !_searched
              ? EmptyState(
                  icon: Icons.search,
                  title: tr('search_intro_title'),
                  subtitle: tr('search_intro_sub'),
                )
              : !hasResults
                  ? EmptyState(
                      icon: Icons.search_off,
                      title: tr('search_no_results'),
                      subtitle: tr('search_no_results_sub'),
                    )
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 32),
                      children: [
                        if (_surahResults.isNotEmpty) ...[
                          _groupHeader(tr('quran'), _surahResults.length),
                          for (final s in _surahResults.take(5))
                            ListTile(
                              leading: const Icon(Icons.menu_book,
                                  color: primaryGreen),
                              title: Text(bn
                                  ? bnSurahName(s.number)
                                  : s.englishName),
                              subtitle: Text(
                                  '${bn ? bnSurahMeaning(s.number) : s.englishNameTranslation} · ${s.ayahs.length} ${tr('ayahs')}'),
                              onTap: () => Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (_) => QuranReaderScreen(
                                        surah: s, surahs: _allSurahs)),
                              ),
                            ),
                        ],
                        if (_hadithResults.isNotEmpty) ...[
                          _groupHeader(tr('hadith'), _hadithResults.length),
                          for (final h in _hadithResults.take(5))
                            ListTile(
                              leading: const Icon(Icons.auto_stories,
                                  color: primaryGreen),
                              title: Text(
                                  '${h.collection} ${h.number}'),
                              subtitle: Text(
                                  bn ? h.banglaMeaning : h.english,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              onTap: () => Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        HadithDetailScreen(hadith: h)),
                              ),
                            ),
                        ],
                        if (_duaResults.isNotEmpty) ...[
                          _groupHeader(tr('dua_group'), _duaResults.length),
                          for (final d in _duaResults.take(5))
                            ListTile(
                              leading: const Icon(Icons.favorite,
                                  color: primaryGreen),
                              title: Text(bn ? d.banglaTitle : d.title),
                              subtitle: Text(d.reference,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              onTap: () => Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        DuaDetailScreen(dua: d)),
                              ),
                            ),
                        ],
                      ],
                    ),
    );
  }

  Widget _groupHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: primaryGreen)),
          const SizedBox(width: 8),
          Text('($count)', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
