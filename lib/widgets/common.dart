// Shared UI (v1.1): subtle Islamic geometric texture, premium buttons,
// floating pill navigation, top bar, copy/share, empty/loading states.
// The bottom NavigationBar lives ONLY in the three main tabs (via
// MainNavBar); sub-screens are plain AppScaffolds with no bar at all.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cities.dart';
import '../services/app_state.dart';
import '../services/navigation.dart';
import '../services/strings.dart';
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

// ---------------- Floating pill navigation (main tabs ONLY) ----------------

/// Custom floating pill bar: selected item is a filled green pill with a
/// white icon + white label; unselected items are grey. Used as the
/// bottomNavigationBar of each main tab's own Scaffold — never on
/// sub-screens, which are plain AppScaffolds without this bar.
class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor =
        dark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor =
        dark ? const Color(0xFF2E2E2E) : const Color(0xFFE5E5E0);
    return ValueListenableBuilder<int>(
      valueListenable: currentTab,
      builder: (context, index, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(dark ? 0.35 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                _NavPill(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: tr('tab_home'),
                  selected: index == 0,
                  onTap: () => goToTab(0),
                ),
                _NavPill(
                  icon: Icons.access_time_outlined,
                  selectedIcon: Icons.access_time,
                  label: tr('tab_prayer'),
                  selected: index == 1,
                  onTap: () => goToTab(1),
                ),
                _NavPill(
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

class _NavPill extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavPill({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: selected ? primaryGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(selected ? selectedIcon : icon,
                    size: 24,
                    color: selected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 2),
                Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
              ],
            ),
          ),
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

Future<void> showLocationPicker(BuildContext context) async {
  final state = AppState.instance;
  String query = '';
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final filtered = cities.where((c) {
            final q = query.trim().toLowerCase();
            if (q.isEmpty) return true;
            return c.name.toLowerCase().contains(q) ||
                c.country.toLowerCase().contains(q);
          }).toList();
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr('choose_location'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(tr('location_sub')),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: tr('search_city'),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (v) => setSheetState(() => query = v),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 360,
                    child: filtered.isEmpty
                        ? EmptyState(
                            icon: Icons.location_off,
                            title: tr('no_city_found'),
                            subtitle: tr('try_spelling'),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, i) {
                              final c = filtered[i];
                              final selected = c.name == state.cityName;
                              return ListTile(
                                leading: const Icon(Icons.location_on,
                                    color: primaryGreen),
                                title: Text(c.name),
                                subtitle: Text(c.country),
                                trailing: selected
                                    ? const Icon(Icons.check,
                                        color: primaryGreen)
                                    : null,
                                onTap: () {
                                  state.setCity(c.name);
                                  Navigator.of(sheetContext).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${tr('location_set_to')} ${c.name}')),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
