// Bundled duas (morning & evening adhkar + daily masnun duas).
// Only duas the author is confident about are included; references give the
// source collection, with a hadith number only where it is well established.
import '../models/models.dart';

const List<Dua> duas = [
  // ---------- Morning & Evening Adhkar ----------
  Dua(
    id: 'ayat-kursi',
    title: 'Ayat al-Kursi',
    category: 'morning',
    arabic:
        'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
    transliteration:
        'Allahu la ilaha illa Huwal-Hayyul-Qayyum, la ta\'khudhuhu sinatun wa la nawm, lahu ma fis-samawati wa ma fil-ard, man dhalladhi yashfa\'u \'indahu illa bi-idhnih, ya\'lamu ma bayna aydihim wa ma khalfahum, wa la yuhituna bi shay\'im-min \'ilmihi illa bima sha\', wasi\'a kursiyyuhus-samawati wal-ard, wa la ya\'uduhu hifzuhuma, wa Huwal-\'Aliyyul-\'Azim.',
    meaning:
        'Allah — there is no god except Him, the Ever-Living, the Sustainer of all. Neither drowsiness nor sleep overtakes Him. To Him belongs whatever is in the heavens and whatever is on the earth. Who can intercede with Him except by His permission? He knows what is before them and what is behind them, and they encompass nothing of His knowledge except what He wills. His Kursi extends over the heavens and the earth, and their preservation does not tire Him. And He is the Most High, the Most Great.',
    reference: 'Quran 2:255 — recite morning and evening',
  ),
  Dua(
    id: 'surah-ikhlas',
    title: 'Surah Al-Ikhlas (3 times)',
    category: 'morning',
    arabic:
        'قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾ اللَّهُ الصَّمَدُ ﴿٢﴾ لَمْ يَلِدْ وَلَمْ يُولَدْ ﴿٣﴾ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ ﴿٤﴾',
    transliteration:
        'Qul Huwallahu Ahad. Allahus-Samad. Lam yalid wa lam yulad. Wa lam yakun lahu kufuwan Ahad.',
    meaning:
        'Say: He is Allah, the One. Allah, the Eternal Refuge. He neither begets nor is born, and there is none comparable to Him.',
    reference: 'Quran 112 — recite 3 times morning and evening',
  ),
  Dua(
    id: 'surah-falaq',
    title: 'Surah Al-Falaq (3 times)',
    category: 'morning',
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ﴿١﴾ مِنْ شَرِّ مَا خَلَقَ ﴿٢﴾ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ﴿٣﴾ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ﴿٤﴾ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ ﴿٥﴾',
    transliteration:
        'Qul a\'udhu bi Rabbil-falaq. Min sharri ma khalaq. Wa min sharri ghasiqin idha waqab. Wa min sharrin-naffathati fil-\'uqad. Wa min sharri hasidin idha hasad.',
    meaning:
        'Say: I seek refuge in the Lord of daybreak, from the evil of what He created, from the evil of darkness when it settles, from the evil of those who blow on knots, and from the evil of the envier when he envies.',
    reference: 'Quran 113 — recite 3 times morning and evening',
  ),
  Dua(
    id: 'surah-nas',
    title: 'Surah An-Nas (3 times)',
    category: 'morning',
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ﴿١﴾ مَلِكِ النَّاسِ ﴿٢﴾ إِلَٰهِ النَّاسِ ﴿٣﴾ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ﴿٤﴾ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ﴿٥﴾ مِنَ الْجِنَّةِ وَالنَّاسِ ﴿٦﴾',
    transliteration:
        'Qul a\'udhu bi Rabbin-nas. Malikin-nas. Ilahin-nas. Min sharril-waswasil-khannas. Alladhi yuwaswisu fi sudurin-nas. Minal-jinnati wan-nas.',
    meaning:
        'Say: I seek refuge in the Lord of mankind, the King of mankind, the God of mankind, from the evil of the retreating whisperer who whispers in the breasts of mankind, from among the jinn and mankind.',
    reference: 'Quran 114 — recite 3 times morning and evening',
  ),
  Dua(
    id: 'bismillah-protection',
    title: 'Protection from all harm (3 times)',
    category: 'morning',
    arabic:
        'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
    transliteration:
        'Bismillahilladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\'i wa Huwas-Sami\'ul-\'Alim.',
    meaning:
        'In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, the All-Knowing.',
    reference: 'Sunan Abu Dawud, Jami at-Tirmidhi — recite 3 times morning and evening',
  ),
  Dua(
    id: 'morning-asbahna',
    title: 'Morning remembrance',
    category: 'morning',
    arabic:
        'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
    transliteration:
        'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur.',
    meaning:
        'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.',
    reference: 'Jami at-Tirmidhi, Sunan Abu Dawud — morning',
  ),
  Dua(
    id: 'evening-amsayna',
    title: 'Evening remembrance',
    category: 'morning',
    arabic:
        'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ',
    transliteration:
        'Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namutu, wa ilaykal-masir.',
    meaning:
        'O Allah, by You we enter the evening and by You we enter the morning, by You we live and by You we die, and to You is the return.',
    reference: 'Jami at-Tirmidhi, Sunan Abu Dawud — evening',
  ),
  Dua(
    id: 'sayyidul-istighfar',
    title: 'Sayyidul Istighfar (best seeking of forgiveness)',
    category: 'morning',
    arabic:
        'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    transliteration:
        'Allahumma Anta Rabbi, la ilaha illa Anta, khalaqtani wa ana \'abduk, wa ana \'ala \'ahdika wa wa\'dika mastata\'t, a\'udhu bika min sharri ma sana\'t, abu\'u laka bi ni\'matika \'alayya, wa abu\'u bi dhanbi, faghfir li, fa innahu la yaghfirudh-dhunuba illa Anta.',
    meaning:
        'O Allah, You are my Lord, there is no god except You. You created me and I am Your servant, and I am upon Your covenant and promise as much as I am able. I seek refuge in You from the evil of what I have done. I acknowledge Your favour upon me, and I acknowledge my sin, so forgive me, for none forgives sins except You.',
    reference: 'Sahih al-Bukhari 6306 — morning and evening',
  ),
  Dua(
    id: 'afwa-afiyah',
    title: 'Asking for pardon and well-being',
    category: 'morning',
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
    transliteration:
        'Allahumma inni as\'alukal-\'afwa wal-\'afiyata fid-dunya wal-akhirah.',
    meaning:
        'O Allah, I ask You for pardon and well-being in this world and the Hereafter.',
    reference: 'Sunan Abu Dawud — morning and evening',
  ),
  Dua(
    id: 'hasbiyallah',
    title: 'Allah is sufficient for me (7 times)',
    category: 'morning',
    arabic:
        'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ ۖ عَلَيْهِ تَوَكَّلْتُ ۖ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
    transliteration:
        'Hasbiyallahu la ilaha illa Huwa, \'alayhi tawakkaltu, wa Huwa Rabbul-\'Arshil-\'Azim.',
    meaning:
        'Allah is sufficient for me; there is no god except Him. In Him I put my trust, and He is the Lord of the Mighty Throne.',
    reference: 'Quran 9:129 — recite 7 times morning and evening',
  ),
  // ---------- Daily / Masnun duas ----------
  Dua(
    id: 'before-eating',
    title: 'Before eating',
    category: 'daily',
    arabic: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    transliteration: 'Bismillahi wa \'ala barakatillah.',
    meaning: 'In the name of Allah, and with the blessing of Allah.',
    reference: 'Sunan Abu Dawud, Jami at-Tirmidhi',
  ),
  Dua(
    id: 'after-eating',
    title: 'After eating',
    category: 'daily',
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
    transliteration:
        'Alhamdu lillahilladhi at\'amani hadha wa razaqanihi min ghayri hawlim-minni wa la quwwah.',
    meaning:
        'All praise is for Allah who fed me this and provided it for me, without any power or strength from me.',
    reference: 'Jami at-Tirmidhi, Sunan Abu Dawud',
  ),
  Dua(
    id: 'before-sleep',
    title: 'Before sleeping',
    category: 'daily',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    transliteration: 'Bismika Allahumma amutu wa ahya.',
    meaning: 'In Your name, O Allah, I die and I live.',
    reference: 'Sahih al-Bukhari 6324',
  ),
  Dua(
    id: 'waking-up',
    title: 'Upon waking up',
    category: 'daily',
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    transliteration:
        'Alhamdu lillahilladhi ahyana ba\'da ma amatana wa ilayhin-nushur.',
    meaning:
        'All praise is for Allah who gave us life after having taken it from us, and to Him is the resurrection.',
    reference: 'Sahih al-Bukhari 6324',
  ),
  Dua(
    id: 'entering-home',
    title: 'Entering the home',
    category: 'daily',
    arabic:
        'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى رَبِّنَا تَوَكَّلْنَا',
    transliteration:
        'Bismillahi walajna, wa bismillahi kharajna, wa \'ala Rabbina tawakkalna.',
    meaning:
        'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we rely.',
    reference: 'Sunan Abu Dawud',
  ),
  Dua(
    id: 'leaving-home',
    title: 'Leaving the home',
    category: 'daily',
    arabic:
        'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration:
        'Bismillahi tawakkaltu \'alallah, la hawla wa la quwwata illa billah.',
    meaning:
        'In the name of Allah, I place my trust in Allah; there is no power and no strength except with Allah.',
    reference: 'Sunan Abu Dawud, Jami at-Tirmidhi',
  ),
  Dua(
    id: 'entering-masjid',
    title: 'Entering the masjid',
    category: 'daily',
    arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
    transliteration: 'Allahumma iftah li abwaba rahmatik.',
    meaning: 'O Allah, open for me the doors of Your mercy.',
    reference: 'Sahih Muslim',
  ),
  Dua(
    id: 'leaving-masjid',
    title: 'Leaving the masjid',
    category: 'daily',
    arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
    transliteration: 'Allahumma inni as\'aluka min fadlik.',
    meaning: 'O Allah, I ask You from Your bounty.',
    reference: 'Sahih Muslim',
  ),
  Dua(
    id: 'entering-toilet',
    title: 'Entering the toilet',
    category: 'daily',
    arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
    transliteration: 'Allahumma inni a\'udhu bika minal-khubuthi wal-khaba\'ith.',
    meaning: 'O Allah, I seek refuge in You from the male and female devils.',
    reference: 'Sahih al-Bukhari, Sahih Muslim',
  ),
  Dua(
    id: 'leaving-toilet',
    title: 'Leaving the toilet',
    category: 'daily',
    arabic: 'غُفْرَانَكَ',
    transliteration: 'Ghufranak.',
    meaning: 'I seek Your forgiveness.',
    reference: 'Jami at-Tirmidhi',
  ),
  Dua(
    id: 'after-wudu',
    title: 'After wudu',
    category: 'daily',
    arabic:
        'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
    transliteration:
        'Ashhadu an la ilaha illallahu wahdahu la sharika lah, wa ashhadu anna Muhammadan \'abduhu wa rasuluh.',
    meaning:
        'I bear witness that there is no god except Allah alone, without partner, and I bear witness that Muhammad is His servant and Messenger.',
    reference: 'Sahih Muslim',
  ),
  Dua(
    id: 'for-parents',
    title: 'Dua for parents',
    category: 'daily',
    arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
    transliteration: 'Rabbir-hamhuma kama rabbayani saghira.',
    meaning:
        'My Lord, have mercy upon them as they brought me up when I was small.',
    reference: 'Quran 17:24',
  ),
  Dua(
    id: 'in-distress',
    title: 'In distress (Dua of Yunus)',
    category: 'daily',
    arabic: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
    transliteration:
        'La ilaha illa Anta, subhanaka, inni kuntu minaz-zalimin.',
    meaning:
        'There is no god except You; glory be to You. Indeed, I was among the wrongdoers.',
    reference: 'Quran 21:87',
  ),
  Dua(
    id: 'before-travel',
    title: 'Before travel',
    category: 'daily',
    arabic:
        'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
    transliteration:
        'Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila Rabbina lamunqalibun.',
    meaning:
        'Glory be to the One who has subjected this for us, and we were not capable of it. And indeed, to our Lord we will surely return.',
    reference: 'Quran 43:13–14',
  ),
  Dua(
    id: 'breaking-fast',
    title: 'When breaking the fast',
    category: 'daily',
    arabic:
        'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
    transliteration:
        'Dhahabaz-zama\'u wabtallatil-\'uruqu wa thabatal-ajru in sha\' Allah.',
    meaning:
        'The thirst is gone, the veins are moistened, and the reward is assured, if Allah wills.',
    reference: 'Sunan Abu Dawud',
  ),
  Dua(
    id: 'for-knowledge',
    title: 'Dua for knowledge',
    category: 'daily',
    arabic: 'رَبِّ زِدْنِي عِلْمًا',
    transliteration: 'Rabbi zidni \'ilma.',
    meaning: 'My Lord, increase me in knowledge.',
    reference: 'Quran 20:114',
  ),
  Dua(
    id: 'durood',
    title: 'Durood Sharif',
    category: 'daily',
    arabic:
        'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
    transliteration:
        'Allahumma salli \'ala Muhammadin wa \'ala ali Muhammadin kama sallayta \'ala Ibrahima wa \'ala ali Ibrahima, innaka Hamidum-Majid.',
    meaning:
        'O Allah, send blessings upon Muhammad and upon the family of Muhammad, as You sent blessings upon Ibrahim and the family of Ibrahim. Indeed, You are Praiseworthy, Glorious.',
    reference: 'Sahih al-Bukhari',
  ),
  Dua(
    id: 'when-sneezing',
    title: 'When sneezing',
    category: 'daily',
    arabic: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah.',
    meaning: 'All praise is for Allah.',
    reference: 'Sahih al-Bukhari',
  ),
];

List<Dua> duasByCategory(String category) =>
    duas.where((d) => d.category == category).toList();
