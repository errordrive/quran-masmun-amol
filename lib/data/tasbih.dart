// Built-in tasbih list (PRD 5.8) and credit packages (PRD 5.12).
// Credit prices are placeholders until Play Console products exist.
import '../models/models.dart';

const List<TasbihItem> defaultTasbihs = [
  TasbihItem(id: 'subhanallah', arabicName: 'سُبْحَانَ اللَّهِ', englishName: 'SubhanAllah', target: 33),
  TasbihItem(id: 'alhamdulillah', arabicName: 'الْحَمْدُ لِلَّهِ', englishName: 'Alhamdulillah', target: 33),
  TasbihItem(id: 'allahu-akbar', arabicName: 'اللَّهُ أَكْبَرُ', englishName: 'Allahu Akbar', target: 34),
  TasbihItem(id: 'la-ilaha', arabicName: 'لَا إِلَهَ إِلَّا اللَّهُ', englishName: 'La ilaha illallah', target: 100),
  TasbihItem(id: 'astaghfirullah', arabicName: 'أَسْتَغْفِرُ اللَّهَ', englishName: 'Astaghfirullah', target: 100),
  TasbihItem(id: 'durood', arabicName: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ', englishName: 'Durood Sharif', target: 100),
  TasbihItem(id: 'subhan-bihamdihi', arabicName: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', englishName: 'SubhanAllahi wa bihamdihi', target: 100),
];

const List<CreditPackage> creditPackages = [
  CreditPackage(id: 'credits_50', name: 'Starter Pack', credits: 50, priceText: '৳100 (placeholder)'),
  CreditPackage(id: 'credits_120', name: 'Value Pack', credits: 120, priceText: '৳200 (placeholder)', badge: 'Best value'),
  CreditPackage(id: 'credits_300', name: 'Premium Pack', credits: 300, priceText: '৳450 (placeholder)'),
];
