// Content screens: dua categories + detail, hadith collections + detail,
// tasbih list + counter, and full search (local data only, 300ms debounce).
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/asmaul_husna.dart';
import '../data/duas.dart';
import '../data/hadith.dart';
import '../data/tasbih.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/quran_service.dart';
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
    if (duas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const EmptyState(
          icon: Icons.menu_book,
          title: 'No duas yet',
          subtitle: 'Nothing has been added to this category.',
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: duas.length,
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, i) {
          final d = duas[i];
          return ListTile(
            title: Text(d.title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(d.reference,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
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
        return Scaffold(
          appBar: AppBar(
            title: Text(dua.title),
            actions: [
              IconButton(
                icon: Icon(
                  state.favoriteDuas.contains(dua.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: primaryGreen,
                ),
                tooltip: 'Favorite',
                onPressed: () => state.toggleFavoriteDua(dua.id),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(dua.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style:
                      TextStyle(fontSize: state.arabicSize, height: 2.0)),
              const SizedBox(height: 16),
              const Text('Transliteration',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(dua.transliteration,
                  style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
              const Text('Meaning',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(dua.meaning),
              const SizedBox(height: 16),
              Text('Reference: ${dua.reference}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => copyText(context,
                          '${dua.arabic}\n${dua.meaning}', dua.title),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => shareText(context,
                          '${dua.title}\n${dua.arabic}\n${dua.meaning}'),
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share'),
                    ),
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

// ---------------- Hadith ----------------

class HadithCollectionScreen extends StatelessWidget {
  const HadithCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hadith')),
      body: ListView.builder(
        itemCount: hadithCollections.length,
        padding: const EdgeInsets.only(bottom: 16),
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
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.auto_stories, color: primaryGreen),
            ),
            title: Text(name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('$count hadiths'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
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
    if (list.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(collection)),
        body: const EmptyState(
          icon: Icons.auto_stories,
          title: 'No hadiths yet',
          subtitle: 'Nothing has been added to this collection.',
        ),
      );
    }
    // Group by book, preserving first-seen order.
    final books = <String>[];
    for (final h in list) {
      if (!books.contains(h.book)) books.add(h.book);
    }
    return Scaffold(
      appBar: AppBar(title: Text(collection)),
      body: ListView.builder(
        itemCount: books.length,
        padding: const EdgeInsets.only(bottom: 16),
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
                        fontWeight: FontWeight.w700,
                        color: primaryGreen)),
              ),
              for (final h in inBook)
                ListTile(
                  title: Text('Hadith ${h.number}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(h.english,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
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
        return Scaffold(
          appBar: AppBar(
            title: Text('${hadith.collection} ${hadith.number}'),
            actions: [
              IconButton(
                icon: Icon(
                  state.favoriteHadiths.contains(_key)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: primaryGreen,
                ),
                tooltip: 'Favorite',
                onPressed: () => state.toggleFavoriteHadith(_key),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
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
              const Text('Translation',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(hadith.english),
              const SizedBox(height: 16),
              Text('Narrated by ${hadith.narrator}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text('Reference: ${hadith.collection} ${hadith.number}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => copyText(
                          context,
                          '${hadith.arabic}\n${hadith.english}\n(${hadith.collection} ${hadith.number})',
                          'Hadith'),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => shareText(
                          context,
                          '${hadith.arabic}\n${hadith.english}\n(${hadith.collection} ${hadith.number})'),
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share'),
                    ),
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

// ---------------- Asmaul Husna (99 Names of Allah) ----------------

class AsmaulHusnaScreen extends StatelessWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asmaul Husna')),
      body: ListView.builder(
        itemCount: asmaulHusna.length,
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, i) {
          final name = asmaulHusna[i];
          return ListTile(
            leading: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${name.number}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: primaryGreen)),
            ),
            title: Text(name.transliteration,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(name.meaning),
            trailing: Text(name.arabic,
                style: const TextStyle(fontSize: 22, color: primaryGreen)),
            onTap: () => _showNameActions(context, name),
          );
        },
      ),
    );
  }

  Future<void> _showNameActions(BuildContext context, AsmaulHusna name) async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name.arabic,
                    style: const TextStyle(fontSize: 36, color: primaryGreen)),
                const SizedBox(height: 8),
                Text(name.transliteration,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                Text(name.meaning,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          copyText(context,
                              '${name.arabic} — ${name.transliteration} (${name.meaning})',
                              name.transliteration);
                        },
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          shareText(context,
                              '${name.arabic}\n${name.transliteration} — ${name.meaning}');
                        },
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share'),
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
        const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tasbih'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add custom tasbih',
                onPressed: () => _showAddCustom(context),
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Today's total",
                                      style: TextStyle(color: Colors.grey)),
                                  Text('$todayTotal',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
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
                                  const Text('Daily streak',
                                      style: TextStyle(color: Colors.grey)),
                                  Text(
                                      streak == 0
                                          ? 'No streak yet'
                                          : '$streak day${streak == 1 ? '' : 's'}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
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
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  padding: const EdgeInsets.only(bottom: 16),
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
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Target: ${t.target} · Count: $count'),
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
                              tooltip: 'Delete',
                              onPressed: () =>
                                  state.removeCustomTasbih(t.id),
                            )
                          else
                            const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => Navigator.of(context).push(
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
          title: const Text('Add custom tasbih'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: arabicCtrl,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration:
                    const InputDecoration(labelText: 'Arabic name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: englishCtrl,
                decoration:
                    const InputDecoration(labelText: 'English name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: targetCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target count'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final target = int.tryParse(targetCtrl.text.trim()) ?? 100;
                final english = englishCtrl.text.trim();
                final arabic = arabicCtrl.text.trim();
                if (english.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter an English name')));
                  return;
                }
                state.addCustomTasbih(
                    arabic.isEmpty ? english : arabic, english, target);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
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
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final count = state.tasbihCount(widget.item.id);
        final done = count >= widget.item.target;
        return Scaffold(
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
                Text('${widget.item.englishName} · Target ${widget.item.target}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 32),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        final next = count + 1;
                        state.setTasbihCount(widget.item.id, next);
                        state.recordTasbihTap();
                        if (state.vibrationOn) {
                          if (next == widget.item.target) {
                            HapticFeedback.heavyImpact();
                          } else {
                            HapticFeedback.lightImpact();
                          }
                        }
                      },
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          color: done
                              ? primaryGreen
                              : primaryGreen.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: primaryGreen, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$count',
                                style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w700,
                                    color: done
                                        ? Colors.white
                                        : primaryGreen)),
                            Text('/ ${widget.item.target}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: done
                                        ? Colors.white70
                                        : Colors.grey)),
                            const SizedBox(height: 8),
                            Text(done ? 'Completed' : 'Tap to count',
                                style: TextStyle(
                                    color: done
                                        ? Colors.white
                                        : primaryGreen)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (d) => AlertDialog(
                              title: const Text('Reset counter?'),
                              content: const Text(
                                  'Your current count for this tasbih will go back to 0.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(d).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(d).pop(true),
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            state.resetTasbih(widget.item.id);
                          }
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            state.setVibration(!state.vibrationOn),
                        icon: Icon(
                            state.vibrationOn
                                ? Icons.vibration
                                : Icons.volume_off,
                            size: 18),
                        label: Text(state.vibrationOn
                            ? 'Vibration on'
                            : 'Vibration off'),
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
    final surahs = _allSurahs.where((s) {
      if (s.englishName.toLowerCase().contains(q) ||
          s.englishNameTranslation.toLowerCase().contains(q)) {
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
          h.collection.toLowerCase().contains(q) ||
          h.book.toLowerCase().contains(q) ||
          h.narrator.toLowerCase().contains(q);
    }).toList();
    final duaList = duas.where((d) {
      return d.title.toLowerCase().contains(q) ||
          d.meaning.toLowerCase().contains(q) ||
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
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search Quran, Hadith, Dua',
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
              ? const EmptyState(
                  icon: Icons.search,
                  title: 'Search the app',
                  subtitle:
                      'Type at least 2 characters to search the Quran, Hadith and duas. Everything is searched on your device.',
                )
              : !hasResults
                  ? const EmptyState(
                      icon: Icons.search_off,
                      title: 'No results found',
                      subtitle: 'Try a different word or spelling.',
                    )
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        if (_surahResults.isNotEmpty) ...[
                          _groupHeader('Quran', _surahResults.length),
                          for (final s in _surahResults.take(5))
                            ListTile(
                              leading: const Icon(Icons.menu_book,
                                  color: primaryGreen),
                              title: Text(s.englishName),
                              subtitle: Text(
                                  '${s.englishNameTranslation} · ${s.ayahs.length} ayahs'),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => QuranReaderScreen(
                                        surah: s, surahs: _allSurahs)),
                              ),
                            ),
                        ],
                        if (_hadithResults.isNotEmpty) ...[
                          _groupHeader('Hadith', _hadithResults.length),
                          for (final h in _hadithResults.take(5))
                            ListTile(
                              leading: const Icon(Icons.auto_stories,
                                  color: primaryGreen),
                              title: Text(
                                  '${h.collection} ${h.number}'),
                              subtitle: Text(h.english,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        HadithDetailScreen(hadith: h)),
                              ),
                            ),
                        ],
                        if (_duaResults.isNotEmpty) ...[
                          _groupHeader('Dua', _duaResults.length),
                          for (final d in _duaResults.take(5))
                            ListTile(
                              leading: const Icon(Icons.favorite,
                                  color: primaryGreen),
                              title: Text(d.title),
                              subtitle: Text(d.reference,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              onTap: () => Navigator.of(context).push(
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
