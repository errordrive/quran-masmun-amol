// Islamic events (v2.0) — approximate Gregorian dates for 2026–2028.
// Hijri months follow the moon, so EVERY date here is an approximation
// and must always be shown with "চাঁদ দেখা সাপেক্ষে" (subject to moon
// sighting) — never as exact. To correct a date, edit this one table.
class IslamicEvent {
  final String nameBn;
  final String nameEn;
  final String hijri;
  final DateTime date;
  final String? noteBn;
  final String? noteEn;
  const IslamicEvent({
    required this.nameBn,
    required this.nameEn,
    required this.hijri,
    required this.date,
    this.noteBn,
    this.noteEn,
  });
}

// NOTE: `final`, not `const` — DateTime has no const constructor, so a
// const list of events would not compile.
final List<IslamicEvent> islamicEvents = [
  // ---- 2026 ----
  IslamicEvent(
    nameBn: 'শবে মেরাজ',
    nameEn: "Shab-e-Meraj",
    hijri: '২৭ রজব ১৪৪৭',
    date: DateTime(2026, 1, 16),
  ),
  IslamicEvent(
    nameBn: 'শবে বরাত',
    nameEn: "Shab-e-Barat",
    hijri: '১৫ শাবান ১৪৪৭',
    date: DateTime(2026, 2, 3),
  ),
  IslamicEvent(
    nameBn: 'রমজান শুরু',
    nameEn: 'Ramadan begins',
    hijri: '১ রমজান ১৪৪৭',
    date: DateTime(2026, 2, 19),
  ),
  IslamicEvent(
    nameBn: 'শবে কদর (শেষ ১০ রাত)',
    nameEn: 'Laylatul Qadr (last 10 nights)',
    hijri: '২১–৩০ রমজান ১৪৪৭',
    date: DateTime(2026, 3, 11),
    noteBn: 'শেষ ১০ রাতের বিজোড় রাতগুলোতে তালাশ করুন',
    noteEn: 'Seek it in the odd nights of the last 10 nights',
  ),
  IslamicEvent(
    nameBn: 'ঈদুল ফিতর',
    nameEn: 'Eid al-Fitr',
    hijri: '১ শাওয়াল ১৪৪৭',
    date: DateTime(2026, 3, 20),
  ),
  IslamicEvent(
    nameBn: 'ঈদুল আজহা',
    nameEn: 'Eid al-Adha',
    hijri: '১০ জিলহজ ১৪৪৭',
    date: DateTime(2026, 5, 27),
  ),
  IslamicEvent(
    nameBn: 'আশুরা',
    nameEn: 'Ashura',
    hijri: '১০ মহররম ১৪৪৮',
    date: DateTime(2026, 6, 26),
  ),
  IslamicEvent(
    nameBn: 'ঈদে মিলাদুন্নবী',
    nameEn: 'Eid Milad-un-Nabi',
    hijri: '১২ রবিউল আউয়াল ১৪৪৮',
    date: DateTime(2026, 8, 26),
  ),
  // ---- 2027 ----
  IslamicEvent(
    nameBn: 'শবে মেরাজ',
    nameEn: "Shab-e-Meraj",
    hijri: '২৭ রজব ১৪৪৮',
    date: DateTime(2027, 1, 6),
  ),
  IslamicEvent(
    nameBn: 'শবে বরাত',
    nameEn: "Shab-e-Barat",
    hijri: '১৫ শাবান ১৪৪৮',
    date: DateTime(2027, 1, 24),
  ),
  IslamicEvent(
    nameBn: 'রমজান শুরু',
    nameEn: 'Ramadan begins',
    hijri: '১ রমজান ১৪৪৮',
    date: DateTime(2027, 2, 8),
  ),
  IslamicEvent(
    nameBn: 'শবে কদর (শেষ ১০ রাত)',
    nameEn: 'Laylatul Qadr (last 10 nights)',
    hijri: '২১–৩০ রমজান ১৪৪৮',
    date: DateTime(2027, 2, 28),
    noteBn: 'শেষ ১০ রাতের বিজোড় রাতগুলোতে তালাশ করুন',
    noteEn: 'Seek it in the odd nights of the last 10 nights',
  ),
  IslamicEvent(
    nameBn: 'ঈদুল ফিতর',
    nameEn: 'Eid al-Fitr',
    hijri: '১ শাওয়াল ১৪৪৮',
    date: DateTime(2027, 3, 10),
  ),
  IslamicEvent(
    nameBn: 'ঈদুল আজহা',
    nameEn: 'Eid al-Adha',
    hijri: '১০ জিলহজ ১৪৪৮',
    date: DateTime(2027, 5, 17),
  ),
  IslamicEvent(
    nameBn: 'আশুরা',
    nameEn: 'Ashura',
    hijri: '১০ মহররম ১৪৪৯',
    date: DateTime(2027, 6, 16),
  ),
  IslamicEvent(
    nameBn: 'ঈদে মিলাদুন্নবী',
    nameEn: 'Eid Milad-un-Nabi',
    hijri: '১২ রবিউল আউয়াল ১৪৪৯',
    date: DateTime(2027, 8, 16),
  ),
  // ---- 2028 ----
  IslamicEvent(
    nameBn: 'রমজান শুরু',
    nameEn: 'Ramadan begins',
    hijri: '১ রমজান ১৪৪৯',
    date: DateTime(2028, 1, 28),
  ),
  IslamicEvent(
    nameBn: 'ঈদুল ফিতর',
    nameEn: 'Eid al-Fitr',
    hijri: '১ শাওয়াল ১৪৪৯',
    date: DateTime(2028, 2, 27),
  ),
  IslamicEvent(
    nameBn: 'ঈদুল আজহা',
    nameEn: 'Eid al-Adha',
    hijri: '১০ জিলহজ ১৪৪৯',
    date: DateTime(2028, 5, 6),
  ),
];

/// The next upcoming event (first event on or after today), or null if
/// the table has run out (add more years to the table above).
IslamicEvent? nextIslamicEvent([DateTime? now]) {
  final today = now ?? DateTime.now();
  final d = DateTime(today.year, today.month, today.day);
  for (final e in islamicEvents) {
    if (!e.date.isBefore(d)) return e;
  }
  return null;
}
