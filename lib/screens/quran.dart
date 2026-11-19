// Quran: surah list (Surah / Juz tabs), search, Continue Reading,
// and the reader with Bismillah, text size, translation toggle,
// ayah Copy/Share/Bookmark, and auto-saved last-read position.
import 'package:flutter/material.dart';
import '../data/juz.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/quran_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

const String _bismillah = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

class QuranListScreen extends StatefulWidget {
  const QuranListScreen({super.key});
  @override
  State<QuranListScreen> createState() => _QuranListScreenState();
}

class _QuranListScreenState extends State<QuranListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<Surah> _surahs = [];
  bool _loading = true;
  bool _failed = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final surahs = await QuranService.instance.loadSurahs();
    if (!mounted) return;
    setState(() {
      _surahs = surahs;
      _loading = false;
      _failed = surahs.isEmpty;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final filtered = QuranService.instance.searchSurahs(_surahs, _query);
    final counts = {for (final s in _surahs) s.number: s.ayahs.length};
    final juzList = buildJuzList(counts);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryGreen,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryGreen,
          tabs: const [
            Tab(text: 'Surah'),
            Tab(text: 'Juz'),
          ],
        ),
      ),
      body: _loading
          ? const LoadingState()
          : _failed
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const EmptyState(
                        icon: Icons.error_outline,
                        title: 'Quran data could not be loaded',
                        subtitle:
                            'The bundled Quran file is missing or damaged. Please reinstall the app.',
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          setState(() => _loading = true);
                          _load();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search surah by name or number',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                    if (state.lastSurah > 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              final s = QuranService.instance
                                  .surahByNumber(_surahs, state.lastSurah);
                              if (s != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => QuranReaderScreen(
                                          surah: s,
                                          surahs: _surahs,
                                          initialAyah: state.lastAyah)),
                                );
                              }
                            },
                            icon: const Icon(Icons.bookmark, size: 18),
                            label: Text(
                                'Continue reading: ${state.lastSurah == 0 ? '' : _surahName(_surahs, state.lastSurah)} · Ayah ${state.lastAyah}'),
                          ),
                        ),
                      ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _SurahTab(
                            surahs: filtered,
                            allSurahs: _surahs,
                            query: _query,
                          ),
                          _JuzTab(juzList: juzList, surahs: _surahs),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  String _surahName(List<Surah> surahs, int number) {
    for (final s in surahs) {
      if (s.number == number) return s.englishName;
    }
    return 'Surah $number';
  }
}

class _SurahTab extends StatelessWidget {
  final List<Surah> surahs;
  final List<Surah> allSurahs;
  final String query;
  const _SurahTab({
    required this.surahs,
    required this.allSurahs,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (surahs.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No surah found',
        subtitle: query.isEmpty
            ? 'The surah list is empty.'
            : 'No surah matches "$query".',
      );
    }
    return ListView.builder(
      itemCount: surahs.length,
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (context, i) {
        final s = surahs[i];
        return ListTile(
          leading: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${s.number}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: primaryGreen)),
          ),
          title: Text(s.englishName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
              '${s.englishNameTranslation} · ${s.ayahs.length} ayahs · ${s.revelationType}'),
          trailing: Text(s.name,
              style: const TextStyle(fontSize: 20, color: primaryGreen)),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) =>
                    QuranReaderScreen(surah: s, surahs: allSurahs)),
          ),
        );
      },
    );
  }
}

class _JuzTab extends StatelessWidget {
  final List<JuzInfo> juzList;
  final List<Surah> surahs;
  const _JuzTab({required this.juzList, required this.surahs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: juzList.length,
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (context, i) {
        final j = juzList[i];
        return ListTile(
          leading: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${j.number}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: primaryGreen)),
          ),
          title: Text('Juz ${j.number}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(juzRangeText(j, surahs)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            final s = QuranService.instance.surahByNumber(surahs, j.startSurah);
            if (s != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => QuranReaderScreen(
                        surah: s,
                        surahs: surahs,
                        initialAyah: j.startAyah)),
              );
            }
          },
        );
      },
    );
  }
}

class QuranReaderScreen extends StatefulWidget {
  final Surah surah;
  final List<Surah> surahs;
  final int initialAyah;
  const QuranReaderScreen({
    super.key,
    required this.surah,
    required this.surahs,
    this.initialAyah = 1,
  });
  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  late Surah _surah;
  final ScrollController _scroll = ScrollController();
  Map<String, String> _bangla = {};

  @override
  void initState() {
    super.initState();
    _surah = widget.surah;
    QuranService.instance.loadBangla().then((m) {
      if (mounted) setState(() => _bangla = m);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppState.instance.saveLastRead(_surah.number, widget.initialAyah);
      if (widget.initialAyah > 1 && _scroll.hasClients) {
        // Rough scroll to the starting ayah.
        _scroll.jumpTo(
            (_scroll.position.maxScrollExtent *
                    (widget.initialAyah / _surah.ayahs.length))
                .clamp(0, _scroll.position.maxScrollExtent));
      }
    });
  }

  void _goToSurah(int number) {
    final s = QuranService.instance.surahByNumber(widget.surahs, number);
    if (s == null) return;
    setState(() => _surah = s);
    AppState.instance.saveLastRead(s.number, 1);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  String? _translationText(Ayah ayah) {
    final state = AppState.instance;
    if (!state.showTranslation) return null;
    if (state.translationLang == 'bn') {
      return _bangla['${_surah.number}:${ayah.numberInSurah}'] ??
          ayah.translation;
    }
    return ayah.translation;
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${_surah.number}. ${_surah.englishName}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.text_decrease),
                tooltip: 'Smaller text',
                onPressed: state.arabicSize > 18
                    ? () => state.setArabicSize(state.arabicSize - 2)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.text_increase),
                tooltip: 'Larger text',
                onPressed: state.arabicSize < 36
                    ? () => state.setArabicSize(state.arabicSize + 2)
                    : null,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.translate),
                tooltip: 'Translation language',
                onSelected: (value) {
                  if (value == 'off') {
                    state.setShowTranslation(false);
                  } else {
                    state.setTranslationLang(value);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'en',
                    child: Row(children: [
                      Icon(Icons.check,
                          size: 18,
                          color: state.showTranslation &&
                                  state.translationLang == 'en'
                              ? primaryGreen
                              : Colors.transparent),
                      const SizedBox(width: 8),
                      const Text('English (Sahih International)'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'bn',
                    child: Row(children: [
                      Icon(Icons.check,
                          size: 18,
                          color: state.showTranslation &&
                                  state.translationLang == 'bn'
                              ? primaryGreen
                              : Colors.transparent),
                      const SizedBox(width: 8),
                      const Text('Bangla (Muhiuddin Khan)'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'off',
                    child: Row(children: [
                      Icon(Icons.check,
                          size: 18,
                          color: !state.showTranslation
                              ? primaryGreen
                              : Colors.transparent),
                      const SizedBox(width: 8),
                      const Text('Off'),
                    ]),
                  ),
                ],
              ),
            ],
          ),
          body: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            itemCount: _surah.ayahs.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Text(_surah.name,
                        style: const TextStyle(
                            fontSize: 28, color: primaryGreen)),
                    const SizedBox(height: 4),
                    Text(
                        '${_surah.englishNameTranslation} · ${_surah.ayahs.length} ayahs · ${_surah.revelationType}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                    const SizedBox(height: 16),
                    if (_surah.number != 9 && _surah.number != 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(_bismillah,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: state.arabicSize, height: 1.8)),
                      ),
                  ],
                );
              }
              if (index == _surah.ayahs.length + 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _surah.number > 1
                              ? () => _goToSurah(_surah.number - 1)
                              : null,
                          child: const Text('Previous Surah'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _surah.number < 114
                              ? () => _goToSurah(_surah.number + 1)
                              : null,
                          child: const Text('Next Surah'),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final ayah = _surah.ayahs[index - 1];
              final translation = _translationText(ayah);
              final bookmarked =
                  state.isBookmarked(_surah.number, ayah.numberInSurah);
              return InkWell(
                onTap: () => _showAyahActions(context, ayah),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context)
                              .dividerColor
                              .withOpacity(0.5)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: primaryGreen.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Text('${ayah.numberInSurah}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: primaryGreen)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(ayah.text,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: state.arabicSize, height: 2.0)),
                          ),
                          IconButton(
                            icon: Icon(
                                bookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: primaryGreen),
                            tooltip:
                                bookmarked ? 'Remove bookmark' : 'Bookmark',
                            onPressed: () {
                              state.toggleBookmark(
                                  _surah.number, ayah.numberInSurah);
                            },
                          ),
                        ],
                      ),
                      if (translation != null) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(translation,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showAyahActions(BuildContext context, Ayah ayah) async {
    final state = AppState.instance;
    final ref = '${_surah.englishName} ${_surah.number}:${ayah.numberInSurah}';
    final translation = _translationText(ayah) ?? ayah.translation;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ref,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(translation,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text('Copy ayah'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    copyText(context, '${ayah.text}\n$translation\n($ref)', ref);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share ayah'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    shareText(context, '${ayah.text}\n$translation\n($ref)');
                  },
                ),
                ListTile(
                  leading: Icon(state.isBookmarked(_surah.number, ayah.numberInSurah)
                      ? Icons.bookmark
                      : Icons.bookmark_border),
                  title: Text(state.isBookmarked(_surah.number, ayah.numberInSurah)
                      ? 'Remove bookmark'
                      : 'Bookmark ayah'),
                  onTap: () {
                    state.toggleBookmark(_surah.number, ayah.numberInSurah);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    state.saveLastRead(_surah.number, ayah.numberInSurah);
  }
}
