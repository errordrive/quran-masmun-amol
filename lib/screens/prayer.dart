// Prayer tab: Gregorian + Hijri header, countdown, full day rows,
// previous/next day, method + Asr settings sheet.
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/prayer.dart';
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
                          tooltip: 'Previous day',
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
                          tooltip: 'Next day',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isToday) ...[
                      Text('Next prayer: $next',
                          style: const TextStyle(color: Colors.grey)),
                      Text(formatCountdown(nextTime.difference(now)),
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: primaryGreen)),
                      Text('at ${formatTime(nextTime, use24h: state.use24h)}'),
                      const SizedBox(height: 8),
                    ] else
                      TextButton(
                        onPressed: () => setState(() => _day = DateTime.now()),
                        child: const Text('Back to today'),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.nightlight_round, color: primaryGreen),
                        SizedBox(width: 8),
                        Text('Sehri & Iftar',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sehri ends',
                                  style: TextStyle(color: Colors.grey)),
                              Text(formatTime(times.fajr,
                                  use24h: state.use24h),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
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
                              const Text('Iftar',
                                  style: TextStyle(color: Colors.grey)),
                              Text(formatTime(times.maghrib,
                                  use24h: state.use24h),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
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
                    const Text(
                        'Sehri ends at Fajr and Iftar is at Maghrib for the selected city.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Namaz tracker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: primaryGreen),
                        const SizedBox(width: 8),
                        const Text('Namaz tracker',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text(
                            '${state.prayerMarkCount(_day)}/5 prayed',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: primaryGreen)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                        _isToday
                            ? 'Tap a prayer to mark it as prayed today.'
                            : 'Viewing ${gregorianDateString(_day)} — tap to edit marks for that day.',
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
                    const Text('Last 7 days',
                        style: TextStyle(fontWeight: FontWeight.w600)),
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
            OutlinedButton.icon(
              onPressed: () => _showMethodSheet(context),
              icon: const Icon(Icons.settings, size: 18),
              label: Text(
                  'Method: ${state.prayerMethod.label} · Asr ${state.asrHanafi ? 'Hanafi' : 'Standard'}'),
            ),
            const SizedBox(height: 8),
            Text(
              'Times are calculated on your device for ${state.cityName}. Hijri date is an approximation and may differ by a day.',
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
    if (now.isBefore(times.fajr)) {
      return 'Sehri ends in ${formatCountdown(times.fajr.difference(now))}';
    }
    if (now.isBefore(times.maghrib)) {
      return 'Iftar in ${formatCountdown(times.maghrib.difference(now))}';
    }
    final tomorrow =
        AppState.instance.prayerTimesFor(now.add(const Duration(days: 1)));
    return 'Sehri ends tomorrow at ${formatTime(tomorrow.fajr, use24h: AppState.instance.use24h)}';
  }

  String _weekdayShort(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    return days[d.weekday - 1];
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
                    const Text('Prayer settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    const Text('Calculation method',
                        style: TextStyle(fontWeight: FontWeight.w600)),
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
                      title: const Text('Asr method: Hanafi'),
                      subtitle:
                          const Text('Off = Standard (Shafi\'i). On = Hanafi (later Asr).'),
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
            Text(label, style: const TextStyle(fontSize: 12)),
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
          Text(name,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      highlighted ? FontWeight.w700 : FontWeight.w500,
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
              child: const Text('Now',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}
