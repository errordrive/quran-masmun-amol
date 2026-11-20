// Me tab (v3.0 redesign, reference layout): green profile header,
// Credit Wallet card, Premium Access row, Bookmarks, Reading Progress
// (khatam), Settings, Help & Support — same navigation targets as
// before, restyled. Credit Store + Payment stay demo mode until Play
// Billing is wired. Azan toggles keep working (master + per-prayer,
// restyled) plus the new "আজানের শব্দ" toggle (v3.0).
import 'package:flutter/material.dart';
import '../data/duas.dart';
import '../data/hadith.dart';
import '../data/surah_ayah_counts.dart';
import '../data/surah_names_bn.dart';
import '../data/tasbih.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/azan_service.dart';
import '../services/prayer.dart';
import '../services/quran_service.dart';
import '../services/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'content.dart';
import 'khatam.dart';
import 'quran.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final bn = state.isBangla;
        final khatamPct =
            (state.khatamReadAyahs() / totalQuranAyahs * 100);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            // Profile header (reference layout): green gradient card.
            Container(
              decoration: greenHeroDecoration(),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        size: 34, color: primaryGreen),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('guest'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(tr('not_signed_in'),
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryGreenDark,
                      minimumSize: const Size(48, 44),
                    ),
                    onPressed: () => _showSignInDialog(context),
                    child: Text(tr('sign_in')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Credit Wallet card (reference layout): green, Buy pill.
            Container(
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
                    child: const Icon(Icons.stars,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('credit_balance'),
                            style: const TextStyle(color: Colors.white70)),
                        Text('${state.credits} ${tr('credits')}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryGreenDark,
                      minimumSize: const Size(48, 44),
                    ),
                    onPressed: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const CreditStoreScreen()),
                    ),
                    child: Text(tr('buy_credits')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _MeTile(
              icon: Icons.workspace_premium,
              iconColor: goldDark,
              title: bn ? 'প্রিমিয়াম অ্যাক্সেস' : 'Premium Access',
              subtitle: bn
                  ? 'প্রিমিয়াম প্যাকেজ দেখুন (ডেমো মোড)'
                  : 'View premium packages (demo mode)',
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (_) => const CreditStoreScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.bookmark,
              title: tr('bookmarks'),
              subtitle:
                  '${state.bookmarks.length} ${tr('ayahs_bookmarked')}',
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const BookmarksScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.checklist,
              title: tr('khatam'),
              subtitle: bn
                  ? '${khatamPct.toStringAsFixed(1)}% সম্পন্ন · ${state.khatamReadAyahs()} / $totalQuranAyahs আয়াত'
                  : '${khatamPct.toStringAsFixed(1)}% done · ${state.khatamReadAyahs()} / $totalQuranAyahs ayahs',
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const KhatamScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.favorite,
              title: tr('favorites'),
              subtitle: '${state.favoriteDuas.length} ${tr('duas_count')} · '
                  '${state.favoriteHadiths.length} ${tr('hadiths_count2')}',
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.receipt_long,
              title: tr('purchase_history'),
              subtitle:
                  '${state.purchases.length} ${tr('purchases_count')}',
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (_) => const PurchaseHistoryScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.settings,
              title: tr('settings'),
              subtitle: tr('settings_sub'),
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.help_outline,
              title: bn ? 'সাহায্য ও সহায়তা' : 'Help & Support',
              subtitle: bn
                  ? 'অ্যাপ ব্যবহারের সাহায্য ও তথ্য'
                  : 'Help using the app and info',
              onTap: () => _showHelpDialog(context),
            ),
            _MeTile(
              icon: Icons.info_outline,
              title: tr('about'),
              subtitle: '${tr('about_sub')} v3.0.0',
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              ),
            ),
            _MeTile(
              icon: Icons.logout,
              title: tr('sign_out'),
              subtitle: tr('signed_in_as_guest'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tr('guest_mode_msg'))));
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
        title: Text(tr('sign_in_title')),
        content: Text(tr('sign_in_body')),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(d).pop(),
            child: Text(tr('ok')),
          ),
        ],
      ),
    );
  }

  Future<void> _showHelpDialog(BuildContext context) async {
    final bn = AppState.instance.isBangla;
    await showDialog<void>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(bn ? 'সাহায্য ও সহায়তা' : 'Help & Support'),
        content: Text(bn
            ? 'নামাজের সময় আপনার ডিভাইসেই হিসাব করা হয় — ইন্টারনেট লাগে না। আজান নোটিফিকেশন চালু করতে Settings → আজান নোটিফিকেশন দেখুন। ক্রেডিট কেনাকাটা এখন ডেমো মোডে চলে; আসল পেমেন্ট এখনো চালু হয়নি। বিস্তারিত জানতে About পৃষ্ঠা দেখুন।'
            : 'Prayer times are calculated on your device — no internet needed. To turn on azan notifications, see Settings → Azan notifications. Credit purchases are in demo mode; real payments are not live yet. See the About page for details.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(d).pop(),
            child: Text(tr('ok')),
          ),
        ],
      ),
    );
  }
}

class _MeTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MeTile({
    required this.icon,
    this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (iconColor ?? primaryGreen).withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor ?? primaryGreen),
        ),
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
        final bn = state.isBangla;
        return AppScaffold(
          appBar: AppBar(title: Text(tr('settings'))),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionTitle(title: tr('language')),
              const SizedBox(height: 8),
              Text(tr('app_language')),
              const SizedBox(height: 4),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'bn', label: Text(tr('bangla'))),
                  ButtonSegment(value: 'en', label: Text(tr('english'))),
                ],
                selected: {state.uiLang},
                onSelectionChanged: (s) => state.setUiLang(s.first),
              ),
              const Divider(height: 32),
              SectionTitle(title: tr('appearance')),
              const SizedBox(height: 8),
              Text(tr('theme')),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                      value: ThemeMode.system, label: Text(tr('system'))),
                  ButtonSegment(
                      value: ThemeMode.light, label: Text(tr('light'))),
                  ButtonSegment(
                      value: ThemeMode.dark, label: Text(tr('dark'))),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (s) => state.setThemeMode(s.first),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(tr('arabic_text_size')),
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
                title: Text(tr('show_translation')),
                value: state.showTranslation,
                onChanged: (v) => state.setShowTranslation(v),
              ),
              if (state.showTranslation) ...[
                const SizedBox(height: 8),
                Text(tr('translation_lang')),
                const SizedBox(height: 4),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'bn', label: Text(tr('bangla'))),
                    ButtonSegment(value: 'en', label: Text(tr('english'))),
                  ],
                  selected: {state.translationLang},
                  onSelectionChanged: (s) =>
                      state.setTranslationLang(s.first),
                ),
              ],
              SwitchListTile(
                title: Text(tr('time_format_24h')),
                subtitle: Text(tr('time_format_sub')),
                value: state.use24h,
                onChanged: (v) => state.setUse24h(v),
              ),
              const Divider(),
              SectionTitle(title: tr('prayer')),
              const SizedBox(height: 8),
              Text(tr('calc_method')),
              const SizedBox(height: 4),
              for (final m in PrayerMethod.values)
                RadioListTile<PrayerMethod>(
                  title: Text(m.label),
                  value: m,
                  groupValue: state.prayerMethod,
                  onChanged: (v) {
                    if (v != null) {
                      state.setPrayerMethod(v);
                      AzanService.scheduleAll();
                    }
                  },
                ),
              SwitchListTile(
                title: Text(tr('asr_hanafi')),
                subtitle: Text(tr('asr_hanafi_sub')),
                value: state.asrHanafi,
                onChanged: (v) {
                  state.setAsrHanafi(v);
                  AzanService.scheduleAll();
                },
              ),
              const Divider(),
              SectionTitle(title: tr('azan_notif')),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(tr('azan_master')),
                subtitle: Text(tr('azan_master_sub')),
                value: state.azanEnabled,
                onChanged: (v) {
                  state.setAzanEnabled(v);
                  AzanService.scheduleAll();
                },
              ),
              // v3.0: azan sound on/off (real azan audio).
              SwitchListTile(
                title: Text(bn ? 'আজানের শব্দ' : 'Azan sound'),
                subtitle: Text(bn
                    ? 'নোটিফিকেশনের সঙ্গে আজানের শব্দ বাজবে'
                    : 'Play the azan sound with the notification'),
                value: state.azanSoundEnabled,
                onChanged: (v) {
                  state.setAzanSoundEnabled(v);
                  AzanService.scheduleAll();
                },
              ),
              if (state.azanEnabled)
                for (var i = 0; i < 5; i++)
                  SwitchListTile(
                    title: Text(displayPrayerName(
                        ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'][i],
                        DateTime.now())),
                    value: state.azanPrayers[i],
                    onChanged: (v) {
                      state.setAzanPrayer(i, v);
                      AzanService.scheduleAll();
                    },
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  tr('azan_note'),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              // v3.2: exact-alarm status + test azan.
              const _ExactAlarmRow(),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.volume_up, color: primaryGreen),
                ),
                title: Text(tr('azan_test')),
                subtitle: Text(tr('azan_test_sub')),
                trailing:
                    const Icon(Icons.play_arrow, color: primaryGreen),
                onTap: () => _testAzan(context),
              ),
              const Divider(),
              SwitchListTile(
                title: Text(tr('vibration_on_tap')),
                value: state.vibrationOn,
                onChanged: (v) => state.setVibration(v),
              ),
            ],
          ),
        );
      },
    );
  }

  /// v3.2: test azan — asks for notification permission if needed,
  /// then fires a test azan notification ~5 seconds later.
  Future<void> _testAzan(BuildContext context) async {
    final granted = await AzanService.requestNotificationPermission();
    if (!context.mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('azan_test_need_perm'))));
      return;
    }
    await AzanService.scheduleTestAzan();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(tr('azan_test_sent'))));
  }
}

/// v3.2: exact-alarm status row in Settings. Shows whether the system
/// lets the app fire azan at the exact prayer time; if not, explains
/// that azan may be a few minutes late and offers a button that opens
/// the system "Alarms & reminders" screen.
class _ExactAlarmRow extends StatefulWidget {
  const _ExactAlarmRow();
  @override
  State<_ExactAlarmRow> createState() => _ExactAlarmRowState();
}

class _ExactAlarmRowState extends State<_ExactAlarmRow> {
  bool? _exactOk;
  bool _asking = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final ok = await AzanService.canScheduleExactAlarms();
    if (mounted) setState(() => _exactOk = ok);
  }

  Future<void> _ask() async {
    setState(() => _asking = true);
    await AzanService.requestExactAlarms();
    await _refresh();
    if (mounted) setState(() => _asking = false);
  }

  @override
  Widget build(BuildContext context) {
    final granted = _exactOk ?? true;
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: (granted ? primaryGreen : Colors.orange).withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.alarm,
            color: granted ? primaryGreen : Colors.orange),
      ),
      title: Text(tr('exact_alarm_title')),
      subtitle:
          Text(granted ? tr('exact_alarm_on') : tr('exact_alarm_off')),
      trailing: _exactOk == null
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : granted
              ? const Icon(Icons.check_circle, color: primaryGreen)
              : FilledButton(
                  onPressed: _asking ? null : _ask,
                  child: Text(tr('exact_alarm_allow')),
                ),
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
        return AppScaffold(
          appBar: AppBar(title: Text(tr('buy_credits'))),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
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
                      child: const Icon(Icons.stars,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('current_balance'),
                            style: const TextStyle(color: Colors.white70)),
                        Text('${state.credits} ${tr('credits')}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  tr('demo_mode_note'),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.stars, color: primaryGreen),
                    ),
                    title: Row(
                      children: [
                        Text(pkg.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
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
                    subtitle:
                        Text('${pkg.credits} ${tr('credits')} · ${pkg.priceText}'),
                    trailing: FilledButton(
                      onPressed: () => Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (_) => PaymentScreen(package: pkg)),
                      ),
                      child: Text(tr('buy')),
                    ),
                  ),
                ),
              if (creditPackages.isEmpty)
                EmptyState(
                  icon: Icons.stars,
                  title: tr('no_packages_title'),
                  subtitle: tr('no_packages_sub'),
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
    return AppScaffold(
      appBar: AppBar(title: Text(tr('payment'))),
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
                  Text(
                      '${tr('received_credits')} ${widget.package.credits} ${tr('credits')}!',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('${tr('new_balance')}: ${state.credits} ${tr('credits')}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      child: Text(tr('done')),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(title: tr('order_summary')),
                          const SizedBox(height: 12),
                          _summaryRow(tr('package'), widget.package.name),
                          _summaryRow(
                              tr('credits'), '${widget.package.credits}'),
                          _summaryRow(tr('price'), widget.package.priceText),
                          const Divider(),
                          _summaryRow(tr('new_balance_after_payment'),
                              '${state.credits + widget.package.credits} ${tr('credits')}'),
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
                    child: Text(
                      tr('demo_payment_note'),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _processing ? null : _pay,
                      child: _processing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Text(tr('processing')),
                              ],
                            )
                          : Text(tr('pay_with_google_play')),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: _processing
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(tr('cancel')),
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
        final bn = state.isBangla;
        final favDuas =
            duas.where((d) => state.favoriteDuas.contains(d.id)).toList();
        final favHadiths = hadiths
            .where((h) =>
                state.favoriteHadiths.contains('${h.collection}|${h.number}'))
            .toList();
        if (favDuas.isEmpty && favHadiths.isEmpty) {
          return AppScaffold(
            appBar: AppBar(title: Text(tr('favorites'))),
            body: EmptyState(
              icon: Icons.favorite_border,
              title: tr('no_favorites_title'),
              subtitle: tr('no_favorites_sub'),
            ),
          );
        }
        return AppScaffold(
          appBar: AppBar(title: Text(tr('favorites'))),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              if (favDuas.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(tr('dua_group'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryGreen)),
                ),
                for (final d in favDuas)
                  ListTile(
                    leading:
                        const Icon(Icons.favorite, color: primaryGreen),
                    title: Text(bn ? d.banglaTitle : d.title),
                    subtitle: Text(d.reference,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => DuaDetailScreen(dua: d)),
                    ),
                  ),
              ],
              if (favHadiths.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(tr('hadith'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryGreen)),
                ),
                for (final h in favHadiths)
                  ListTile(
                    leading: const Icon(Icons.auto_stories,
                        color: primaryGreen),
                    title: Text('${h.collection} ${h.number}'),
                    subtitle: Text(bn ? h.banglaMeaning : h.english,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.of(context, rootNavigator: true).push(
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
        final bn = state.isBangla;
        if (_loading) {
          return AppScaffold(
            appBar: AppBar(title: Text(tr('bookmarks'))),
            body: const LoadingState(),
          );
        }
        final items = state.bookmarks.toList();
        if (items.isEmpty) {
          return AppScaffold(
            appBar: AppBar(title: Text(tr('bookmarks'))),
            body: EmptyState(
              icon: Icons.bookmark_border,
              title: tr('no_bookmarks_title'),
              subtitle: tr('no_bookmarks_sub'),
            ),
          );
        }
        return AppScaffold(
          appBar: AppBar(title: Text(tr('bookmarks'))),
          body: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.only(bottom: 32),
            itemBuilder: (context, i) {
              final parts = items[i].split(':');
              final surahNo = int.tryParse(parts[0]) ?? 0;
              final ayahNo = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
              final surah =
                  QuranService.instance.surahByNumber(_surahs, surahNo);
              final title = surah == null
                  ? '${tr('surah')} $surahNo:$ayahNo'
                  : '${bn ? bnSurahName(surah.number) : surah.englishName} $surahNo:$ayahNo';
              return ListTile(
                leading:
                    const Icon(Icons.bookmark, color: primaryGreen),
                title: Text(title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: tr('remove_bookmark'),
                  onPressed: () => state.toggleBookmark(surahNo, ayahNo),
                ),
                onTap: surah == null
                    ? null
                    : () => Navigator.of(context, rootNavigator: true).push(
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
          return AppScaffold(
            appBar: AppBar(title: Text(tr('purchase_history'))),
            body: EmptyState(
              icon: Icons.receipt_long,
              title: tr('no_purchases_title'),
              subtitle: tr('no_purchases_sub'),
            ),
          );
        }
        return AppScaffold(
          appBar: AppBar(title: Text(tr('purchase_history'))),
          body: ListView.builder(
            itemCount: state.purchases.length,
            padding: const EdgeInsets.only(bottom: 32),
            itemBuilder: (context, i) {
              final p = state.purchases[i];
              return ListTile(
                leading: const Icon(Icons.stars, color: primaryGreen),
                title: Text(p.packageName),
                subtitle: Text(
                    '${p.date.day}/${p.date.month}/${p.date.year} · ${p.status}'),
                trailing: Text('+${p.credits} ${tr('credits')}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
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
    return AppScaffold(
      appBar: AppBar(title: Text(tr('about'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(tr('app_name'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Version 3.0.0 (build 6)'),
          const SizedBox(height: 16),
          Text(tr('about_intro')),
          const SizedBox(height: 16),
          Text(tr('about_quran_text'),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(tr('about_quran_body')),
          const SizedBox(height: 16),
          Text(tr('about_prayer_times'),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(tr('about_prayer_body')),
          const SizedBox(height: 16),
          Text(tr('about_not_connected'),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(tr('about_not_connected_body')),
        ],
      ),
    );
  }
}
