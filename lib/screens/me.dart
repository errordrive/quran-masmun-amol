// Me tab: guest profile, credit balance, Favorites, Bookmarks,
// Purchase History, Settings, About, Sign out — plus the Credit Store
// and Payment page (demo mode until Play Billing is wired).
import 'package:flutter/material.dart';
import '../data/duas.dart';
import '../data/hadith.dart';
import '../data/tasbih.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/prayer.dart';
import '../services/quran_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'content.dart';
import 'quran.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            AppTopBar(
              onSearchTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
            ),
            const SizedBox(height: 16),
            // Profile card (guest)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person,
                          size: 32, color: primaryGreen),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Guest',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          Text('Not signed in',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () => _showSignInDialog(context),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Credit balance card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.stars,
                          color: primaryGreen, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Credit balance',
                              style: TextStyle(color: Colors.grey)),
                          Text('${state.credits} credits',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const CreditStoreScreen()),
                      ),
                      child: const Text('Buy Credits'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _MeTile(
              icon: Icons.favorite,
              title: 'Favorites',
              subtitle: '${state.favoriteDuas.length} duas · '
                  '${state.favoriteHadiths.length} hadiths',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.bookmark,
              title: 'Bookmarks',
              subtitle: '${state.bookmarks.length} ayahs bookmarked',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BookmarksScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.receipt_long,
              title: 'Purchase History',
              subtitle: '${state.purchases.length} purchases',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const PurchaseHistoryScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Theme, text size, prayer method',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Quran & Masnun Amol v1.0.0',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.logout,
              title: 'Sign out',
              subtitle: 'You are signed in as Guest',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('You are already using Guest mode.')));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSignInDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Sign in with Google'),
        content: const Text(
            'Google sign-in needs Firebase Authentication setup first. '
            'This version of the app runs fully offline as a guest, and '
            'all your favorites, bookmarks and credits are stored on this device.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(d).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _MeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: primaryGreen),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

// ---------------- Settings ----------------

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Appearance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Theme'),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('System')),
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (s) => state.setThemeMode(s.first),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Arabic text size'),
                  const Spacer(),
                  Text('${state.arabicSize.toInt()}'),
                ],
              ),
              Slider(
                value: state.arabicSize,
                min: 18,
                max: 36,
                divisions: 9,
                label: '${state.arabicSize.toInt()}',
                onChanged: (v) => state.setArabicSize(v),
              ),
              SwitchListTile(
                title: const Text('Show translation in reader'),
                value: state.showTranslation,
                onChanged: (v) => state.setShowTranslation(v),
              ),
              if (state.showTranslation) ...[
                const SizedBox(height: 8),
                const Text('Translation language'),
                const SizedBox(height: 4),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'en', label: Text('English')),
                    ButtonSegment(value: 'bn', label: Text('Bangla')),
                  ],
                  selected: {state.translationLang},
                  onSelectionChanged: (s) =>
                      state.setTranslationLang(s.first),
                ),
              ],
              SwitchListTile(
                title: const Text('24-hour time format'),
                subtitle: const Text('Off = 12-hour (AM/PM)'),
                value: state.use24h,
                onChanged: (v) => state.setUse24h(v),
              ),
              const Divider(),
              const Text('Prayer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Calculation method'),
              const SizedBox(height: 4),
              for (final m in PrayerMethod.values)
                RadioListTile<PrayerMethod>(
                  title: Text(m.label),
                  value: m,
                  groupValue: state.prayerMethod,
                  onChanged: (v) {
                    if (v != null) state.setPrayerMethod(v);
                  },
                ),
              SwitchListTile(
                title: const Text('Asr method: Hanafi'),
                subtitle: const Text('Off = Standard. On = Hanafi (later Asr).'),
                value: state.asrHanafi,
                onChanged: (v) => state.setAsrHanafi(v),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Vibration on tasbih tap'),
                value: state.vibrationOn,
                onChanged: (v) => state.setVibration(v),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- Credit Store + Payment (demo mode) ----------------

class CreditStoreScreen extends StatelessWidget {
  const CreditStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Buy Credits')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: primaryGreen, size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current balance',
                              style: TextStyle(color: Colors.grey)),
                          Text('${state.credits} credits',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Demo mode: prices below are placeholders. Real Google Play '
                  'pricing needs Play Console products and the verification Worker.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              for (final pkg in creditPackages)
                Card(
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.stars, color: primaryGreen),
                    ),
                    title: Row(
                      children: [
                        Text(pkg.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        if (pkg.badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(pkg.badge!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text('${pkg.credits} credits · ${pkg.priceText}'),
                    trailing: FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => PaymentScreen(package: pkg)),
                      ),
                      child: const Text('Buy'),
                    ),
                  ),
                ),
              if (creditPackages.isEmpty)
                const EmptyState(
                  icon: Icons.stars,
                  title: 'No packages available right now',
                  subtitle: 'Please check back later.',
                ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final CreditPackage package;
  const PaymentScreen({super.key, required this.package});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _processing = false;
  bool _success = false;

  Future<void> _pay() async {
    setState(() => _processing = true);
    // Simulated processing: in the real build this starts Google Play Billing.
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    AppState.instance.addCredits(widget.package);
    setState(() {
      _processing = false;
      _success = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _success
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      color: primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 24),
                  Text('You received ${widget.package.credits} credits!',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('New balance: ${state.credits} credits',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Order summary',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          _summaryRow('Package', widget.package.name),
                          _summaryRow(
                              'Credits', '${widget.package.credits}'),
                          _summaryRow('Price', widget.package.priceText),
                          const Divider(),
                          _summaryRow('New balance after payment',
                              '${state.credits + widget.package.credits} credits'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Demo mode: this is a simulated payment. Real Play Billing '
                      'needs Google Play Console products plus the verification '
                      'Worker — no real money is charged here.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _processing ? null : _pay,
                      child: _processing
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                ),
                                SizedBox(width: 12),
                                Text('Processing…'),
                              ],
                            )
                          : const Text('Pay with Google Play'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: _processing
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ---------------- Favorites / Bookmarks / History / About ----------------

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final favDuas =
            duas.where((d) => state.favoriteDuas.contains(d.id)).toList();
        final favHadiths = hadiths
            .where((h) =>
                state.favoriteHadiths.contains('${h.collection}|${h.number}'))
            .toList();
        if (favDuas.isEmpty && favHadiths.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Favorites')),
            body: const EmptyState(
              icon: Icons.favorite_border,
              title: 'No favorites yet',
              subtitle:
                  'Tap the heart on any dua or hadith to save it here.',
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Favorites')),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              if (favDuas.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text('Duas',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryGreen)),
                ),
                for (final d in favDuas)
                  ListTile(
                    leading:
                        const Icon(Icons.favorite, color: primaryGreen),
                    title: Text(d.title),
                    subtitle: Text(d.reference,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => DuaDetailScreen(dua: d)),
                    ),
                  ),
              ],
              if (favHadiths.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text('Hadith',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryGreen)),
                ),
                for (final h in favHadiths)
                  ListTile(
                    leading: const Icon(Icons.auto_stories,
                        color: primaryGreen),
                    title: Text('${h.collection} ${h.number}'),
                    subtitle: Text(h.english,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => HadithDetailScreen(hadith: h)),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});
  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Surah> _surahs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    QuranService.instance.loadSurahs().then((s) {
      if (mounted) setState(() {
        _surahs = s;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        if (_loading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Bookmarks')),
            body: const LoadingState(),
          );
        }
        final items = state.bookmarks.toList();
        if (items.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Bookmarks')),
            body: const EmptyState(
              icon: Icons.bookmark_border,
              title: 'No bookmarks yet',
              subtitle: 'Tap an ayah in the reader and choose Bookmark.',
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Bookmarks')),
          body: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.only(bottom: 16),
            itemBuilder: (context, i) {
              final parts = items[i].split(':');
              final surahNo = int.tryParse(parts[0]) ?? 0;
              final ayahNo = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
              final surah =
                  QuranService.instance.surahByNumber(_surahs, surahNo);
              final title = surah == null
                  ? 'Surah $surahNo:$ayahNo'
                  : '${surah.englishName} $surahNo:$ayahNo';
              return ListTile(
                leading:
                    const Icon(Icons.bookmark, color: primaryGreen),
                title: Text(title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remove bookmark',
                  onPressed: () => state.toggleBookmark(surahNo, ayahNo),
                ),
                onTap: surah == null
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => QuranReaderScreen(
                                  surah: surah,
                                  surahs: _surahs,
                                  initialAyah: ayahNo)),
                        ),
              );
            },
          ),
        );
      },
    );
  }
}

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        if (state.purchases.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Purchase History')),
            body: const EmptyState(
              icon: Icons.receipt_long,
              title: 'No purchases yet',
              subtitle: 'Your credit purchases will appear here.',
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Purchase History')),
          body: ListView.builder(
            itemCount: state.purchases.length,
            padding: const EdgeInsets.only(bottom: 16),
            itemBuilder: (context, i) {
              final p = state.purchases[i];
              return ListTile(
                leading: const Icon(Icons.stars, color: primaryGreen),
                title: Text(p.packageName),
                subtitle: Text(
                    '${p.date.day}/${p.date.month}/${p.date.year} · ${p.status}'),
                trailing: Text('+${p.credits} credits',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              );
            },
          ),
        );
      },
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Quran & Masnun Amol',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          SizedBox(height: 4),
          Text('Version 1.0.0 (build 1)'),
          SizedBox(height: 16),
          Text(
              'A clean, minimal Islamic companion app: prayer times, the full Quran, '
              'Hadith, daily duas, masnun amol and tasbih — all working offline.'),
          SizedBox(height: 16),
          Text('Quran text',
              style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 4),
          Text(
              'Arabic text: Uthmani script. English translation: Sahih International. '
              'Bundled in the app, no internet needed.'),
          SizedBox(height: 16),
          Text('Prayer times',
              style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 4),
          Text(
              'Calculated on your device with the standard solar algorithm. '
              'Default method: Karachi (University of Islamic Sciences). '
              'Hijri dates use an arithmetic approximation and may differ by a day.'),
          SizedBox(height: 16),
          Text('Not yet connected',
              style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 4),
          Text(
              'Google sign-in (Firebase), real Play Billing purchases, and the '
              'admin panel need setup in Firebase and Google Play Console. '
              'Until then the app runs fully as a guest, and payments run in demo mode.'),
        ],
      ),
    );
  }
}
