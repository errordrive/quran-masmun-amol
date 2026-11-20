// Monthly Calendar (v3.0, NEW): a month grid where every day shows its
// Fajr + Maghrib times, with a full prayer list for the tapped day.
// All times come from the existing on-device computePrayerTimes via
// AppState.prayerTimesFor — no network, no new dependency.
// Prayer labels go through displayPrayerName (Jumu'ah on Fridays).
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/prayer.dart';
import '../services/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';

const List<String> _monthNamesEn = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> _monthNamesBn = [
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

const List<String> _weekdayShortEn = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

const List<String> _weekdayShortBn = [
  'রবি',
  'সোম',
  'মঙ্গল',
  'বুধ',
  'বৃহ',
  'শুক্র',
  'শনি',
];

class MonthlyCalendarScreen extends StatefulWidget {
  const MonthlyCalendarScreen({super.key});
  @override
  State<MonthlyCalendarScreen> createState() => _MonthlyCalendarScreenState();
}

class _MonthlyCalendarScreenState extends State<MonthlyCalendarScreen> {
  late DateTime _month;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selected = DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _shiftMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
    });
  }

  void _goToday() {
    final now = DateTime.now();
    setState(() {
      _month = DateTime(now.year, now.month);
      _selected = DateTime(now.year, now.month, now.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final bn = state.isBangla;
    final now = DateTime.now();
    final first = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    // Week starts on Sunday: DateTime.weekday is Mon=1..Sun=7.
    final leadingBlanks = first.weekday % 7;
    final monthName = bn
        ? _monthNamesBn[_month.month - 1]
        : _monthNamesEn[_month.month - 1];
    final selectedTimes = state.prayerTimesFor(_selected);
    final isSelectedToday = _isSameDay(_selected, now);

    return AppScaffold(
      appBar: AppBar(
        title: Text(bn ? 'মাসিক ক্যালেন্ডার' : 'Monthly Calendar'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // Month navigation.
          Row(
            children: [
              TonalIconButton(
                icon: Icons.chevron_left,
                tooltip: bn ? 'আগের মাস' : 'Previous month',
                onPressed: () => _shiftMonth(-1),
              ),
              Expanded(
                child: Text(
                  '$monthName ${_month.year}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              ),
              TonalIconButton(
                icon: Icons.chevron_right,
                tooltip: bn ? 'পরের মাস' : 'Next month',
                onPressed: () => _shiftMonth(1),
              ),
              const SizedBox(width: 8),
              TonalButton(
                label: bn ? 'আজ' : 'Today',
                onPressed: _goToday,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Weekday header.
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Text(
                    bn ? _weekdayShortBn[i] : _weekdayShortEn[i],
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Month grid: each day shows its Fajr + Maghrib times.
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 0.72,
            ),
            itemCount: leadingBlanks + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = index - leadingBlanks + 1;
              final date = DateTime(_month.year, _month.month, day);
              final times = state.prayerTimesFor(date);
              final isToday = _isSameDay(date, now);
              final isSelected = _isSameDay(date, _selected);
              final isFriday = date.weekday == DateTime.friday;
              return InkWell(
                onTap: () => setState(() => _selected = date),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryGreen
                        : (isFriday
                            ? goldAccent.withOpacity(0.16)
                            : Theme.of(context).cardTheme.color),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? primaryGreen
                          : (isToday
                              ? primaryGreen
                              : Theme.of(context).dividerColor),
                      width: isSelected || isToday ? 2 : 1,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : (isFriday ? goldDark : null),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatTime(times.fajr, use24h: state.use24h),
                        style: TextStyle(
                          fontSize: 9,
                          color: isSelected
                              ? Colors.white70
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        formatTime(times.maghrib, use24h: state.use24h),
                        style: TextStyle(
                          fontSize: 9,
                          color: isSelected
                              ? Colors.white70
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Selected day: full prayer list.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: primaryGreen),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          gregorianDateString(_selected),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (isSelectedToday)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(tr('today'),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      hijriDateString(_selected),
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final (name, time) in selectedTimes.ordered)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(prayerIcon(name),
                              size: 20, color: primaryGreen),
                          const SizedBox(width: 12),
                          Text(displayPrayerName(name, _selected),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Text(
                            formatTime(time, use24h: state.use24h),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    '${tr('times_note')} (${state.cityName})',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
