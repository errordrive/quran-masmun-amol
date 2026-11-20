// v3.3 design system — dark emerald + gold, from the approved
// preview mockups (home/namaz/quran/tasbih/hadith/profile v32).
// These screens use this palette directly; they do NOT use the app's
// old light theme (cream background / white cards). Everything here
// is original code (CustomPainter mosque, gradient cards) — no assets.
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/azan_service.dart';
import '../services/prayer.dart';
import '../services/strings.dart';

// ---------------- Palette (from the previews) ----------------

const Color v33Background = Color(0xFF071510);
const Color v33NavBar = Color(0xFF10201A);
const Color v33Green = Color(0xFF2EA06E);
const Color v33GreenLight = Color(0xFF7FD6AC);
const Color v33GreenDeep = Color(0xFF0E6B48);
const Color v33Gold = Color(0xFFF2C96B);
const Color v33GoldDeep = Color(0xFFE8B64C);
const Color v33Text = Color(0xFFF2F7F4);
const Color v33Sub = Color(0xFFC7D8CF);
const Color v33Muted = Color(0xFF8FA89D);

/// Emerald hero gradient (135deg): #0E5B3E -> #0A4530 -> #083626.
const LinearGradient v33HeroGradient = LinearGradient(
  colors: [Color(0xFF0E5B3E), Color(0xFF0A4530), Color(0xFF083626)],
  stops: [0.0, 0.55, 1.0],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Gold-tinted card gradient (120deg): rgba(242,201,107,.16) -> .05.
const LinearGradient v33GoldGradient = LinearGradient(
  colors: [Color(0x29F2C96B), Color(0x0DF2C96B)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

/// Bangla digits, e.g. 17 -> ১৭ (same as DateHeader's helper, which
/// is private to that file).
String v33BnDigits(int n) {
  const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n
      .toString()
      .split('')
      .map((c) => bn[int.parse(c)])
      .join();
}

const List<String> _bnWeekdays = [
  'সোমবার',
  'মঙ্গলবার',
  'বুধবার',
  'বৃহস্পতিবার',
  'শুক্রবার',
  'শনিবার',
  'রবিবার',
];

const List<String> _bnMonths = [
  'জানুয়ারি',
  'ফেব্রুয়ারি',
  'মার্চ',
  'এপ্রিল',
  'মে',
  'জুন',
  'জুলাই',
  'আগস্ট',
  'সেপ্টেম্বর',
  'অক্টোবর',
  'নভেম্বর',
  'ডিসেম্বর',
];

/// Gregorian date in Bangla (preview style), e.g.
/// "বৃহস্পতিবার, ২০ নভেম্বর ২০২৬"; English falls back to the
/// existing gregorianDateString.
String v33GregorianString(DateTime date) {
  if (!AppState.instance.isBangla) return gregorianDateString(date);
  return '${_bnWeekdays[date.weekday - 1]}, ${v33BnDigits(date.day)} '
      '${_bnMonths[date.month - 1]} ${v33BnDigits(date.year)}';
}

/// Fraction of the interval between the previous prayer and the next
/// prayer that has elapsed (0..1) — drives the hero progress bar.
/// Looks across yesterday/today/tomorrow so the pre-Fajr hours work.
double prayerDayProgress(
    DayPrayerTimes today, DayPrayerTimes yesterday, DayPrayerTimes tomorrow, DateTime now) {
  final candidates = <DateTime>[
    yesterday.isha,
    ...today.prayers.map((p) => p.$2),
    tomorrow.fajr,
  ];
  DateTime prev = candidates.first;
  DateTime next = candidates.last;
  for (final t in candidates) {
    if (!t.isAfter(now)) prev = t;
    if (t.isAfter(now)) {
      next = t;
      break;
    }
  }
  final total = next.difference(prev).inSeconds;
  if (total <= 0) return 0;
  return (now.difference(prev).inSeconds / total).clamp(0.0, 1.0);
}

// ---------------- Background ----------------

/// Dark background with the preview's two radial glows (green
/// top-right, faint gold mid-left). Wrap the main shell's tab stack
/// in this so the three main tabs sit on the dark palette.
class DarkGlowBackground extends StatelessWidget {
  final Widget child;
  const DarkGlowBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: v33Background,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.85, -0.35),
                  radius: 0.9,
                  colors: [Color(0x472EA06E), Colors.transparent],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.9, 0.15),
                  radius: 0.8,
                  colors: [Color(0x1AF2C96B), Colors.transparent],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// ---------------- Cards ----------------

/// Dark card (preview .plist/.menu style): white 5.5% fill, white 8%
/// border, radius 20.
class V33Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  const V33Card({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.055),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: child,
    );
  }
}

/// Gold-tinted card (preview .daily/.fast style): gold gradient fill,
/// gold 25% border, radius 18.
class V33GoldCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const V33GoldCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: v33GoldGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: v33Gold.withOpacity(0.25)),
      ),
      child: child,
    );
  }
}

/// Small gold label, e.g. "✦ আজকের হাদিস" (preview .dl style).
class V33GoldLabel extends StatelessWidget {
  final String text;
  const V33GoldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1,
        color: v33Gold,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

// ---------------- Page header ----------------

/// Page header (preview .phead): big title + muted subtitle on the
/// left, an optional leading back button and trailing action widget.
class V33PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;
  final bool showBack;
  const V33PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack) ...[
          _V33RoundButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: v33Text)),
              const SizedBox(height: 1),
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF9DB8AD))),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

/// 34px circular dark button (preview .hbtn).
class _V33RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  const _V33RoundButton({required this.icon, this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.09)),
        ),
        child: Icon(icon, size: 19, color: iconColor ?? v33Text),
      ),
    );
  }
}

/// Public version of the round button for screens that need one.
class V33RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  const V33RoundButton({super.key, required this.icon, this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) =>
      _V33RoundButton(icon: icon, onTap: onTap, iconColor: iconColor);
}

// ---------------- Search ----------------

/// Dark search field (preview .search): tap opens the real search.
class V33SearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;
  final Widget? trailing;
  const V33SearchBar({
    super.key,
    required this.hint,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20, color: v33Muted),
            const SizedBox(width: 9),
            Expanded(
              child: Text(hint,
                  style: const TextStyle(fontSize: 13.5, color: v33Muted),
                  overflow: TextOverflow.ellipsis),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

// ---------------- Date chips ----------------

/// Hijri + Gregorian date chips side by side (preview .dates).
class V33DateChips extends StatelessWidget {
  final DateTime date;
  const V33DateChips({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final h = hijriFromGregorian(date);
    final hijri =
        '${v33BnDigits(h.day)} ${hijriMonthNamesArabic[h.month - 1]} ${v33BnDigits(h.year)}';
    return Row(
      children: [
        Expanded(
          child: _DateChip(label: tr('hijri'), value: hijri),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _DateChip(
              label: tr('gregorian'), value: v33GregorianString(date)),
        ),
      ],
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String value;
  const _DateChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10, letterSpacing: 0.4, color: v33Muted)),
          const SizedBox(height: 1),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: v33Text)),
        ],
      ),
    );
  }
}

// ---------------- Mosque silhouette (hero) ----------------

/// Mosque silhouette drawn from the preview's SVG (viewBox 200x118):
/// two minarets, base, main + side domes, finial + gold crescent,
/// three gold windows. Scaled to fit the hero card.
class HeroMosquePainter extends CustomPainter {
  const HeroMosquePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 118);
    final mosque = Paint()..color = v33GreenDeep;
    final gold = Paint()..color = v33Gold;

    Path dome(double cx, double base, double w, double top) {
      // Half-dome arc from (cx-w, base) over (cx, top) to (cx+w, base).
      return Path()
        ..moveTo(cx - w, base)
        ..quadraticBezierTo(cx, top, cx + w, base)
        ..close();
    }

    // Minarets (rect + dome cap).
    for (final mx in [16.0, 184.0]) {
      canvas.drawRect(Rect.fromLTWH(mx - 4, 46, 8, 72), mosque);
      canvas.drawPath(dome(mx, 46, 4, 34), mosque);
    }
    // Base + domes.
    canvas.drawRect(Rect.fromLTWH(24, 86, 152, 32), mosque);
    canvas.drawPath(dome(100, 86, 42, 26), mosque);
    canvas.drawPath(dome(44, 86, 14, 60), mosque);
    canvas.drawPath(dome(156, 86, 14, 60), mosque);
    // Finial + gold crescent above the main dome.
    canvas.drawRect(Rect.fromLTWH(97, 12, 6, 18), mosque);
    canvas.drawPath(
      Path()
        ..moveTo(93, 14)
        ..quadraticBezierTo(100, 2, 107, 14)
        ..quadraticBezierTo(100, 9, 93, 14)
        ..close(),
      gold,
    );
    // Gold windows.
    canvas.drawCircle(const Offset(100, 100), 6, gold);
    canvas.drawCircle(const Offset(52, 102), 4.5, gold);
    canvas.drawCircle(const Offset(148, 102), 4.5, gold);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HeroMosquePainter old) => false;
}

// ---------------- Next-prayer hero ----------------

/// Next-prayer hero (preview .hero): emerald gradient + mosque
/// silhouette, "পরবর্তী নামাজ" label, prayer name (Jumu'ah on
/// Fridays via displayPrayerName), gold time, live HH:MM:SS
/// countdown, day-progress bar, and an azan pill that reflects the
/// real master azan toggle.
class V33Hero extends StatelessWidget {
  final String prayerEnglish;
  final DateTime prayerDate;
  final DateTime time;
  final Duration countdown;
  final double progress;
  final VoidCallback? onTap;
  const V33Hero({
    super.key,
    required this.prayerEnglish,
    required this.prayerDate,
    required this.time,
    required this.countdown,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final card = Container(
      decoration: BoxDecoration(
        gradient: v33HeroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -8,
            bottom: -4,
            width: 200,
            height: 118,
            child: Opacity(
              opacity: 0.55,
              child: CustomPaint(painter: HeroMosquePainter()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 11, 18, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('next_prayer'),
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.2,
                    color: Color(0xFFBFE3D2),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayPrayerName(prayerEnglish, prayerDate),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.15),
                ),
                Text(
                  formatTime(time, use24h: state.use24h),
                  style: const TextStyle(
                      color: v33Gold,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.1),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: Color(0xFFD9EDE3)),
                    const SizedBox(width: 6),
                    Text(
                      '${tr('starts_in')} ',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFFD9EDE3)),
                    ),
                    Text(
                      formatCountdown(countdown),
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      ' ${tr('left')}',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFFD9EDE3)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 5,
                    backgroundColor: Colors.white.withOpacity(0.18),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(v33Gold),
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: state.azanEnabled
                        ? v33Gold
                        : Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        state.azanEnabled
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        size: 14,
                        color: state.azanEnabled
                            ? const Color(0xFF0B3D2E)
                            : Colors.white70,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        state.azanEnabled
                            ? tr('azan_on_pill')
                            : tr('azan_off_pill'),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: state.azanEnabled
                              ? const Color(0xFF0B3D2E)
                              : Colors.white70,
                        ),
                      ),
                    ],
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
      borderRadius: BorderRadius.circular(22),
      child: card,
    );
  }
}

// ---------------- Prayer list ----------------

IconData _v33PrayerIcon(String english) {
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

/// Full prayer list (preview .plist): 6 rows in one dark card. Each
/// row: icon box, Bangla name (+ gold "পরবর্তী" tag on the next
/// prayer), time, per-prayer azan bell toggle and prayed checkbox —
/// both wired to the SAME AppState keys as Settings / the tracker
/// (no second copy of the state). Sunrise is dimmed, has no azan
/// toggle and no checkbox.
class V33PrayerList extends StatelessWidget {
  final DayPrayerTimes times;
  final DateTime date;
  final String? nextEnglish;
  const V33PrayerList({
    super.key,
    required this.times,
    required this.date,
    this.nextEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return V33Card(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Column(
        children: [
          for (final (name, time) in times.ordered)
            _V33PrayerRow(
              name: name,
              displayName: displayPrayerName(name, date),
              time: formatTime(time, use24h: state.use24h),
              isNext: name == nextEnglish,
              isSunrise: name == 'Sunrise',
              prayerIndex: prayerIndexFor(name),
              day: date,
              marked: prayerIndexFor(name) >= 0 &&
                  state.isPrayerMarked(date, prayerIndexFor(name)),
            ),
        ],
      ),
    );
  }
}

class _V33PrayerRow extends StatelessWidget {
  final String name;
  final String displayName;
  final String time;
  final bool isNext;
  final bool isSunrise;
  final int prayerIndex;
  final DateTime day;
  final bool marked;
  const _V33PrayerRow({
    required this.name,
    required this.displayName,
    required this.time,
    required this.isNext,
    required this.isSunrise,
    required this.prayerIndex,
    required this.day,
    required this.marked,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final azanOn = prayerIndex >= 0 && state.azanPrayers[prayerIndex];
    final row = Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5.5),
      decoration: BoxDecoration(
        color:
            isNext ? v33Green.withOpacity(0.16) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: v33Green.withOpacity(0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_v33PrayerIcon(name),
                size: 18, color: v33GreenLight),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(displayName,
                      style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: v33Text),
                      overflow: TextOverflow.ellipsis),
                ),
                if (isNext) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: v33Gold.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(tr('next_tag'),
                        style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: v33Gold)),
                  ),
                ],
              ],
            ),
          ),
          Text(time,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: v33Text)),
          const SizedBox(width: 8),
          // Azan bell (5 prayers only) — same AppState toggle as
          // Settings; reschedules azan right away.
          if (prayerIndex >= 0)
            InkWell(
              onTap: () {
                state.setAzanPrayer(prayerIndex, !azanOn);
                AzanService.scheduleAll();
              },
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  azanOn ? Icons.volume_up : Icons.volume_off,
                  size: 19,
                  color: azanOn ? v33Gold : v33Muted,
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.volume_off, size: 19, color: v33Muted),
            ),
          const SizedBox(width: 6),
          // Prayed checkbox (5 prayers only) — same namaz-tracker
          // state and storage keys as the tracker.
          if (prayerIndex >= 0)
            InkWell(
              onTap: () => state.togglePrayerMark(day, prayerIndex),
              borderRadius: BorderRadius.circular(7),
              child: Container(
                width: 21,
                height: 21,
                decoration: BoxDecoration(
                  color: marked ? v33Green : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: marked
                        ? v33Green
                        : Colors.white.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: marked
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            )
          else
            Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: Colors.white.withOpacity(0.35), width: 1.5),
              ),
            ),
        ],
      ),
    );
    if (isSunrise) {
      return Opacity(opacity: 0.55, child: row);
    }
    return row;
  }
}

// ---------------- Chips ----------------

/// Filter chip (preview .chip): dark pill, green when active.
class V33Chip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const V33Chip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? v33Green : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active
                  ? v33Green
                  : Colors.white.withOpacity(0.09)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : v33Sub)),
      ),
    );
  }
}

// ---------------- Quick actions ----------------

/// One quick-action item (preview .q): 46px dark rounded square with
/// a light-green icon + small label underneath.
class V33QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const V33QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 56,
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: Colors.white.withOpacity(0.09)),
              ),
              child: Icon(icon, color: v33GreenLight, size: 23),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: v33Sub,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

/// Dark action button (preview .abtn): full-width dark pill with icon.
class V33ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const V33ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.09)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 19, color: v33Text),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE8F2ED))),
          ],
        ),
      ),
    );
  }
}

/// Section label row (preview-style small heading).
class V33SectionLabel extends StatelessWidget {
  final String text;
  const V33SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w800, color: v33Text));
  }
}
