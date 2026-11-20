// Prayer tab (v3.3 redesign, approved dark emerald preview): page
// header with location, Hijri/Gregorian date chips, Next Prayer hero,
// full prayer list (bell + prayed checkbox per prayer), Sehri & Iftar
// gold card, Monthly Calendar + Qibla buttons, then the existing
// Namaz tracker, method settings and note — all logic kept.
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/azan_service.dart';
import '../services/prayer.dart';
import '../services/strings.dart';
import '../services/widget_service.dart';
import '../widgets/common.dart';
import '../widgets/dark_ui.dart';
import 'month_calendar.dart';
import 'qibla.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});
  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  DateTime _day = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _isToday {
    final now = DateTime.now();
    return _day.year == now.year &&
        _day.month == now.month &&
        _day.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final now = DateTime.now();
    final bn = state.isBangla;
    final times = state.prayerTimesFor(_day);
    final today = state.prayerTimesFor(now);
    final yesterday =
        state.prayerTimesFor(now.subtract(const Duration(days: 1)));
    final tomorrowTimes =
        state.prayerTimesFor(now.add(const Duration(days: 1)));
    final (_, next, nextTime) =
        currentAndNextPrayer(today, tomorrowTimes, now);
    final progress = prayerDayProgress(today, yesterday, tomorrowTimes, now);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            // Page header: title + location (tap to change city).
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr('namaz_time'),
                          style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: v33Text)),
                      const SizedBox(height: 1),
                      InkWell(
                        onTap: () => showLocationPicker(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          '📍 ${state.cityName}, ${bn ? 'বাংলাদেশ' : 'Bangladesh'}',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF9DB8AD)),
                        ),
                      ),
                    ],
                  ),
                ),
                V33RoundButton(
                  icon: Icons.settings_outlined,
                  onTap: () => _showMethodSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Hijri + Gregorian date chips.
            V33DateChips(date: _day),
            const SizedBox(height: 10),
            // Day navigation (compact): previous / next day.
            V33Card(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: v33Text),
                    onPressed: () => setState(() {
                      _day = _day.subtract(const Duration(days: 1));
                    }),
                    tooltip: tr('prev_day'),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          bn
                              ? v33GregorianString(_day)
                              : gregorianDateString(_day),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: v33Text),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(hijriDateString(_day),
                            style: const TextStyle(
                                fontSize: 12, color: v33Muted),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: v33Text),
                    onPressed: () => setState(() {
                      _day = _day.add(const Duration(days: 1));
                    }),
                    tooltip: tr('next_day'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Next Prayer hero (today only; other days offer "back to today").
            if (_isToday)
              V33Hero(
                prayerEnglish: next,
                prayerDate: nextTime,
                time: nextTime,
                countdown: nextTime.difference(now),
                progress: progress,
              )
            else
              V33Card(
                child: Center(
                  child: TextButton(
                    onPressed: () => setState(() => _day = DateTime.now()),
                    child: Text(tr('back_to_today'),
                        style: const TextStyle(color: v33GreenLight)),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            // Full prayer list with bell + prayed checkbox.
            V33PrayerList(
              times: times,
              date: _day,
              nextEnglish: _isToday ? next : null,
            ),
            const SizedBox(height: 10),
            // Sehri & Iftar gold card (Sehri = Fajr, Iftar = Maghrib).
            V33GoldCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  V33GoldLabel('🌙 ${tr('sehri_iftar')}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tr('sehri_ends'),
                                style: const TextStyle(
                                    fontSize: 11.5, color: v33Sub)),
                            Text(
                              formatTime(times.fajr, use24h: state.use24h),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: v33Text),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: v33Gold.withOpacity(0.25),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tr('iftar'),
                                style: const TextStyle(
                                    fontSize: 11.5, color: v33Sub)),
                            Text(
                              formatTime(times.maghrib,
                                  use24h: state.use24h),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: v33Text),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_isToday) ...[
                    const SizedBox(height: 9),
                    Text(_sehriIftarCountdown(times, now),
                        style: const TextStyle(
                            fontSize: 12.5, color: Color(0xFFD9EDE3))),
                  ],
                  const SizedBox(height: 4),
                  Text(tr('sehri_iftar_note'),
                      style:
                          const TextStyle(fontSize: 12, color: v33Muted)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Monthly Calendar + Qibla buttons.
            Row(
              children: [
                Expanded(
                  child: V33ActionButton(
                    icon: Icons.calendar_month,
                    label: bn ? 'মাসিক ক্যালেন্ডার' : 'Monthly Calendar',
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const MonthlyCalendarScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: V33ActionButton(
                    icon: Icons.explore,
                    label: tr('qibla'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const QiblaScreen()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Namaz tracker (same state as the list checkboxes).
            V33Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: v33Green.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.check_circle_outline,
                            color: v33GreenLight, size: 19),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(tr('namaz_tracker'),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: v33Text)),
                      ),
                      Text(
                          '${state.prayerMarkCount(_day)}/5 ${tr('prayed')}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, color: v33GreenLight)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                      _isToday ? tr('tracker_today') : tr('tracker_other_day'),
                      style:
                          const TextStyle(fontSize: 13, color: v33Muted)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var i = 0; i < 5; i++)
                        _PrayerCheck(
                          displayName:
                              displayPrayerName(times.prayers[i].$1, _day),
                          marked: state.isPrayerMarked(_day, i),
                          onTap: () => state.togglePrayerMark(_day, i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(tr('last_7_days'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: v33Text)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final e in state.last7PrayerCounts())
                        Expanded(
                          child: Column(
                            children: [
                              Text('${e.count}/5',
                                  style: const TextStyle(
                                      fontSize: 11, color: v33Sub)),
                              const SizedBox(height: 4),
                              Container(
                                height: (e.count / 5 * 40)
                                    .clamp(4, 40)
                                    .toDouble(),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4),
                                decoration: BoxDecoration(
                                  color: e.count == 5
                                      ? v33Green
                                      : e.count > 0
                                          ? v33Green.withOpacity(0.55)
                                          : Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(_weekdayShort(e.date),
                                  style: const TextStyle(
                                      fontSize: 11, color: v33Muted)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Method + Asr settings row.
            InkWell(
              onTap: () => _showMethodSheet(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.09)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.settings, size: 19, color: v33Text),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${tr('method_label')}: ${state.prayerMethod.label} · ${tr('asr_hanafi').split(':').first} ${state.asrHanafi ? 'Hanafi' : 'Standard'}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE8F2ED)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${tr('times_note')} (${state.cityName})',
              style: const TextStyle(fontSize: 12, color: v33Muted),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  String _sehriIftarCountdown(DayPrayerTimes times, DateTime now) {
    final bn = AppState.instance.isBangla;
    if (now.isBefore(times.fajr)) {
      final cd = formatCountdown(times.fajr.difference(now));
      return bn ? 'সেহরি শেষ হতে আর $cd বাকি' : 'Sehri ends in $cd';
    }
    if (now.isBefore(times.maghrib)) {
      final cd = formatCountdown(times.maghrib.difference(now));
      return bn ? 'ইফতারের আর $cd বাকি' : 'Iftar in $cd';
    }
    final tomorrow =
        AppState.instance.prayerTimesFor(now.add(const Duration(days: 1)));
    final t = formatTime(tomorrow.fajr, use24h: AppState.instance.use24h);
    return bn ? 'আগামীকাল সেহরি শেষ $t' : 'Sehri ends tomorrow at $t';
  }

  String _weekdayShort(DateTime d) {
    const daysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const daysBn = ['সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র', 'শনি', 'রবি'];
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return tr('today');
    }
    return AppState.instance.isBangla
        ? daysBn[d.weekday - 1]
        : daysEn[d.weekday - 1];
  }

  Future<void> _showMethodSheet(BuildContext context) async {
    final state = AppState.instance;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('prayer_settings'),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    Text(tr('method_label'),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    for (final m in PrayerMethod.values)
                      RadioListTile<PrayerMethod>(
                        title: Text(m.label),
                        value: m,
                        groupValue: state.prayerMethod,
                        onChanged: (v) {
                          if (v != null) {
                            state.setPrayerMethod(v);
                            AzanService.scheduleAll();
                            HomeWidgetService.update();
                            setSheetState(() {});
                          }
                        },
                      ),
                    const Divider(),
                    SwitchListTile(
                      title: Text(tr('asr_hanafi')),
                      subtitle: Text(tr('asr_hanafi_sub')),
                      value: state.asrHanafi,
                      onChanged: (v) {
                        state.setAsrHanafi(v);
                        AzanService.scheduleAll();
                        HomeWidgetService.update();
                        setSheetState(() {});
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (mounted) setState(() {});
  }
}

class _PrayerCheck extends StatelessWidget {
  final String displayName;
  final bool marked;
  final VoidCallback onTap;
  const _PrayerCheck({
    required this.displayName,
    required this.marked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: marked ? v33Green : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                    color: marked
                        ? v33Green
                        : Colors.white.withOpacity(0.35),
                    width: 2),
              ),
              child: Icon(
                marked ? Icons.check : Icons.circle_outlined,
                color: marked ? Colors.white : v33Muted,
              ),
            ),
            const SizedBox(height: 4),
            Text(displayName,
                style: const TextStyle(fontSize: 12, color: v33Text)),
          ],
        ),
      ),
    );
  }
}
