// Bundled hadiths — only well-known hadiths with confident attribution.
// Arabic is a short authentic excerpt; the English is the full meaning.
// A number is given only where it is well established.
import '../models/models.dart';

const List<Hadith> hadiths = [
  // ---------------- Sahih al-Bukhari ----------------
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Faith',
    number: '1',
    arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
    english:
        'Actions are but by intentions, and every person shall have only that which he intended.',
    banglaMeaning:
        'আমলসমূহ কেবল নিয়তের উপর নির্ভরশীল, এবং প্রত্যেক ব্যক্তি তাই পাবে যা সে নিয়ত করেছে।',
    narrator: 'Umar ibn al-Khattab',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Faith',
    number: '8',
    arabic: 'بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ',
    english:
        'Islam is built upon five: testifying that there is no god except Allah and that Muhammad is the Messenger of Allah, establishing prayer, giving zakah, Hajj, and fasting Ramadan.',
    banglaMeaning:
        'ইসলাম পাঁচটি ভিত্তির উপর প্রতিষ্ঠিত: সাক্ষ্য দেওয়া যে আল্লাহ ছাড়া কোনো ইলাহ নেই এবং মুহাম্মদ আল্লাহর রাসূল, নামাজ কায়েম করা, যাকাত দেওয়া, হজ করা এবং রমজানের রোজা রাখা।',
    narrator: 'Abdullah ibn Umar',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Faith',
    number: '13',
    arabic: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
    english:
        'None of you truly believes until he loves for his brother what he loves for himself.',
    banglaMeaning:
        'তোমাদের কেউই প্রকৃত মুমিন হতে পারবে না, যতক্ষণ না সে তার ভাইয়ের জন্য তাই ভালোবাসে যা সে নিজের জন্য ভালোবাসে।',
    narrator: 'Anas ibn Malik',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Fasting',
    number: '38',
    arabic: 'مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
    english:
        'Whoever fasts Ramadan out of faith and hoping for reward, his previous sins will be forgiven.',
    banglaMeaning:
        'যে ব্যক্তি ঈমানসহ ও সওয়াবের আশায় রমজানের রোজা রাখে, তার পূর্ববর্তী গুনাহসমূহ ক্ষমা করে দেওয়া হবে।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Quran',
    number: '5027',
    arabic: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
    english: 'The best among you are those who learn the Quran and teach it.',
    banglaMeaning: 'তোমাদের মধ্যে সর্বোত্তম তারাই, যারা কুরআন শেখে এবং শেখায়।',
    narrator: 'Uthman ibn Affan',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Character',
    number: '6018',
    arabic: 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
    english:
        'Whoever believes in Allah and the Last Day, let him speak good or remain silent.',
    banglaMeaning:
        'যে ব্যক্তি আল্লাহ ও আখিরাতের দিনের প্রতি ঈমান রাখে, সে যেন ভালো কথা বলে অথবা চুপ থাকে।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Character',
    number: '6114',
    arabic:
        'لَيْسَ الشَّدِيدُ بِالصُّرَعَةِ، إِنَّمَا الشَّدِيدُ الَّذِي يَمْلِكُ نَفْسَهُ عِنْدَ الْغَضَبِ',
    english:
        'The strong person is not the one who overcomes others by wrestling. The strong person is the one who controls himself in anger.',
    banglaMeaning:
        'শক্তিশালী সে নয়, যে কুস্তিতে অন্যকে পরাজিত করে। শক্তিশালী সে-ই, যে রাগের সময় নিজেকে নিয়ন্ত্রণে রাখে।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Remembrance',
    number: '6405',
    arabic: 'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ حُطَّتْ خَطَايَاهُ وَإِنْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
    english:
        'Whoever says "SubhanAllahi wa bihamdihi" one hundred times a day, his sins will be forgiven even if they are like the foam of the sea.',
    banglaMeaning:
        'যে ব্যক্তি দিনে একশ বার "সুবহানাল্লাহি ওয়া বিহামদিহি" বলবে, তার গুনাহসমূহ ক্ষমা করে দেওয়া হবে, যদিও তা সমুদ্রের ফেনার মতো হয়।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Character',
    number: '6412',
    arabic: 'نِعْمَتَانِ مَغْبُونٌ فِيهِمَا كَثِيرٌ مِنَ النَّاسِ: الصِّحَّةُ وَالْفَرَاغُ',
    english:
        'There are two blessings in which many people are in loss: health and free time.',
    banglaMeaning:
        'দুটি নিয়ামত আছে, যাতে অধিকাংশ মানুষ ক্ষতিগ্রস্ত হয়: সুস্থতা ও অবসর সময়।',
    narrator: 'Abdullah ibn Abbas',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Worship',
    number: '6464',
    arabic: 'أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ',
    english:
        'The most beloved deeds to Allah are the most consistent, even if they are small.',
    banglaMeaning:
        'আল্লাহর কাছে সবচেয়ে প্রিয় আমল হলো তা, যা নিয়মিত করা হয়, যদিও তা অল্প হয়।',
    narrator: 'Aisha',
    grade: 'Sahih',
  ),
  // ---------------- Sahih Muslim ----------------
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Faith',
    number: '35',
    arabic: 'الإِيمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً',
    english:
        'Faith has over seventy branches, the highest of which is saying "La ilaha illallah" and the lowest is removing a harmful thing from the road, and modesty is a branch of faith.',
    banglaMeaning:
        'ঈমানের সত্তরেরও বেশি শাখা রয়েছে, যার সর্বোচ্চ হলো "লা ইলাহা ইল্লাল্লাহ" বলা এবং সর্বনিম্ন হলো রাস্তা থেকে কষ্টদায়ক জিনিস সরিয়ে দেওয়া, আর লজ্জাশীলতা ঈমানের একটি শাখা।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Purification',
    number: '223',
    arabic: 'الطُّهُورُ شَطْرُ الإِيمَانِ',
    english:
        'Purification is half of faith, "Alhamdulillah" fills the scale, and "SubhanAllah" and "Alhamdulillah" fill what is between the heavens and the earth.',
    banglaMeaning:
        'পবিত্রতা ঈমানের অর্ধেক, "আলহামদুলিল্লাহ" মীযান পূর্ণ করে দেয়, আর "সুবহানাল্লাহ" ও "আলহামদুলিল্লাহ" আসমান ও জমিনের মধ্যবর্তী স্থান পূর্ণ করে দেয়।',
    narrator: 'Abu Malik al-Ash\'ari',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Prayer',
    number: '408',
    arabic: 'مَنْ صَلَّى عَلَىَّ وَاحِدَةً صَلَّى اللَّهُ عَلَيْهِ عَشْرًا',
    english:
        'Whoever sends blessings upon me once, Allah sends blessings upon him ten times.',
    banglaMeaning:
        'যে ব্যক্তি আমার উপর একবার দরুদ পাঠ করে, আল্লাহ তার উপর দশবার রহমত বর্ষণ করেন।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Prayer',
    number: '482',
    arabic: 'أَقْرَبُ مَا يَكُونُ الْعَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ',
    english:
        'The closest a servant is to his Lord is while he is prostrating, so increase your supplication then.',
    banglaMeaning:
        'বান্দা তার রবের সবচেয়ে নিকটবর্তী হয় সিজদারত অবস্থায়, তাই তখন বেশি বেশি দোয়া করো।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Prayer',
    number: '656',
    arabic: 'مَنْ صَلَّى الْعِشَاءَ فِي جَمَاعَةٍ فَكَأَنَّمَا قَامَ نِصْفَ اللَّيْلِ',
    english:
        'Whoever prays Isha in congregation, it is as if he prayed half the night; and whoever prays Fajr in congregation, it is as if he prayed the whole night.',
    banglaMeaning:
        'যে ব্যক্তি জামাতে ইশার নামাজ পড়ে, সে যেন অর্ধেক রাত নামাজ পড়ল; আর যে ব্যক্তি জামাতে ফজরের নামাজ পড়ে, সে যেন পুরো রাত নামাজ পড়ল।',
    narrator: 'Uthman ibn Affan',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Prayer',
    number: '725',
    arabic: 'رَكْعَتَا الْفَجْرِ خَيْرٌ مِنَ الدُّنْيَا وَمَا فِيهَا',
    english: 'The two rak\'ahs before Fajr are better than the world and everything in it.',
    banglaMeaning: 'ফজরের পূর্বের দুই রাকাত (সুন্নত) নামাজ দুনিয়া ও এর মধ্যে যা কিছু আছে, তার চেয়ে উত্তম।',
    narrator: 'Aisha',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Prayer',
    number: '728',
    arabic: 'مَنْ صَلَّى اثْنَتَيْ عَشْرَةَ رَكْعَةً فِي يَوْمٍ وَلَيْلَةٍ بُنِيَ لَهُ بَيْتٌ فِي الْجَنَّةِ',
    english:
        'Whoever prays twelve rak\'ahs of voluntary prayer in a day and night, a house will be built for him in Paradise.',
    banglaMeaning:
        'যে ব্যক্তি দিনে ও রাতে বারো রাকাত নফল নামাজ পড়ে, তার জন্য জান্নাতে একটি ঘর নির্মাণ করা হবে।',
    narrator: 'Umm Habibah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Fasting',
    number: '1163',
    arabic: 'أَفْضَلُ الصِّيَامِ بَعْدَ رَمَضَانَ شَهْرُ اللَّهِ الْمُحَرَّمُ',
    english:
        'The best fasting after Ramadan is the fasting in the month of Allah, Muharram.',
    banglaMeaning:
        'রমজানের পর সর্বোত্তম রোজা হলো আল্লাহর মাস মুহাররমের রোজা।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Charity',
    number: '1631',
    arabic: 'إِذَا مَاتَ الإِنْسَانُ انْقَطَعَ عَنْهُ عَمَلُهُ إِلاَّ مِنْ ثَلاَثَةٍ: صَدَقَةٍ جَارِيَةٍ أَوْ عِلْمٍ يُنْتَفَعُ بِهِ أَوْ وَلَدٍ صَالِحٍ يَدْعُو لَهُ',
    english:
        'When a person dies, his deeds come to an end except for three: ongoing charity, knowledge that benefits others, or a righteous child who prays for him.',
    banglaMeaning:
        'মানুষ মারা গেলে তার আমল বন্ধ হয়ে যায়, তবে তিনটি জিনিস ছাড়া: সদকায়ে জারিয়া, উপকারী জ্ঞান, অথবা নেক সন্তান যে তার জন্য দোয়া করে।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Character',
    number: '2564',
    arabic: 'إِنَّ اللَّهَ لاَ يَنْظُرُ إِلَى صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ وَأَعْمَالِكُمْ',
    english:
        'Indeed, Allah does not look at your appearance or your wealth, but He looks at your hearts and your deeds.',
    banglaMeaning:
        'নিশ্চয়ই আল্লাহ তোমাদের চেহারা বা সম্পদের দিকে তাকান না, বরং তিনি তোমাদের অন্তর ও আমলের দিকে তাকান।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  // ---------------- Sunan Abu Dawud ----------------
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Purification',
    number: '61',
    arabic: 'مِفْتَاحُ الصَّلاَةِ الطُّهُورُ وَتَحْرِيمُهَا التَّكْبِيرُ وَتَحْلِيلُهَا التَّسْلِيمُ',
    english:
        'The key to prayer is purification, its opening is the takbir, and its ending is the taslim.',
    banglaMeaning:
        'নামাজের চাবি হলো পবিত্রতা, এর শুরু হলো তাকবির, আর এর সমাপ্তি হলো তাসলিম।',
    narrator: 'Ali ibn Abi Talib',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Prayer',
    number: '1418',
    arabic: 'إِنَّ اللَّهَ قَدْ أَمَدَّكُمْ بِصَلاَةٍ هِيَ خَيْرٌ لَكُمْ مِنْ حُمْرِ النَّعَمِ: الْوِتْرُ',
    english:
        'Indeed, Allah has given you an extra prayer which is better for you than red camels: the Witr prayer.',
    banglaMeaning:
        'নিশ্চয়ই আল্লাহ তোমাদেরকে একটি অতিরিক্ত নামাজ দিয়েছেন, যা তোমাদের জন্য লাল উটের চেয়েও উত্তম: বিতর নামাজ।',
    narrator: 'Kharijah ibn Hudhafah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Prayer',
    number: '1522',
    arabic: 'يَا مُعَاذُ وَاللَّهِ إِنِّي لأُحِبُّكَ',
    english:
        'O Mu\'adh, by Allah, I love you. So never forget to say after every prayer: "O Allah, help me to remember You, thank You, and worship You in the best manner."',
    banglaMeaning:
        'হে মুআয! আল্লাহর কসম, আমি তোমাকে ভালোবাসি। তাই প্রত্যেক নামাজের পর এ কথা বলতে কখনো ভুলো না: "হে আল্লাহ, আমাকে তোমাকে স্মরণ করতে, তোমার শুকরিয়া আদায় করতে এবং সর্বোত্তমভাবে তোমার ইবাদত করতে সাহায্য করো।"',
    narrator: 'Mu\'adh ibn Jabal',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Charity',
    number: '1679',
    arabic: 'أَفْضَلُ الصَّدَقَةِ سَقْيُ الْمَاءِ',
    english: 'The best charity is giving water to drink.',
    banglaMeaning: 'সর্বোত্তম সদকা হলো (পিপাসার্তকে) পানি পান করানো।',
    narrator: 'Sa\'d ibn Ubadah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Character',
    number: '4031',
    arabic: 'مَنْ تَشَبَّهَ بِقَوْمٍ فَهُوَ مِنْهُمْ',
    english: 'Whoever imitates a people is one of them.',
    banglaMeaning: 'যে ব্যক্তি কোনো সম্প্রদায়ের অনুকরণ করে, সে তাদেরই অন্তর্ভুক্ত।',
    narrator: 'Abdullah ibn Umar',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Character',
    number: '4344',
    arabic: 'أَفْضَلُ الْجِهَادِ كَلِمَةُ عَدْلٍ عِنْدَ سُلْطَانٍ جَائِرٍ',
    english:
        'The best jihad is a word of truth spoken before a tyrannical ruler.',
    banglaMeaning:
        'সর্বোত্তম জিহাদ হলো অত্যাচারী শাসকের সামনে সত্য কথা বলা।',
    narrator: 'Abu Sa\'id al-Khudri',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Character',
    number: '4682',
    arabic: 'إِنَّ مِنْ أَكْمَلِ الْمُؤْمِنِينَ إِيمَانًا أَحْسَنُهُمْ خُلُقًا',
    english:
        'The most perfect believer in faith is the one with the best character.',
    banglaMeaning:
        'ঈমানে সবচেয়ে পরিপূর্ণ মুমিন সে-ই, যার চরিত্র সবচেয়ে উত্তম।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Remembrance',
    number: '5095',
    arabic: 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    english:
        'Whoever says when leaving his home: "In the name of Allah, I trust in Allah, there is no power and no strength except with Allah," it will be said to him: you are guided, sufficed, and protected.',
    banglaMeaning:
        'যে ব্যক্তি ঘর থেকে বের হওয়ার সময় বলে: "বিসমিল্লাহি তাওয়াক্কালতু আলাল্লাহ, লা হাওলা ওয়া লা কুওয়াতা ইল্লা বিল্লাহ" — তাকে বলা হবে: তুমি হেদায়েতপ্রাপ্ত হয়েছ, তোমার জন্য যথেষ্ট করা হয়েছে এবং তুমি সুরক্ষিত হয়েছ।',
    narrator: 'Anas ibn Malik',
    grade: 'Sahih',
  ),
  // ---------------- Jami at-Tirmidhi ----------------
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Character',
    number: '1987',
    arabic: 'اتَّقِ اللَّهَ حَيْثُمَا كُنْتَ وَأَتْبِعِ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ',
    english:
        'Fear Allah wherever you are, follow a bad deed with a good deed and it will erase it, and treat people with good character.',
    banglaMeaning:
        'তুমি যেখানেই থাকো, আল্লাহকে ভয় করো; খারাপ কাজের পর ভালো কাজ করো, তা খারাপ কাজকে মুছে দেবে; আর মানুষের সঙ্গে উত্তম চরিত্রে আচরণ করো।',
    narrator: 'Abu Dharr al-Ghifari',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Heart',
    number: '2465',
    arabic: 'مَنْ كَانَتِ الآخِرَةُ هَمَّهُ جَعَلَ اللَّهُ غِنَاهُ فِي قَلْبِهِ',
    english:
        'Whoever makes the Hereafter his main concern, Allah will place richness in his heart and gather his affairs for him.',
    banglaMeaning:
        'যে ব্যক্তি আখিরাতকে তার প্রধান চিন্তা বানায়, আল্লাহ তার অন্তরে ধনাঢ্যতা দান করেন এবং তার বিষয়গুলো গুছিয়ে দেন।',
    narrator: 'Anas ibn Malik',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Character',
    number: '2516',
    arabic: 'دَعْ مَا يَرِيبُكَ إِلَى مَا لاَ يَرِيبُكَ',
    english: 'Leave what makes you doubt for what does not make you doubt.',
    banglaMeaning: 'যা তোমাকে সন্দেহে ফেলে, তা ছেড়ে যা সন্দেহে ফেলে না, তা গ্রহণ করো।',
    narrator: 'Al-Hasan ibn Ali',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Remembrance',
    number: '3383',
    arabic: 'أَفْضَلُ الذِّكْرِ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَفْضَلُ الدُّعَاءِ الْحَمْدُ لِلَّهِ',
    english:
        'The best remembrance is "La ilaha illallah" and the best supplication is "Alhamdulillah".',
    banglaMeaning:
        'সর্বোত্তম জিকির হলো "লা ইলাহা ইল্লাল্লাহ" এবং সর্বোত্তম দোয়া হলো "আলহামদুলিল্লাহ"।',
    narrator: 'Jabir ibn Abdullah',
    grade: 'Hasan',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Supplication',
    number: '3585',
    arabic: 'خَيْرُ الدُّعَاءِ دُعَاءُ يَوْمِ عَرَفَةَ',
    english: 'The best supplication is the supplication on the Day of Arafah.',
    banglaMeaning: 'সর্বোত্তম দোয়া হলো আরাফার দিনের দোয়া।',
    narrator: 'Amr ibn Shu\'ayb, from his father, from his grandfather',
    grade: 'Hasan',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Supplication',
    number: '3598',
    arabic: 'ثَلاَثَةٌ لاَ تُرَدُّ دَعْوَتُهُمْ: الصَّائِمُ حَتَّى يُفْطِرَ وَالإِمَامُ الْعَادِلُ وَدَعْوَةُ الْمَظْلُومِ',
    english:
        'There are three whose supplication is not rejected: the fasting person until he breaks his fast, the just leader, and the supplication of the oppressed.',
    banglaMeaning:
        'তিন ব্যক্তির দোয়া ফিরিয়ে দেওয়া হয় না: রোজাদার ব্যক্তি, যতক্ষণ না সে ইফতার করে; ন্যায়পরায়ণ নেতা; এবং মজলুমের দোয়া।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Character',
    number: '3895',
    arabic: 'خَيْرُكُمْ خَيْرُكُمْ لأَهْلِهِ وَأَنَا خَيْرُكُمْ لأَهْلِي',
    english:
        'The best of you are the best to their families, and I am the best of you to my family.',
    banglaMeaning:
        'তোমাদের মধ্যে সর্বোত্তম সে-ই, যে তার পরিবারের কাছে সর্বোত্তম, আর আমি তোমাদের মধ্যে আমার পরিবারের কাছে সর্বোত্তম।',
    narrator: 'Aisha',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Prayer',
    number: '586',
    arabic: 'مَنْ صَلَّى الْغَدَاةَ فِي جَمَاعَةٍ ثُمَّ قَعَدَ يَذْكُرُ اللَّهَ حَتَّى تَطْلُعَ الشَّمْسُ ثُمَّ صَلَّى رَكْعَتَيْنِ كَانَتْ لَهُ كَأَجْرِ حَجَّةٍ وَعُمْرَةٍ',
    english:
        'Whoever prays Fajr in congregation, then sits remembering Allah until the sun rises, then prays two rak\'ahs, will have a reward like that of Hajj and Umrah.',
    banglaMeaning:
        'যে ব্যক্তি জামাতে ফজরের নামাজ পড়ে, এরপর সূর্য ওঠা পর্যন্ত আল্লাহর জিকিরে বসে থাকে, তারপর দুই রাকাত নামাজ পড়ে, সে হজ ও ওমরাহর মতো সওয়াব পাবে।',
    narrator: 'Anas ibn Malik',
    grade: 'Hasan',
  ),
  // ---------------- Sunan an-Nasa'i ----------------
  Hadith(
    collection: "Sunan an-Nasa'i",
    book: 'Prayer',
    number: '465',
    arabic: 'أَوَّلُ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ الصَّلاَةُ',
    english:
        'The first thing a servant will be held accountable for on the Day of Resurrection is the prayer.',
    banglaMeaning:
        'কিয়ামতের দিন বান্দার কাছ থেকে সর্বপ্রথম যে বিষয়ে হিসাব নেওয়া হবে, তা হলো নামাজ।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: "Sunan an-Nasa'i",
    book: 'Mosques',
    number: '688',
    arabic: 'مَنْ بَنَى مَسْجِدًا لِلَّهِ بَنَى اللَّهُ لَهُ بَيْتًا فِي الْجَنَّةِ',
    english:
        'Whoever builds a mosque for Allah, Allah will build a house for him in Paradise.',
    banglaMeaning:
        'যে ব্যক্তি আল্লাহর জন্য একটি মসজিদ নির্মাণ করে, আল্লাহ তার জন্য জান্নাতে একটি ঘর নির্মাণ করবেন।',
    narrator: 'Uthman ibn Affan',
    grade: 'Sahih',
  ),
  Hadith(
    collection: "Sunan an-Nasa'i",
    book: 'Prayer',
    number: '1748',
    arabic: 'إِنَّ اللَّهَ قَدْ أَمَدَّكُمْ بِصَلاَةٍ هِيَ خَيْرٌ لَكُمْ مِنْ حُمْرِ النَّعَمِ: الْوِتْرُ',
    english:
        'Indeed, Allah has given you an extra prayer which is better for you than red camels: the Witr prayer.',
    banglaMeaning:
        'নিশ্চয়ই আল্লাহ তোমাদেরকে একটি অতিরিক্ত নামাজ দিয়েছেন, যা তোমাদের জন্য লাল উটের চেয়েও উত্তম: বিতর নামাজ।',
    narrator: 'Kharijah ibn Hudhafah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: "Sunan an-Nasa'i",
    book: 'Fasting',
    number: '2245',
    arabic: 'مَنْ صَامَ يَوْمًا فِي سَبِيلِ اللَّهِ بَعَّدَ اللَّهُ وَجْهَهُ عَنِ النَّارِ سَبْعِينَ خَرِيفًا',
    english:
        'Whoever fasts one day in the cause of Allah, Allah will keep his face away from the Fire for seventy autumns.',
    banglaMeaning:
        'যে ব্যক্তি আল্লাহর পথে একদিন রোজা রাখে, আল্লাহ তার মুখমণ্ডলকে জাহান্নাম থেকে সত্তর শরৎকাল দূরে রাখবেন।',
    narrator: 'Abu Sa\'id al-Khudri',
    grade: 'Sahih',
  ),
  Hadith(
    collection: "Sunan an-Nasa'i",
    book: 'Fasting',
    number: '2418',
    arabic: 'مَنْ صَامَ رَمَضَانَ ثُمَّ أَتْبَعَهُ سِتًّا مِنْ شَوَّالٍ كَانَ كَصِيَامِ الدَّهْرِ',
    english:
        'Whoever fasts Ramadan and then follows it with six days of Shawwal, it is as if he fasted the whole year.',
    banglaMeaning:
        'যে ব্যক্তি রমজানের রোজা রাখে এবং এরপর শাওয়ালের ছয় দিন রোজা রাখে, সে যেন পুরো বছর রোজা রাখল।',
    narrator: 'Abu Ayyub al-Ansari',
    grade: 'Sahih',
  ),
  Hadith(
    collection: "Sunan an-Nasa'i",
    book: 'Prayer',
    number: '9848 (al-Kubra)',
    arabic: 'مَنْ قَرَأَ آيَةَ الْكُرْسِيِّ فِي دُبُرِ كُلِّ صَلاَةٍ مَكْتُوبَةٍ لَمْ يَمْنَعْهُ مِنْ دُخُولِ الْجَنَّةِ إِلاَّ أَنْ يَمُوتَ',
    english:
        'Whoever recites Ayat al-Kursi after every obligatory prayer, nothing will prevent him from entering Paradise except death.',
    banglaMeaning:
        'যে ব্যক্তি প্রত্যেক ফরজ নামাজের পর আয়াতুল কুরসি পাঠ করে, মৃত্যু ছাড়া আর কিছুই তাকে জান্নাতে প্রবেশ করতে বাধা দেবে না।',
    narrator: 'Abu Umamah al-Bahili',
    grade: 'Sahih',
  ),
  // ---------------- Sunan Ibn Majah ----------------
  Hadith(
    collection: 'Sunan Ibn Majah',
    book: 'Knowledge',
    number: '224',
    arabic: 'طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ',
    english: 'Seeking knowledge is an obligation upon every Muslim.',
    banglaMeaning: 'জ্ঞান অর্জন করা প্রত্যেক মুসলিমের উপর ফরজ।',
    narrator: 'Anas ibn Malik',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Ibn Majah',
    book: 'Knowledge',
    number: '266',
    arabic: 'مَنْ سُئِلَ عَنْ عِلْمٍ فَكَتَمَهُ أُلْجِمَ يَوْمَ الْقِيَامَةِ بِلِجَامٍ مِنْ نَارٍ',
    english:
        'Whoever is asked about knowledge and conceals it will be bridled on the Day of Resurrection with a bridle of fire.',
    banglaMeaning:
        'যাকে জ্ঞান সম্পর্কে জিজ্ঞাসা করা হয়, অথচ সে তা গোপন করে, কিয়ামতের দিন তাকে আগুনের লাগাম পরানো হবে।',
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Ibn Majah',
    book: 'Fasting',
    number: '1717',
    arabic: 'مَنْ صَامَ يَوْمًا فِي سَبِيلِ اللَّهِ بَعَّدَ اللَّهُ وَجْهَهُ عَنِ النَّارِ سَبْعِينَ خَرِيفًا',
    english:
        'Whoever fasts one day in the cause of Allah, Allah will keep his face away from the Fire for seventy autumns.',
    banglaMeaning:
        'যে ব্যক্তি আল্লাহর পথে একদিন রোজা রাখে, আল্লাহ তার মুখমণ্ডলকে জাহান্নাম থেকে সত্তর শরৎকাল দূরে রাখবেন।',
    narrator: 'Abu Sa\'id al-Khudri',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Ibn Majah',
    book: 'Marriage',
    number: '1846',
    arabic: 'النِّكَاحُ مِنْ سُنَّتِي فَمَنْ رَغِبَ عَنْ سُنَّتِي فَلَيْسَ مِنِّي',
    english:
        'Marriage is part of my Sunnah, so whoever turns away from my Sunnah is not from me.',
    banglaMeaning:
        'বিয়ে আমার সুন্নতের অন্তর্ভুক্ত, তাই যে ব্যক্তি আমার সুন্নত থেকে মুখ ফিরিয়ে নেয়, সে আমার অন্তর্ভুক্ত নয়।',
    narrator: 'Aisha',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Ibn Majah',
    book: 'Heart',
    number: '4105',
    arabic: 'مَنْ كَانَتِ الدُّنْيَا هَمَّهُ فَرَّقَ اللَّهُ عَلَيْهِ أَمْرَهُ وَجَعَلَ فَقْرَهُ بَيْنَ عَيْنَيْهِ',
    english:
        'Whoever makes the world his main concern, Allah will scatter his affairs and place poverty before his eyes.',
    banglaMeaning:
        'যে ব্যক্তি দুনিয়াকে তার প্রধান চিন্তা বানায়, আল্লাহ তার বিষয়গুলো ছিন্নভিন্ন করে দেবেন এবং তার চোখের সামনে দারিদ্র্য স্থাপন করবেন।',
    narrator: 'Zayd ibn Thabit',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Ibn Majah',
    book: 'Repentance',
    number: '4251',
    arabic: 'كُلُّ ابْنِ آدَمَ خَطَّاءٌ وَخَيْرُ الْخَطَّائِينَ التَّوَّابُونَ',
    english:
        'Every son of Adam sins, and the best of those who sin are those who repent.',
    banglaMeaning:
        'আদম সন্তান প্রত্যেকেই গুনাহ করে, আর গুনাহকারীদের মধ্যে সর্বোত্তম তারাই, যারা তওবা করে।',
    narrator: 'Anas ibn Malik',
    grade: 'Hasan',
  ),
];

const List<String> hadithCollections = [
  'Sahih al-Bukhari',
  'Sahih Muslim',
  'Sunan Abu Dawud',
  'Jami at-Tirmidhi',
  "Sunan an-Nasa'i",
  'Sunan Ibn Majah',
];

List<Hadith> hadithsByCollection(String collection) =>
    hadiths.where((h) => h.collection == collection).toList();
