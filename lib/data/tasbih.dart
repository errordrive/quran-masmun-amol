// Built-in tasbih list (PRD 5.8) and credit packages (PRD 5.12).
// Credit prices are placeholders until Play Console products exist.
// v3.1: each preset also carries its transliteration + meaning for the
// 3D counter card (standard phrases — Arabic, transliteration and
// meaning are the well-known wordings of these dhikrs).
import '../models/models.dart';

const List<TasbihItem> defaultTasbihs = [
  TasbihItem(
    id: 'subhanallah',
    arabicName: 'سُبْحَانَ اللَّهِ',
    englishName: 'SubhanAllah',
    target: 33,
    transliteration: 'SubhanAllah',
    meaningBn: 'আল্লাহ পবিত্র ও মহিমান্বিত',
    meaningEn: 'Glory be to Allah',
  ),
  TasbihItem(
    id: 'alhamdulillah',
    arabicName: 'الْحَمْدُ لِلَّهِ',
    englishName: 'Alhamdulillah',
    target: 33,
    transliteration: 'Alhamdulillah',
    meaningBn: 'সকল প্রশংসা আল্লাহর জন্য',
    meaningEn: 'All praise is due to Allah',
  ),
  TasbihItem(
    id: 'allahu-akbar',
    arabicName: 'اللَّهُ أَكْبَرُ',
    englishName: 'Allahu Akbar',
    target: 34,
    transliteration: 'Allahu Akbar',
    meaningBn: 'আল্লাহ সবচেয়ে মহান',
    meaningEn: 'Allah is the Greatest',
  ),
  TasbihItem(
    id: 'la-ilaha',
    arabicName: 'لَا إِلَهَ إِلَّا اللَّهُ',
    englishName: 'La ilaha illallah',
    target: 100,
    transliteration: 'La ilaha illallah',
    meaningBn: 'আল্লাহ ছাড়া কোনো উপাস্য নেই',
    meaningEn: 'There is no god but Allah',
  ),
  TasbihItem(
    id: 'astaghfirullah',
    arabicName: 'أَسْتَغْفِرُ اللَّهَ',
    englishName: 'Astaghfirullah',
    target: 100,
    transliteration: 'Astaghfirullah',
    meaningBn: 'আমি আল্লাহর কাছে ক্ষমা চাই',
    meaningEn: 'I seek forgiveness from Allah',
  ),
  TasbihItem(
    id: 'durood',
    arabicName: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    englishName: 'Durood Sharif',
    target: 100,
    transliteration: 'Allahumma salli ala Muhammad',
    meaningBn: 'হে আল্লাহ, মুহাম্মাদের উপর শান্তি বর্ষণ করুন',
    meaningEn: 'O Allah, send blessings upon Muhammad',
  ),
  TasbihItem(
    id: 'subhan-bihamdihi',
    arabicName: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    englishName: 'SubhanAllahi wa bihamdihi',
    target: 100,
    transliteration: 'SubhanAllahi wa bihamdihi',
    meaningBn: 'আল্লাহ পবিত্র, তাঁরই প্রশংসা',
    meaningEn: 'Glory be to Allah and praise be to Him',
  ),
];

const List<CreditPackage> creditPackages = [
  CreditPackage(id: 'credits_50', name: 'Starter Pack', credits: 50, priceText: '৳100 (placeholder)'),
  CreditPackage(id: 'credits_120', name: 'Value Pack', credits: 120, priceText: '৳200 (placeholder)', badge: 'Best value'),
  CreditPackage(id: 'credits_300', name: 'Premium Pack', credits: 300, priceText: '৳450 (placeholder)'),
];
