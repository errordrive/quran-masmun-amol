// Home header dates (v2.1): Hijri date with the Arabic month name next
// to the Gregorian date in English, side by side. No arguments — the
// other builder places `const DateHeader()` on Home. Readable in both
// light and dark themes: theme surface + onSurface colors, deep-green
// header strip with gold accent (reference look).
import 'package:flutter/material.dart';
import '../services/prayer.dart';
import '../theme.dart';

const Color _gold = Color(0xFFC9A227);

/// Bangla digits for the Hijri day/year, matching the app's Bangla-first
/// display (e.g. ১৭ ... ১৪৪৭).
String _bnDigits(int n) {
  const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n
      .toString()
      .split('')
      .map((c) => bn[int.parse(c)])
      .join();
}

class DateHeader extends StatelessWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final h = hijriFromGregorian(now);
    final hijri =
        '${_bnDigits(h.day)} ${hijriMonthNamesArabic[h.month - 1]} ${_bnDigits(h.year)}';
    final gregorian = gregorianDateString(now);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: primaryGreenDark,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.calendar_month,
                    size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'আজকের তারিখ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 28,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'হিজরি',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hijri,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).dividerColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ইংরেজি',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        gregorian,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Keep the dark-theme card from looking flat: a thin gold rule.
          Container(height: 3, color: dark ? _gold : _gold.withOpacity(0.7)),
        ],
      ),
    );
  }
}
