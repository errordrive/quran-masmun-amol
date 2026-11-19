// Shared UI helpers: top bar, copy/share, empty/loading states, location picker.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cities.dart';
import '../services/app_state.dart';
import '../services/navigation.dart';
import '../theme.dart';

Future<void> copyText(BuildContext context, String text, String label) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }
}

/// No share plugin is bundled (minimal dependencies), so Share copies the
/// text and tells the user to paste it anywhere.
Future<void> shareText(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard — paste it anywhere to share'),
      ),
    );
  }
}

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

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
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color:
                            Theme.of(context).dividerColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Search Quran, Hadith, Dua',
                            style: TextStyle(color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => goToTab(2),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: primaryGreen),
              ),
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
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  const Text('Choose location',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text(
                      'Prayer times are calculated on your device for the selected city.'),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search city',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) => setSheetState(() => query = v),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 360,
                    child: filtered.isEmpty
                        ? const EmptyState(
                            icon: Icons.location_off,
                            title: 'No city found',
                            subtitle: 'Try another spelling.',
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
                                            'Location set to ${c.name}')),
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
