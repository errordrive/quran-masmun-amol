// City Select screen (v3.1, from the prayer-app reference video):
// search bar, "Current Location" row, "Popular Cities" chips, the
// full city list grouped alphabetically with letter section headers,
// and a right-side A–Z fast-scroll rail (tap or drag a letter to jump,
// current letter highlighted green). Selecting a city applies it
// everywhere (prayer times, widget, azan) exactly like the old picker.
// Plain Scaffold (no common.dart import) to avoid an import cycle:
// common.dart's showLocationPicker pushes this screen.
import 'package:flutter/material.dart';
import '../data/cities.dart';
import '../services/app_state.dart';
import '../services/azan_service.dart';
import '../services/strings.dart';
import '../services/widget_service.dart';
import '../theme.dart';

/// The 8 Bangladeshi divisional cities shown as quick chips.
const List<String> _popularCityNames = [
  'Dhaka',
  'Chattogram',
  'Khulna',
  'Rajshahi',
  'Mymensingh',
  'Sylhet',
  'Rangpur',
  'Barishal',
];

class CitySelectScreen extends StatefulWidget {
  const CitySelectScreen({super.key});
  @override
  State<CitySelectScreen> createState() => _CitySelectScreenState();
}

class _CitySelectScreenState extends State<CitySelectScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  String _query = '';
  String? _dragLetter;

  // Alphabetical sections, computed once (city list is bundled/static).
  late final List<({String letter, List<City> cities})> _sections;
  // Scroll offset of each section header inside the section ListView.
  // Row heights are fixed (header 36, city tile 56) so offsets are
  // exact arithmetic — no post-frame measuring needed.
  late final List<double> _sectionOffsets;
  static const double _headerHeight = 36;
  static const double _tileHeight = 56;

  String _currentLetter = '';

  @override
  void initState() {
    super.initState();
    final sorted = [...cities]..sort((a, b) => a.name.compareTo(b.name));
    final byLetter = <String, List<City>>{};
    for (final c in sorted) {
      final letter = c.name[0].toUpperCase();
      (byLetter[letter] ??= []).add(c);
    }
    _sections = byLetter.entries
        .map((e) => (letter: e.key, cities: e.value))
        .toList();
    var offset = 0.0;
    _sectionOffsets = [];
    for (final s in _sections) {
      _sectionOffsets.add(offset);
      offset += _headerHeight + _tileHeight * s.cities.length;
    }
    _currentLetter = _sections.isNotEmpty ? _sections.first.letter : '';
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_query.isNotEmpty) return;
    final pos = _scrollCtrl.offset;
    var letter = _sections.first.letter;
    for (var i = 0; i < _sections.length; i++) {
      if (pos + 8 >= _sectionOffsets[i]) {
        letter = _sections[i].letter;
      } else {
        break;
      }
    }
    if (letter != _currentLetter) {
      setState(() => _currentLetter = letter);
    }
  }

  void _jumpToLetter(String letter) {
    final i = _sections.indexWhere((s) => s.letter == letter);
    if (i < 0) return;
    setState(() => _currentLetter = letter);
    _scrollCtrl.animateTo(
      _sectionOffsets[i],
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _selectCity(City city) {
    final state = AppState.instance;
    state.setCity(city.name);
    // City drives prayer times, azan and widget.
    AzanService.scheduleAll();
    HomeWidgetService.update();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${tr('location_set_to')} ${city.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final q = _query.trim().toLowerCase();
    final searching = q.isNotEmpty;
    final filtered = searching
        ? cities
            .where((c) =>
                c.name.toLowerCase().contains(q) ||
                c.country.toLowerCase().contains(q))
            .toList()
        : <City>[];
    final letters = _sections.map((s) => s.letter).toList();

    return Scaffold(
      appBar: AppBar(title: Text(tr('select_city'))),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: tr('search_city'),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              if (!searching) ...[
                // Current Location.
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(tr('current_location'),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800)),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on,
                        color: Colors.white, size: 22),
                  ),
                  title: Text(
                      '${state.cityName}, ${state.city.country}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  trailing: const Icon(Icons.check, color: primaryGreen),
                ),
                // Popular Cities.
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(tr('popular_cities'),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final name in _popularCityNames)
                        _PopularChip(
                          name: name,
                          selected: name == state.cityName,
                          onTap: () => _selectCity(cityByName(name)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: Stack(
                  children: [
                    searching
                        ? _buildSearchList(filtered)
                        : _buildSectionList(state),
                    // A–Z fast-scroll rail (hidden while searching).
                    if (!searching)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: 30,
                        child: _LetterRail(
                          letters: letters,
                          currentLetter: _currentLetter,
                          onLetter: _jumpToLetter,
                          onDragStart: (l) =>
                              setState(() => _dragLetter = l),
                          onDragEnd: () =>
                              setState(() => _dragLetter = null),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Big letter bubble while dragging the rail.
          if (_dragLetter != null)
            Center(
              child: Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(_dragLetter!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchList(List<City> filtered) {
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(tr('no_city_found'),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(tr('try_spelling'),
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: filtered.length,
      padding: const EdgeInsets.only(bottom: 32),
      itemBuilder: (context, i) => _CityTile(
        city: filtered[i],
        selected: filtered[i].name == AppState.instance.cityName,
        onTap: () => _selectCity(filtered[i]),
      ),
    );
  }

  Widget _buildSectionList(AppState state) {
    var tileIndex = 0;
    final children = <Widget>[];
    for (var s = 0; s < _sections.length; s++) {
      final section = _sections[s];
      children.add(
        Container(
          height: _headerHeight,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest
              .withOpacity(0.45),
          child: Text(section.letter,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: primaryGreen)),
        ),
      );
      for (final c in section.cities) {
        tileIndex++;
        children.add(_CityTile(
          key: ValueKey('city_$tileIndex'),
          city: c,
          selected: c.name == state.cityName,
          onTap: () => _selectCity(c),
        ));
      }
    }
    return ListView(
      controller: _scrollCtrl,
      padding: const EdgeInsets.only(bottom: 32, right: 30),
      children: children,
    );
  }
}

class _PopularChip extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;
  const _PopularChip(
      {required this.name, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? primaryGreen
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected
                  ? primaryGreen
                  : Theme.of(context).dividerColor),
        ),
        child: Text(name,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface)),
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  final City city;
  final bool selected;
  final VoidCallback onTap;
  const _CityTile(
      {super.key,
      required this.city,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListTile(
        leading:
            const Icon(Icons.location_on, color: primaryGreen, size: 22),
        title: Text(city.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(city.country,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: selected
            ? const Icon(Icons.check, color: primaryGreen)
            : null,
        onTap: onTap,
      ),
    );
  }
}

/// Right-side A–Z rail: tap or drag a letter to jump to that section.
/// The current letter is highlighted green, like the reference video.
class _LetterRail extends StatelessWidget {
  final List<String> letters;
  final String currentLetter;
  final ValueChanged<String> onLetter;
  final ValueChanged<String> onDragStart;
  final VoidCallback onDragEnd;
  const _LetterRail({
    required this.letters,
    required this.currentLetter,
    required this.onLetter,
    required this.onDragStart,
    required this.onDragEnd,
  });

  String _letterAt(Offset local, double height) {
    if (letters.isEmpty) return '';
    final i = (local.dy / height * letters.length)
        .floor()
        .clamp(0, letters.length - 1);
    return letters[i];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => onLetter(_letterAt(d.localPosition, height)),
          onVerticalDragStart: (d) =>
              onDragStart(_letterAt(d.localPosition, height)),
          onVerticalDragUpdate: (d) {
            final letter = _letterAt(d.localPosition, height);
            onDragStart(letter);
            onLetter(letter);
          },
          onVerticalDragEnd: (_) => onDragEnd(),
          onVerticalDragCancel: onDragEnd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final l in letters)
                Expanded(
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: l == currentLetter
                            ? primaryGreen
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        l,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: l == currentLetter
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: l == currentLetter
                              ? Colors.white
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
