// Data models for Quran & Masnun Amol. All content is bundled locally.

class Ayah {
  final int numberInSurah;
  final String text;
  final String translation;
  const Ayah({
    required this.numberInSurah,
    required this.text,
    required this.translation,
  });

  factory Ayah.fromJson(Map<String, dynamic> j) => Ayah(
        numberInSurah: j['numberInSurah'] as int,
        text: j['text'] as String,
        translation: j['translation'] as String,
      );
}

class Surah {
  final int number;
  final String name; // Arabic name
  final String englishName;
  final String englishNameTranslation;
  final String revelationType; // Meccan / Medinan
  final List<Ayah> ayahs;
  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> j) => Surah(
        number: j['number'] as int,
        name: j['name'] as String,
        englishName: j['englishName'] as String,
        englishNameTranslation: j['englishNameTranslation'] as String,
        revelationType: j['revelationType'] as String,
        ayahs: (j['ayahs'] as List)
            .map((e) => Ayah.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class Dua {
  final String id;
  final String title;
  final String category; // 'morning' | 'daily'
  final String arabic;
  final String transliteration;
  final String meaning;
  final String reference;
  const Dua({
    required this.id,
    required this.title,
    required this.category,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.reference,
  });
}

class Hadith {
  final String collection;
  final String book;
  final String number;
  final String arabic;
  final String english;
  final String narrator;
  final String grade;
  const Hadith({
    required this.collection,
    required this.book,
    required this.number,
    required this.arabic,
    required this.english,
    required this.narrator,
    required this.grade,
  });
}

class TasbihItem {
  final String id;
  final String arabicName;
  final String englishName;
  final int target;
  final bool custom;
  const TasbihItem({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.target,
    this.custom = false,
  });
}

class CreditPackage {
  final String id;
  final String name;
  final int credits;
  final String priceText; // Placeholder until Play Console products exist.
  final String? badge;
  const CreditPackage({
    required this.id,
    required this.name,
    required this.credits,
    required this.priceText,
    this.badge,
  });
}

class PurchaseRecord {
  final String packageName;
  final int credits;
  final String priceText;
  final DateTime date;
  final String status;
  const PurchaseRecord({
    required this.packageName,
    required this.credits,
    required this.priceText,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'credits': credits,
        'priceText': priceText,
        'date': date.toIso8601String(),
        'status': status,
      };

  factory PurchaseRecord.fromJson(Map<String, dynamic> j) => PurchaseRecord(
        packageName: j['packageName'] as String,
        credits: j['credits'] as int,
        priceText: j['priceText'] as String,
        date: DateTime.parse(j['date'] as String),
        status: j['status'] as String,
      );
}

class City {
  final String name;
  final String country;
  final double lat;
  final double lon;
  final double tzOffset; // hours from UTC (standard time; DST not applied)
  const City({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzOffset,
  });
}

class AsmaulHusna {
  final int number;
  final String arabic;
  final String transliteration;
  final String meaning;
  const AsmaulHusna({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
  });
}
