// Quran (v3.0 redesign, reference layout): surah list (Surah / Juz
// tabs), search, Continue Reading, and the reader — green surah header
// card with Bismillah + transliteration, ayah cards (number circle,
// Arabic, translation, per-ayah speaker button), a bottom action row
// (Bookmark / Share / Ayah / More), and player controls (prev /
// play-pause / next + ayah progress) wired to the existing audio
// service. Reader keeps Bismillah handling (except At-Tawbah),
// adjustable Arabic size, translation switcher, ayah Copy/Share/
// Bookmark, and auto-saved last-read position.
import 'package:flutter/material.dart';
import '../data/juz.dart';
import '../data/surah_names_bn.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/audio_service.dart';
import '../services/quran_service.dart';
import '../services/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';

const String _bismillah = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
const String _bismillahTransliteration =
    'Bismillah hir-rahman nir-rahim.';

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

    return AppScaffold(
      appBar: AppBar(
        title: Text(tr('quran')),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: goldAccent,
          tabs: [
            Tab(text: tr('surah')),
            Tab(text: tr('juz')),
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
                      EmptyState(
                        icon: Icons.error_outline,
                        title: tr('quran_load_failed'),
                        subtitle: tr('quran_load_failed_sub'),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: tr('retry'),
                        icon: Icons.refresh,
                        expanded: false,
                        onPressed: () {
                          setState(() => _loading = true);
                          _load();
                        },
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: tr('search_surah_hint'),
                          prefixIcon: const Icon(Icons.search),
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
                                Navigator.of(context, rootNavigator: true).push(
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
                                '${tr('continue_reading')}: ${_surahDisplayName(_surahs, state.lastSurah)} · ${tr('ayah')} ${state.lastAyah}'),
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

  String _surahDisplayName(List<Surah> surahs, int number) {
    for (final s in surahs) {
      if (s.number == number) {
        return AppState.instance.isBangla
            ? bnSurahName(number)
            : s.englishName;
      }
    }
    return '${tr('surah')} $number';
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
    final bn = AppState.instance.isBangla;
    if (surahs.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: tr('no_surah_found'),
        subtitle: query.isEmpty
            ? tr('surah_list_empty')
            : tr('no_surah_match'),
      );
    }
    return ListView.builder(
      itemCount: surahs.length,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
      itemBuilder: (context, i) {
        final s = surahs[i];
        final displayName = bn ? bnSurahName(s.number) : s.englishName;
        final meaning = bn
            ? bnSurahMeaning(s.number)
            : s.englishNameTranslation;
        final revelation = bn
            ? tr(s.revelationType == 'Meccan' ? 'meccan' : 'medinan')
            : s.revelationType;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('${s.number}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: primaryGreen)),
            ),
            title: Text(displayName,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(
                '$meaning · ${s.ayahs.length} ${tr('ayahs')} · $revelation'),
            trailing: Text(s.name,
                style: const TextStyle(fontSize: 20, color: primaryGreen)),
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                  builder: (_) =>
                      QuranReaderScreen(surah: s, surahs: allSurahs)),
            ),
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
      itemBuilder: (context, i) {
        final j = juzList[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
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
            title: Text('${tr('juz')} ${j.number}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(juzRangeText(j, surahs)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final s = QuranService.instance.surahByNumber(surahs, j.startSurah);
              if (s != null) {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (_) => QuranReaderScreen(
                          surah: s,
                          surahs: surahs,
                          initialAyah: j.startAyah)),
                );
              }
            },
          ),
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
  late int _selectedAyah;
  final ScrollController _scroll = ScrollController();
  Map<String, String> _bangla = {};

  @override
  void initState() {
    super.initState();
    _surah = widget.surah;
    _selectedAyah = widget.initialAyah.clamp(1, _surah.ayahs.length);
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
    AudioService.instance.stop();
    setState(() {
      _surah = s;
      _selectedAyah = 1;
    });
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

  Ayah get _selectedAyahObj => _surah.ayahs[
      (_selectedAyah - 1).clamp(0, _surah.ayahs.length - 1)];

  String _ayahRef(Ayah ayah) {
    final bn = AppState.instance.isBangla;
    final displayName =
        bn ? bnSurahName(_surah.number) : _surah.englishName;
    return '$displayName ${_surah.number}:${ayah.numberInSurah}';
  }

  String _ayahShareText(Ayah ayah) {
    final translation = _translationText(ayah) ?? ayah.translation;
    return '${ayah.text}\n$translation\n(${_ayahRef(ayah)})';
  }

  @override
  void dispose() {
    AudioService.instance.stop();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([state, AudioService.instance]),
      builder: (context, _) {
        final bn = state.isBangla;
        final audio = AudioService.instance;
        final displayName =
            bn ? bnSurahName(_surah.number) : _surah.englishName;
        final meaning = bn
            ? bnSurahMeaning(_surah.number)
            : _surah.englishNameTranslation;
        final revelation = bn
            ? tr(_surah.revelationType == 'Meccan' ? 'meccan' : 'medinan')
            : _surah.revelationType;
        final selected = _selectedAyahObj;
        final selectedBookmarked =
            state.isBookmarked(_surah.number, selected.numberInSurah);
        return AppScaffold(
          appBar: AppBar(
            title: Text('${_surah.number}. $displayName'),
            actions: [
              IconButton(
                icon: const Icon(Icons.text_decrease, color: Colors.white),
                tooltip: tr('smaller_text'),
                onPressed: state.arabicSize > 18
                    ? () => state.setArabicSize(state.arabicSize - 2)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.text_increase, color: Colors.white),
                tooltip: tr('larger_text'),
                onPressed: state.arabicSize < 36
                    ? () => state.setArabicSize(state.arabicSize + 2)
                    : null,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.translate, color: Colors.white),
                tooltip: tr('translation_lang'),
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
                      Text(tr('english_sahih')),
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
                      Text(tr('bangla_muhiuddin')),
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
                      Text(tr('off')),
                    ]),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  itemCount: _surah.ayahs.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _SurahHeaderCard(
                        surah: _surah,
                        displayName: displayName,
                        meaning: meaning,
                        revelation: revelation,
                      );
                    }
                    if (index == _surah.ayahs.length + 1) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: TonalButton(
                                label: tr('previous_surah'),
                                icon: Icons.chevron_left,
                                onPressed: _surah.number > 1
                                    ? () => _goToSurah(_surah.number - 1)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PrimaryButton(
                                label: tr('next_surah'),
                                icon: Icons.chevron_right,
                                expanded: false,
                                onPressed: _surah.number < 114
                                    ? () => _goToSurah(_surah.number + 1)
                                    : null,
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
                    // v2.0: highlight the ayah currently being recited.
                    final isPlayingAyah =
                        audio.playingSurah == _surah.number &&
                            audio.playingAyah == ayah.numberInSurah;
                    final isSelected =
                        ayah.numberInSurah == _selectedAyah;
                    return _AyahCard(
                      ayah: ayah,
                      translation: translation,
                      bookmarked: bookmarked,
                      isPlayingAyah: isPlayingAyah,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() => _selectedAyah = ayah.numberInSurah);
                        _showAyahActions(context, ayah);
                      },
                      onBookmark: () {
                        setState(
                            () => _selectedAyah = ayah.numberInSurah);
                        state.toggleBookmark(
                            _surah.number, ayah.numberInSurah);
                      },
                      onListen: () {
                        setState(
                            () => _selectedAyah = ayah.numberInSurah);
                        AudioService.instance.playSurah(_surah,
                            startAyah: ayah.numberInSurah);
                      },
                    );
                  },
                ),
              ),
              // Bottom action row (reference layout) — acts on the
              // selected ayah (tap any ayah card to select it).
              _AyahActionRow(
                ayahRef: _ayahRef(selected),
                bookmarked: selectedBookmarked,
                onBookmark: () => state.toggleBookmark(
                    _surah.number, selected.numberInSurah),
                onShare: () => shareText(context, _ayahShareText(selected)),
                onAyah: () => _showAyahActions(context, selected),
                onCopy: () => copyText(
                    context, _ayahShareText(selected), _ayahRef(selected)),
                onListen: () => AudioService.instance.playSurah(_surah,
                    startAyah: selected.numberInSurah),
              ),
              _AudioBar(surah: _surah),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAyahActions(BuildContext context, Ayah ayah) async {
    final state = AppState.instance;
    final bn = state.isBangla;
    final ref = _ayahRef(ayah);
    final translation = _translationText(ayah) ?? ayah.translation;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final bookmarked =
            state.isBookmarked(_surah.number, ayah.numberInSurah);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ref,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(translation,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                CopyShareRow(
                  onCopy: () {
                    Navigator.of(sheetContext).pop();
                    copyText(context, '${ayah.text}\n$translation\n($ref)', ref);
                  },
                  onShare: () {
                    Navigator.of(sheetContext).pop();
                    shareText(context, '${ayah.text}\n$translation\n($ref)');
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TonalButton(
                    label: bookmarked
                        ? tr('remove_bookmark')
                        : tr('bookmark_ayah'),
                    icon: bookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    onPressed: () {
                      state.toggleBookmark(
                          _surah.number, ayah.numberInSurah);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TonalButton(
                    label: bn
                        ? 'এই আয়াত থেকে তিলাওয়াত শুনুন'
                        : 'Listen from this ayah',
                    icon: Icons.play_arrow,
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      AudioService.instance.playSurah(_surah,
                          startAyah: ayah.numberInSurah);
                    },
                  ),
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

// ---------------- Surah header card (v3.0) ----------------

class _SurahHeaderCard extends StatelessWidget {
  final Surah surah;
  final String displayName;
  final String meaning;
  final String revelation;
  const _SurahHeaderCard({
    required this.surah,
    required this.displayName,
    required this.meaning,
    required this.revelation,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Container(
      decoration: greenHeroDecoration(),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(surah.name,
              style: const TextStyle(fontSize: 30, color: Colors.white)),
          const SizedBox(height: 4),
          Text(displayName,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(
              '$meaning · ${surah.ayahs.length} ${tr('ayahs')} · $revelation',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center),
          if (surah.number != 9 && surah.number != 1) ...[
            const SizedBox(height: 16),
            Text(_bismillah,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: state.arabicSize, height: 1.8, color: Colors.white)),
            const SizedBox(height: 8),
            const Text(_bismillahTransliteration,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.white70)),
          ],
        ],
      ),
    );
  }
}

// ---------------- Ayah card (v3.0) ----------------

class _AyahCard extends StatelessWidget {
  final Ayah ayah;
  final String? translation;
  final bool bookmarked;
  final bool isPlayingAyah;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onListen;
  const _AyahCard({
    required this.ayah,
    required this.translation,
    required this.bookmarked,
    required this.isPlayingAyah,
    required this.isSelected,
    required this.onTap,
    required this.onBookmark,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final bn = state.isBangla;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isPlayingAyah
          ? primaryGreen.withOpacity(0.08)
          : Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: BorderSide(
          color: isSelected
              ? primaryGreen
              : (isPlayingAyah
                  ? primaryGreen.withOpacity(0.5)
                  : Theme.of(context).dividerColor.withOpacity(0.5)),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: primaryGreen.withOpacity(0.4), width: 1.5),
                    ),
                    child: Text('${ayah.numberInSurah}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: primaryGreen)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(ayah.text,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: state.arabicSize, height: 2.0)),
                  ),
                  TonalIconButton(
                    icon: bookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    filled: bookmarked,
                    tooltip: bookmarked
                        ? tr('remove_bookmark')
                        : tr('bookmark_ayah'),
                    onPressed: onBookmark,
                  ),
                ],
              ),
              if (translation != null) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 46),
                  child: Text(
                    bn ? 'অনুবাদ (বাংলা)' : 'Translation (Bangla)',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: primaryGreen),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 46),
                  child: Text(translation!,
                      style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant)),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 46),
                  TonalIconButton(
                    icon: Icons.volume_up,
                    tooltip: bn ? 'এই আয়াত শুনুন' : 'Listen to this ayah',
                    onPressed: onListen,
                  ),
                  if (isPlayingAyah) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(tr('now_badge'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Bottom action row (v3.0, reference layout) ----------------

class _AyahActionRow extends StatelessWidget {
  final String ayahRef;
  final bool bookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final VoidCallback onAyah;
  final VoidCallback onCopy;
  final VoidCallback onListen;
  const _AyahActionRow({
    required this.ayahRef,
    required this.bookmarked,
    required this.onBookmark,
    required this.onShare,
    required this.onAyah,
    required this.onCopy,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ReaderAction(
            icon: bookmarked ? Icons.bookmark : Icons.bookmark_border,
            label: bn ? 'বুকমার্ক' : 'Bookmark',
            active: bookmarked,
            onTap: onBookmark,
          ),
          _ReaderAction(
            icon: Icons.share,
            label: tr('share'),
            onTap: onShare,
          ),
          _ReaderAction(
            icon: Icons.format_list_numbered,
            label: tr('ayah'),
            onTap: onAyah,
          ),
          PopupMenuButton<String>(
            tooltip: bn ? 'আরও' : 'More',
            onSelected: (value) {
              switch (value) {
                case 'copy':
                  onCopy();
                case 'share':
                  onShare();
                case 'listen':
                  onListen();
                case 'bookmark':
                  onBookmark();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'copy',
                  child: Text(bn ? 'কপি করুন' : 'Copy ayah')),
              PopupMenuItem(
                  value: 'share',
                  child: Text(bn ? 'শেয়ার করুন' : 'Share ayah')),
              PopupMenuItem(
                  value: 'listen',
                  child: Text(
                      bn ? 'এই আয়াত থেকে শুনুন' : 'Listen from this ayah')),
              PopupMenuItem(
                  value: 'bookmark',
                  child: Text(bookmarked
                      ? tr('remove_bookmark')
                      : tr('bookmark_ayah'))),
            ],
            child: Container(
              constraints: const BoxConstraints(minWidth: 64),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.more_vert,
                      size: 22,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 2),
                  Text(bn ? 'আরও' : 'More',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ReaderAction({
    required this.icon,
    required this.label,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minWidth: 64),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 22,
                color: active
                    ? primaryGreen
                    : Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active
                        ? primaryGreen
                        : Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

// ---------------- Audio player bar (v2.0, restyled v3.0) ----------------

/// Pinned to the bottom of the reader: prev / play-pause / next for the
/// current surah (streams per-ayah MP3s from EveryAyah, reciter Mishary
/// Alafasy), the ayah currently playing with ayah-based progress, and
/// a per-surah download button (offline playback from local files).
/// NOTE: the audio service exposes no position/duration stream, so the
/// progress shown here is ayah-based (playing ayah / total ayahs) —
/// never a faked elapsed time.
class _AudioBar extends StatelessWidget {
  final Surah surah;
  const _AudioBar({required this.surah});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;
    final bn = AppState.instance.isBangla;
    return ListenableBuilder(
      listenable: audio,
      builder: (context, _) {
        final isThisSurah = audio.playingSurah == surah.number;
        final downloaded = audio.isDownloaded(surah.number);
        final downloading = audio.downloadingSurah == surah.number;
        final playingAyah = audio.playingAyah ?? 1;
        final progress = isThisSurah
            ? (playingAyah / surah.ayahs.length).clamp(0.0, 1.0)
            : 0.0;
        final canPrev = isThisSurah && playingAyah > 1;
        final canNext = isThisSurah && playingAyah < surah.ayahs.length;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          padding:
              const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (audio.error != null &&
                  audio.errorSurah == surah.number) ...[
                Text(audio.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13)),
                const SizedBox(height: 4),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: primaryGreen.withOpacity(0.15),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(primaryGreen),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TonalIconButton(
                    icon: Icons.skip_previous,
                    tooltip: bn ? 'আগের আয়াত' : 'Previous ayah',
                    onPressed: canPrev
                        ? () => audio.playSurah(surah,
                            startAyah: playingAyah - 1)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        audio.isLoading && isThisSurah
                            ? Icons.hourglass_top
                            : (isThisSurah && audio.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                        color: Colors.white,
                        size: 30,
                      ),
                      tooltip: bn ? 'তিলাওয়াত' : 'Recitation',
                      onPressed: () {
                        if (isThisSurah && audio.isPlaying) {
                          audio.pause();
                        } else if (isThisSurah) {
                          audio.resume();
                        } else {
                          audio.playSurah(surah);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  TonalIconButton(
                    icon: Icons.skip_next,
                    tooltip: bn ? 'পরের আয়াত' : 'Next ayah',
                    onPressed: canNext
                        ? () => audio.playSurah(surah,
                            startAyah: playingAyah + 1)
                        : null,
                  ),
                  if (isThisSurah) ...[
                    const SizedBox(width: 4),
                    TonalIconButton(
                      icon: Icons.stop,
                      tooltip: bn ? 'থামান' : 'Stop',
                      onPressed: () => audio.stop(),
                    ),
                  ],
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isThisSurah
                              ? '${bn ? 'আয়াত' : 'Ayah'} $playingAyah / ${surah.ayahs.length}'
                              : (bn ? 'তিলাওয়াত শুনুন' : 'Listen to recitation'),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          downloaded
                              ? (bn
                                  ? 'মিশারি আল-আফাসি · অফলাইন'
                                  : 'Mishary Alafasy · offline')
                              : (bn
                                  ? 'মিশারি আল-আফাসি · স্ট্রিমিং'
                                  : 'Mishary Alafasy · streaming'),
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  if (downloading)
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: audio.downloadProgress,
                            color: primaryGreen,
                          ),
                          Text(
                              '${(audio.downloadProgress * 100).round()}',
                              style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    )
                  else if (downloaded)
                    TonalIconButton(
                      icon: Icons.download_done,
                      tooltip: bn ? 'ডাউনলোড মুছুন' : 'Delete download',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (d) => AlertDialog(
                            title: Text(bn
                                ? 'ডাউনলোড মুছবেন?'
                                : 'Delete download?'),
                            content: Text(bn
                                ? 'এই সূরার ডাউনলোড করা অডিও মুছে যাবে। পরে আবার ডাউনলোড করা যাবে।'
                                : 'The downloaded audio for this surah will be deleted. You can download it again later.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(d).pop(false),
                                child: Text(tr('cancel')),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.of(d).pop(true),
                                child: Text(tr('delete')),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          audio.deleteSurah(surah.number);
                        }
                      },
                    )
                  else
                    TonalIconButton(
                      icon: Icons.download,
                      tooltip: bn ? 'অফলাইনে শুনতে ডাউনলোড' : 'Download for offline',
                      onPressed: () async {
                        final ok = await audio.downloadSurah(surah);
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(audio.error ??
                                    (bn
                                        ? 'ডাউনলোড হয়নি'
                                        : 'Download failed'))),
                          );
                        }
                      },
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
