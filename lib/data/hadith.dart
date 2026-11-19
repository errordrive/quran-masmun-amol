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
    narrator: 'Abu Hurayrah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih al-Bukhari',
    book: 'Quran',
    number: '5027',
    arabic: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
    english: 'The best among you are those who learn the Quran and teach it.',
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
    narrator: 'Uthman ibn Affan',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sahih Muslim',
    book: 'Prayer',
    number: '725',
    arabic: 'رَكْعَتَا الْفَجْرِ خَيْرٌ مِنَ الدُّنْيَا وَمَا فِيهَا',
    english: 'The two rak\'ahs before Fajr are better than the world and everything in it.',
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
    narrator: 'Mu\'adh ibn Jabal',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Charity',
    number: '1679',
    arabic: 'أَفْضَلُ الصَّدَقَةِ سَقْيُ الْمَاءِ',
    english: 'The best charity is giving water to drink.',
    narrator: 'Sa\'d ibn Ubadah',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Sunan Abu Dawud',
    book: 'Character',
    number: '4031',
    arabic: 'مَنْ تَشَبَّهَ بِقَوْمٍ فَهُوَ مِنْهُمْ',
    english: 'Whoever imitates a people is one of them.',
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
    narrator: 'Anas ibn Malik',
    grade: 'Sahih',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Character',
    number: '2516',
    arabic: 'دَعْ مَا يَرِيبُكَ إِلَى مَا لاَ يَرِيبُكَ',
    english: 'Leave what makes you doubt for what does not make you doubt.',
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
    narrator: 'Jabir ibn Abdullah',
    grade: 'Hasan',
  ),
  Hadith(
    collection: 'Jami at-Tirmidhi',
    book: 'Supplication',
    number: '3585',
    arabic: 'خَيْرُ الدُّعَاءِ دُعَاءُ يَوْمِ عَرَفَةَ',
    english: 'The best supplication is the supplication on the Day of Arafah.',
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
