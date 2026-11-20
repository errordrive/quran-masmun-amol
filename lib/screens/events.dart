// Islamic events calendar (v2.0): upcoming Islamic events from the
// bundled approximate table (lib/data/islamic_events.dart). EVERY date
// is labelled "চাঁদ দেখা সাপেক্ষে" — Hijri dates depend on moon
// sighting and are never presented as exact.
import 'package:flutter/material.dart';
import '../data/islamic_events.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

const List<String> _monthNamesEn = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _eventDate(DateTime d) =>
    '${d.day} ${_monthNamesEn[d.month - 1]} ${d.year}';

class IslamicEventsScreen extends StatelessWidget {
  const IslamicEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final next = nextIslamicEvent(now);
    final upcoming = islamicEvents
        .where((e) => !e.date.isBefore(today))
        .toList();
    final past = islamicEvents
        .where((e) => e.date.isBefore(today))
        .toList()
        .reversed
        .take(3)
        .toList();
    return AppScaffold(
      appBar: AppBar(
          title: Text(bn ? 'ইসলামিক ইভেন্ট' : 'Islamic Events')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          if (next != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bn ? 'পরের ইভেন্ট' : 'Next event',
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(bn ? next.nameBn : next.nameEn,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: primaryGreen)),
                    const SizedBox(height: 4),
                    Text('${next.hijri} · ${_eventDate(next.date)}',
                        style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 12),
                    Text(
                      _countdownText(next, today, bn),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    if ((bn ? next.noteBn : next.noteEn) != null) ...[
                      const SizedBox(height: 8),
                      Text(bn ? next.noteBn! : next.noteEn!,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          SectionTitle(title: bn ? 'আসন্ন ইভেন্টসমূহ' : 'Upcoming events'),
          const SizedBox(height: 8),
          for (final e in upcoming) _EventTile(event: e, isNext: e == next),
          if (past.isNotEmpty) ...[
            const SizedBox(height: 16),
            SectionTitle(title: bn ? 'সদ্য পেরিয়ে গেছে' : 'Recently passed'),
            const SizedBox(height: 8),
            for (final e in past) _EventTile(event: e, isNext: false),
          ],
          const SizedBox(height: 16),
          Text(
            bn
                ? 'সব তারিখ আনুমানিক — চাঁদ দেখা সাপেক্ষে এক দিন এদিক-ওদিক হতে পারে।'
                : 'All dates are approximate — they may shift by a day depending on moon sighting.',
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _countdownText(IslamicEvent e, DateTime today, bool bn) {
    final days = e.date.difference(today).inDays;
    if (days == 0) {
      return bn ? 'আজকেই!' : 'Today!';
    }
    if (days == 1) {
      return bn ? 'আর মাত্র ১ দিন বাকি' : 'Only 1 day left';
    }
    return bn ? 'আর $days দিন বাকি' : '$days days left';
  }
}

class _EventTile extends StatelessWidget {
  final IslamicEvent event;
  final bool isNext;
  const _EventTile({required this.event, required this.isNext});

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    final today = DateTime.now();
    final d = DateTime(today.year, today.month, today.day);
    final daysLeft = event.date.difference(d).inDays;
    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isNext
                ? primaryGreen
                : primaryGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${event.date.day}',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isNext ? Colors.white : primaryGreen)),
              Text(_monthNamesEn[event.date.month - 1],
                  style: TextStyle(
                      fontSize: 11,
                      color: isNext ? Colors.white70 : Colors.grey)),
            ],
          ),
        ),
        title: Text(bn ? event.nameBn : event.nameEn,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
            '${event.hijri} · ${_eventDate(event.date)} · ${bn ? 'চাঁদ দেখা সাপেক্ষে' : 'subject to moon sighting'}'),
        trailing: daysLeft >= 0
            ? Text(
                daysLeft == 0
                    ? (bn ? 'আজ' : 'Today')
                    : (bn ? '$daysLeft দিন' : '$daysLeft d'),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: primaryGreen),
              )
            : null,
      ),
    );
  }
}
