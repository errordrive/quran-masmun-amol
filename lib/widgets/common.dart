// Shared UI (v1.1): subtle Islamic geometric texture, premium buttons,
// minimal floating navigation, top bar, copy/share, empty/loading states.
// The bottom NavigationBar lives ONLY in the three main tabs (via
// MainNavBar); sub-screens are plain AppScaffolds with no bar at all.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cities.dart';
import '../services/app_state.dart';
import '../services/azan_service.dart';
import '../services/navigation.dart';
import '../services/prayer.dart';
import '../services/strings.dart';
import '../screens/city_select.dart';
import '../services/widget_service.dart';
import '../theme.dart';

// ---------------- Subtle geometric texture ----------------

/// Very faint 8-point-star (two overlapping squares) pattern, drawn as
/// thin outlines on a grid. Light theme: green at ~4% opacity.
/// Dark theme: white at ~5%. Content readability always comes first.
class _StarPatternPainter extends CustomPainter {
  final bool dark;
  const _StarPatternPainter({required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final color = dark
        ? Colors.white.withOpacity(0.05)
        : primaryGreen.withOpacity(0.04);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const tile = 76.0;
    const r = 13.0; // star "radius" (half side of the squares)
    final rows = (size.height / tile).ceil() + 1;
    final cols = (size.width / tile).ceil() + 1;
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cx = col * tile + (row.isOdd ? tile / 2 : 0);
        final cy = row * tile;
        // Square 1 (axis-aligned) + square 2 (rotated 45°) = 8-point star.
        final p1 = Path()
          ..addRect(Rect.fromCenter(
              center: Offset(cx, cy), width: r * 2, height: r * 2));
        canvas.drawPath(p1, paint);
        // The 45-degree square, drawn as a diamond.
        final diag = r * 1.41421356;
        final p2 = Path()
          ..moveTo(cx, cy - diag)
          ..lineTo(cx + diag, cy)
          ..lineTo(cx, cy + diag)
          ..lineTo(cx - diag, cy)
          ..close();
        canvas.drawPath(p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_StarPatternPainter old) => old.dark != dark;
}

/// Scaffold with the subtle star pattern behind the body.
/// Used by EVERY screen so the premium texture is app-wide.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _StarPatternPainter(dark: dark),
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}

// ---------------- Premium buttons ----------------

/// Primary CTA: full-width filled green button, 52px, radius 16, icon + label.
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expanded;
  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = icon == null
        ? FilledButton(
            onPressed: onPressed,
            child: Text(label),
          )
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 20),
            label: Text(label),
          );
    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

/// Secondary action: light-green tonal fill, dark-green text, 52px, radius 16.
class TonalButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const TonalButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = FilledButton.styleFrom(
      backgroundColor:
          dark ? Colors.white.withOpacity(0.12) : primaryGreen.withOpacity(0.12),
      foregroundColor: dark ? Colors.white : primaryGreenDark,
      minimumSize: const Size(48, buttonHeight),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );
    if (icon == null) {
      return FilledButton(onPressed: onPressed, style: style, child: Text(label));
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}

/// 44px circular tonal icon button.
class TonalIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool filled;
  const TonalIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = filled
        ? primaryGreen
        : (dark
            ? Colors.white.withOpacity(0.12)
            : primaryGreen.withOpacity(0.12));
    final fg = filled
        ? Colors.white
        : (dark ? Colors.white : primaryGreenDark);
    final button = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: fg, size: 22),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        splashRadius: 22,
      ),
    );
    return button;
  }
}

/// Segmented tonal Copy / Share / Favorite action row for detail screens.
class CopyShareRow extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final bool? isFavorite;
  final VoidCallback? onFavorite;
  const CopyShareRow({
    super.key,
    required this.onCopy,
    required this.onShare,
    this.isFavorite,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TonalButton(
            label: tr('copy'),
            icon: Icons.copy,
            onPressed: onCopy,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TonalButton(
            label: tr('share'),
            icon: Icons.share,
            onPressed: onShare,
          ),
        ),
        if (isFavorite != null && onFavorite != null) ...[
          const SizedBox(width: 8),
          TonalIconButton(
            icon: isFavorite! ? Icons.favorite : Icons.favorite_border,
            filled: isFavorite!,
            tooltip: tr('favorite'),
            onPressed: onFavorite,
          ),
        ],
      ],
    );
  }
}

/// Section heading: larger title (20px) with an optional trailing action.
class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? action;
  const SectionTitle({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        if (action != null) action!,
      ],
    );
  }
}

// ---------------- Minimal floating navigation (main tabs ONLY) ----------------

/// Minimal floating bottom nav — NO background container, NO pill, NO
/// border, NO shadow. Just 3 tappable items in a transparent Row,
/// floating slightly above the system gesture area (SafeArea supplies
/// the bottom inset). Active item: green rounded rectangle with a white
/// icon + white label; inactive items: muted grey icon + label, no
/// background at all. Custom widget — NOT BottomNavigationBar and NOT
/// Material NavigationBar. Shown only on the 3 main tabs (Home/Prayer/
/// Me); sub-screens are plain AppScaffolds with no bar at all.
class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentTab,
      builder: (context, index, _) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: tr('tab_home'),
                  selected: index == 0,
                  onTap: () => goToTab(0),
                ),
                _NavItem(
                  icon: Icons.access_time_outlined,
                  selectedIcon: Icons.access_time,
                  label: tr('tab_prayer'),
                  selected: index == 1,
                  onTap: () => goToTab(1),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: tr('tab_me'),
                  selected: index == 2,
                  onTap: () => goToTab(2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // onSurfaceVariant is a readable muted grey in both light and dark.
    final inactiveColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? selectedIcon : icon,
                size: 24,
                color: selected ? Colors.white : inactiveColor),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? Colors.white : inactiveColor)),
          ],
        ),
      ),
    );
  }
}

// ---------------- Copy / share ----------------

Future<void> copyText(BuildContext context, String text, String label) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label ${tr('copied')}')),
    );
  }
}

/// No share plugin is bundled (minimal dependencies), so Share copies the
/// text and tells the user to paste it anywhere.
Future<void> shareText(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr('copied_clipboard'))),
    );
  }
}

// ---------------- States ----------------

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: dark
                    ? Colors.white.withOpacity(0.10)
                    : primaryGreen.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: primaryGreen),
            ),
            const SizedBox(height: 16),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Centered loading state: spinner + text. Never a bottom bar.
class LoadingState extends StatelessWidget {
  final String? message;
  const LoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: primaryGreen),
          const SizedBox(height: 16),
          Text(message ?? tr('loading'),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ---------------- Common top bar ----------------

/// Common top bar for Home / Prayer / Me: location chip, search box, avatar.
class AppTopBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  const AppTopBar({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Row(
          children: [
            InkWell(
              onTap: () => showLocationPicker(context),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        size: 18, color: primaryGreen),
                    const SizedBox(width: 4),
                    Text(state.cityName,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: onSearchTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color:
                            Theme.of(context).dividerColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(tr('search_hint'),
                            style: TextStyle(color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            TonalIconButton(
              icon: Icons.person,
              tooltip: tr('tab_me'),
              onPressed: () => goToTab(2),
            ),
          ],
        );
      },
    );
  }
}

/// Opens the full "Select City" screen (v3.1): search, current
/// location, popular cities, alphabetical list + A–Z rail.
/// Kept as a function so the Home/Prayer call sites are unchanged.
Future<void> showLocationPicker(BuildContext context) async {
  await Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(builder: (_) => const CitySelectScreen()),
  );
}

// ---------------- v3.0 redesign: shared hero / strip / tiles ----------------

/// Compact countdown for hero cards: "2h 12m left" (not HH:MM:SS).
String formatCountdownShort(Duration d) {
  if (d.isNegative) d = Duration.zero;
  final h = d.inHours;
  final m = d.inMinutes % 60;
  final bn = AppState.instance.isBangla;
  if (h > 0) {
    return bn ? '$hঘ ${m}মি বাকি' : '$h h ${m}m left';
  }
  final s = d.inSeconds % 60;
  return bn ? '${m}মি ${s}সে বাকি' : '$m m ${s}s left';
}

/// Icon per prayer (used by the strip, the Prayer list and the calendar).
IconData prayerIcon(String english) {
  switch (english) {
    case 'Fajr':
      return Icons.mosque;
    case 'Sunrise':
      return Icons.wb_sunny;
    case 'Dhuhr':
      return Icons.mosque;
    case 'Asr':
      return Icons.wb_twilight;
    case 'Maghrib':
      return Icons.nights_stay;
    case 'Isha':
      return Icons.nightlight_round;
    default:
      return Icons.access_time;
  }
}

/// Green gradient hero decoration (splash + Next Prayer hero only),
/// with a soft shadow so the card lifts off the white content area.
BoxDecoration greenHeroDecoration({double radius = 20}) {
  return BoxDecoration(
    gradient: heroGreenGradient,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: deepGreen.withOpacity(0.25),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );
}

/// Next Prayer hero card (v3.0, reference layout): deep-green gradient,
/// faint star pattern + a large mosque icon, "Next Prayer" label, the
/// prayer name (via displayPrayerName — Jumu'ah on Fridays), the time
/// in gold, and the countdown. Tapping opens the Prayer tab.
class NextPrayerHero extends StatelessWidget {
  final String prayerEnglish;
  final DateTime prayerDate;
  final DateTime time;
  final Duration countdown;
  final String cityName;
  final VoidCallback? onTap;
  const NextPrayerHero({
    super.key,
    required this.prayerEnglish,
    required this.prayerDate,
    required this.time,
    required this.countdown,
    required this.cityName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = Container(
      decoration: greenHeroDecoration(),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: _StarPatternPainter(dark: true),
              ),
            ),
          ),
          const Positioned(
            right: 8,
            bottom: 4,
            child: Icon(Icons.mosque, size: 96, color: Colors.white12),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 18, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      tr('next_prayer'),
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.white70),
                        const SizedBox(width: 2),
                        Text(cityName,
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  displayPrayerName(prayerEnglish, prayerDate),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  formatTime(time, use24h: state.use24h),
                  style: const TextStyle(
                      color: goldAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    formatCountdownShort(countdown),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: card,
    );
  }
}

/// Prayer strip (v3.0, reference layout): one row of all 6 prayers with
/// icon + Bangla name (via displayPrayerName) + time; the next prayer
/// is highlighted in green. Tapping opens the Prayer tab.
class PrayerStrip extends StatelessWidget {
  final DayPrayerTimes times;
  final String nextEnglish;
  final DateTime date;
  final VoidCallback? onTap;
  const PrayerStrip({
    super.key,
    required this.times,
    required this.nextEnglish,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final strip = Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            for (final (name, time) in times.ordered)
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  decoration: BoxDecoration(
                    color: name == nextEnglish
                        ? primaryGreen.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(prayerIcon(name),
                          size: 22,
                          color: name == nextEnglish
                              ? primaryGreen
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                      const SizedBox(height: 4),
                      Text(
                        displayPrayerName(name, date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: name == nextEnglish
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: name == nextEnglish ? primaryGreen : null,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatTime(time, use24h: state.use24h),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: name == nextEnglish
                              ? primaryGreen
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Green check when prayed today (v3.1); Sunrise
                      // has no mark, so the slot stays empty.
                      SizedBox(
                        height: 16,
                        child: prayerIndexFor(name) >= 0 &&
                                state.isPrayerMarked(
                                    date, prayerIndexFor(name))
                            ? const Icon(Icons.check_circle,
                                size: 15, color: primaryGreen)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (onTap == null) return strip;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: strip,
    );
  }
}

/// Vertical category tile (v3.0, reference layout): icon in a green
/// tinted rounded square, label underneath. Optional [badge] (e.g. "99"
/// for Asmaul Husna) shows as a small gold circle at the icon corner.
class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
  const CategoryTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: primaryGreen, size: 26),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: goldAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, height: 1.3),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple mosque silhouette (domes + minarets) drawn with shapes only —
/// no image assets. Used on the splash screen (white, low opacity).
class MosqueSilhouettePainter extends CustomPainter {
  final Color color;
  const MosqueSilhouettePainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.16)
      ..style = PaintingStyle.fill;
    final baseY = size.height * 0.86;
    // Ground band.
    canvas.drawRect(
        Rect.fromLTWH(0, baseY, size.width, size.height - baseY), paint);
    // Central dome (upper half-circle).
    final cx = size.width / 2;
    final domeR = size.width * 0.17;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, baseY), radius: domeR),
        3.14159265,
        3.14159265,
        true,
        paint);
    // Finial above the dome.
    canvas.drawCircle(Offset(cx, baseY - domeR - 10), 4, paint);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(cx, baseY - domeR - 4), width: 3, height: 12),
        paint);
    // Side domes.
    for (final dx in [-0.26, 0.26]) {
      final sx = cx + dx * size.width;
      final r = size.width * 0.09;
      canvas.drawArc(Rect.fromCircle(center: Offset(sx, baseY), radius: r),
          3.14159265, 3.14159265, true, paint);
    }
    // Minarets.
    for (final mx in [size.width * 0.06, size.width * 0.94]) {
      final w = size.width * 0.045;
      final top = size.height * 0.42;
      canvas.drawRect(Rect.fromLTWH(mx - w / 2, top, w, baseY - top), paint);
      canvas.drawArc(
          Rect.fromCircle(center: Offset(mx, top), radius: w * 0.9),
          3.14159265,
          3.14159265,
          true,
          paint);
      canvas.drawCircle(Offset(mx, top - w * 0.9 - 4), 3, paint);
    }
  }

  @override
  bool shouldRepaint(MosqueSilhouettePainter old) => old.color != color;
}

/// Crescent moon drawn with two circles (difference) — no image asset.
class CrescentPainter extends CustomPainter {
  final Color color;
  const CrescentPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final r = size.width / 2;
    final outer = Path()
      ..addOval(Rect.fromCircle(center: Offset(r, r), radius: r));
    final inner = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(r * 1.35, r * 0.82), radius: r * 0.92));
    canvas.drawPath(
        Path.combine(PathOperation.difference, outer, inner), paint);
  }

  @override
  bool shouldRepaint(CrescentPainter old) => old.color != color;
}

/// Small hanging lantern (line + amber glow + star) for the splash.
class HangingLantern extends StatelessWidget {
  const HangingLantern({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 2, height: 44, color: Colors.white.withOpacity(0.5)),
        Container(
          width: 34,
          height: 44,
          decoration: BoxDecoration(
            color: amberAccent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: amberAccent.withOpacity(0.55),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.star, size: 18, color: Colors.white),
        ),
      ],
    );
  }
}
