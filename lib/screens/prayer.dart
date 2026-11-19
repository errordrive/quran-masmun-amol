// Prayer tab: Gregorian + Hijri header, countdown, full day rows,
// previous/next day, method + Asr settings sheet.
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/prayer.dart';
import '../services/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'content.dart';

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
    final times = state.prayerTimesFor(_day);
    final tomorrowTimes =
        state.prayerTimesFor(now.add(const Duration(days: 1)));
    final (current, next, nextTime) =
        currentAndNextPrayer(times, tomorrowTimes, now);

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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => setState(() {
                            _day = _day.subtract(const Duration(days: 1));
                          }),
                          tooltip: tr('prev_day'),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(gregorianDateString(_day),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 2),
                              Text(hijriDateString(_day),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => setState(() {
                            _day = _day.add(const Duration(days: 1));
                          }),
                          tooltip: tr('next_day'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isToday) ...[
                      Text('${tr('next_prayer')}: ${prayerName(next)}',
                          style: const TextStyle(color: Colors.grey)),
                      Text(formatCountdown(nextTime.difference(now)),
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: primaryGreen)),
                      Text(formatTime(nextTime, use24h: state.use24h)),
                      const SizedBox(height: 8),
                    ] else
                      TextButton(
                        onPressed: () => setState(() => _day = DateTime.now()),
                        child: Text(tr('back_to_today')),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  for (final (name, time) in times.ordered)
                    _PrayerRow(
                      name: name,
                      time: formatTime(time, use24h: state.use24h),
                      highlighted: _isToday && name == current,
                      isSunrise: name == 'Sunrise',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Sehri & Iftar card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.nightlight_round, color: primaryGreen),
                        SizedBox(width: 8),
                        Text(tr('sehri_iftar'),
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tr('sehri_ends'),
                                  style: const TextStyle(color: Colors.grey)),
                              Text(formatTime(times.fajr,
                                  use24h: state.use24h),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Theme.of(context).dividerColor,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(tr('iftar'),
                                  style: const TextStyle(color: Colors.grey)),
                              Text(formatTime(times.maghrib,
                                  use24h: state.use24h),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: primaryGreen)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_isToday) ...[
                      const SizedBox(height: 12),
                      Center(child: Text(_sehriIftarCountdown(times, now))),
                    ] else
                      const SizedBox(height: 4),
                    const SizedBox(height: 4),
                    Text(
                        tr('sehri_iftar_note'),
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Namaz tracker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: primaryGreen),
                        const SizedBox(width: 8),
                        Text(tr('namaz_tracker'),
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Text(
                            '${state.prayerMarkCount(_day)}/5 ${tr('prayed')}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: primaryGreen)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                        _isToday
                            ? tr('tracker_today')
                            : tr('tracker_other_day'),
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var i = 0; i < 5; i++)
                          _PrayerCheck(
                            label: times.prayers[i].$1,
                            marked: state.isPrayerMarked(_day, i),
                            onTap: () =>
                                state.togglePrayerMark(_day, i),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(tr('last_7_days'),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final e in state.last7PrayerCounts())
                          Expanded(
                            child: Column(
                              children: [
                                Text('${e.count}/5',
                                    style: const TextStyle(fontSize: 11)),
                                const SizedBox(height: 4),
                                Container(
                                  height: (e.count / 5 * 40)
                                      .clamp(4, 40)
                                      .toDouble(),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: e.count == 5
                                        ? primaryGreen
                                        : e.count > 0
                                            ? primaryGreen.withOpacity(0.55)
                                            : Theme.of(context).dividerColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(_weekdayShort(e.date),
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TonalButton(
                label:
                    '${tr('method_label')}: ${state.prayerMethod.label} · ${tr('asr_hanafi').split(':').first} ${state.asrHanafi ? 'Hanafi' : 'Standard'}',
                icon: Icons.settings,
                onPressed: () => _showMethodSheet(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${tr('times_note')} (${state.cityName})',
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
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
    return bn
        ? 'আগামীকাল সেহরি শেষ $t'
        : 'Sehri ends tomorrow at $t';
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
  final String label;
  final bool marked;
  final VoidCallback onTap;
  const _PrayerCheck({
    required this.label,
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
                color: marked ? primaryGreen : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                    color: marked
                        ? primaryGreen
                        : Theme.of(context).dividerColor,
                    width: 2),
              ),
              child: Icon(
                marked ? Icons.check : Icons.circle_outlined,
                color: marked ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(prayerName(label), style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final String name;
  final String time;
  final bool highlighted;
  final bool isSunrise;
  const _PrayerRow({
    required this.name,
    required this.time,
    required this.highlighted,
    required this.isSunrise,
  });

  @override
  Widget build(BuildContext context) {
    final bg = highlighted
        ? primaryGreen.withOpacity(0.12)
        : Colors.transparent;
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            isSunrise
                ? Icons.wb_sunny
                : (highlighted ? Icons.access_time_filled : Icons.access_time),
            color: highlighted
                ? primaryGreen
                : (isSunrise ? Colors.grey : primaryGreen),
          ),
          const SizedBox(width: 12),
          Text(prayerName(name),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      highlighted ? FontWeight.w800 : FontWeight.w500,
                  color: isSunrise && !highlighted ? Colors.grey : null)),
          const Spacer(),
          Text(time,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      highlighted ? FontWeight.w700 : FontWeight.w400,
                  color: highlighted ? primaryGreen : null)),
          if (highlighted) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(tr('now_badge'),
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}
