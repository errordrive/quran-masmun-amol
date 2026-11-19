// Bundled duas (morning & evening adhkar + daily masnun duas).
// Only duas the author is confident about are included; references give the
// source collection, with a hadith number only where it is well established.
import '../models/models.dart';

const List<Dua> duas = [
  // ---------- Morning & Evening Adhkar ----------
  Dua(
    id: 'ayat-kursi',
    title: 'Ayat al-Kursi',
    banglaTitle: 'আয়াতুল কুরসি',
    category: 'morning',
    arabic:
        'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
    transliteration:
        'Allahu la ilaha illa Huwal-Hayyul-Qayyum, la ta\'khudhuhu sinatun wa la nawm, lahu ma fis-samawati wa ma fil-ard, man dhalladhi yashfa\'u \'indahu illa bi-idhnih, ya\'lamu ma bayna aydihim wa ma khalfahum, wa la yuhituna bi shay\'im-min \'ilmihi illa bima sha\', wasi\'a kursiyyuhus-samawati wal-ard, wa la ya\'uduhu hifzuhuma, wa Huwal-\'Aliyyul-\'Azim.',
    meaning:
        'Allah — there is no god except Him, the Ever-Living, the Sustainer of all. Neither drowsiness nor sleep overtakes Him. To Him belongs whatever is in the heavens and whatever is on the earth. Who can intercede with Him except by His permission? He knows what is before them and what is behind them, and they encompass nothing of His knowledge except what He wills. His Kursi extends over the heavens and the earth, and their preservation does not tire Him. And He is the Most High, the Most Great.',
    banglaMeaning: 'আল্লাহ — তিনি ছাড়া কোনো উপাস্য নেই, তিনি চিরঞ্জীব, সবকিছুর ধারক ও পরিচালক। তাঁকে তন্দ্রাও স্পর্শ করে না, ঘুমও না। আকাশমণ্ডলী ও পৃথিবীতে যা কিছু আছে সবই তাঁর। তাঁর অনুমতি ছাড়া কে তাঁর কাছে সুপারিশ করতে পারে? তিনি জানেন যা তাদের সামনে আছে এবং যা তাদের পেছনে আছে, আর তারা তাঁর জ্ঞানের কিছুই আয়ত্ত করতে পারে না, তিনি যা চান তা ছাড়া। তাঁর কুরসি আকাশমণ্ডলী ও পৃথিবীকে পরিব্যাপ্ত করে আছে, আর এ দুটির রক্ষণাবেক্ষণ তাঁকে ক্লান্ত করে না। আর তিনি সর্বোচ্চ, মহান।',
    reference: 'Quran 2:255 — recite morning and evening',
  ),
  Dua(
    id: 'surah-ikhlas',
    title: 'Surah Al-Ikhlas (3 times)',
    banglaTitle: 'সূরা আল-ইখলাস (৩ বার)',
    category: 'morning',
    arabic:
        'قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾ اللَّهُ الصَّمَدُ ﴿٢﴾ لَمْ يَلِدْ وَلَمْ يُولَدْ ﴿٣﴾ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ ﴿٤﴾',
    transliteration:
        'Qul Huwallahu Ahad. Allahus-Samad. Lam yalid wa lam yulad. Wa lam yakun lahu kufuwan Ahad.',
    meaning:
        'Say: He is Allah, the One. Allah, the Eternal Refuge. He neither begets nor is born, and there is none comparable to Him.',
    banglaMeaning: 'বলুন: তিনিই আল্লাহ, এক। আল্লাহ, চিরন্তন আশ্রয়স্থল। তিনি কাউকে জন্ম দেননি এবং তাঁকেও জন্ম দেওয়া হয়নি, আর তাঁর সমতুল্য কেউ নেই।',
    reference: 'Quran 112 — recite 3 times morning and evening',
  ),
  Dua(
    id: 'surah-falaq',
    title: 'Surah Al-Falaq (3 times)',
    banglaTitle: 'সূরা আল-ফালাক (৩ বার)',
    category: 'morning',
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ﴿١﴾ مِنْ شَرِّ مَا خَلَقَ ﴿٢﴾ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ﴿٣﴾ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ﴿٤﴾ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ ﴿٥﴾',
    transliteration:
        'Qul a\'udhu bi Rabbil-falaq. Min sharri ma khalaq. Wa min sharri ghasiqin idha waqab. Wa min sharrin-naffathati fil-\'uqad. Wa min sharri hasidin idha hasad.',
    meaning:
        'Say: I seek refuge in the Lord of daybreak, from the evil of what He created, from the evil of darkness when it settles, from the evil of those who blow on knots, and from the evil of the envier when he envies.',
    banglaMeaning: 'বলুন: আমি ভোরের প্রতিপালকের আশ্রয় চাই, তিনি যা সৃষ্টি করেছেন তার অনিষ্ট থেকে, অন্ধকারের অনিষ্ট থেকে যখন তা নেমে আসে, গিঁটে ফুঁ দেওয়া নারীদের অনিষ্ট থেকে, এবং হিংসুকের অনিষ্ট থেকে যখন সে হিংসা করে।',
    reference: 'Quran 113 — recite 3 times morning and evening',
  ),
  Dua(
    id: 'surah-nas',
    title: 'Surah An-Nas (3 times)',
    banglaTitle: 'সূরা আন-নাস (৩ বার)',
    category: 'morning',
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ﴿١﴾ مَلِكِ النَّاسِ ﴿٢﴾ إِلَٰهِ النَّاسِ ﴿٣﴾ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ﴿٤﴾ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ﴿٥﴾ مِنَ الْجِنَّةِ وَالنَّاسِ ﴿٦﴾',
    transliteration:
        'Qul a\'udhu bi Rabbin-nas. Malikin-nas. Ilahin-nas. Min sharril-waswasil-khannas. Alladhi yuwaswisu fi sudurin-nas. Minal-jinnati wan-nas.',
    meaning:
        'Say: I seek refuge in the Lord of mankind, the King of mankind, the God of mankind, from the evil of the retreating whisperer who whispers in the breasts of mankind, from among the jinn and mankind.',
    banglaMeaning: 'বলুন: আমি মানবজাতির প্রতিপালকের আশ্রয় চাই, মানবজাতির অধিপতির, মানবজাতির উপাস্যের আশ্রয় চাই, পশ্চাৎপসরণকারী কুমন্ত্রণাদানকারীর অনিষ্ট থেকে, যে মানুষের বুকে কুমন্ত্রণা দেয়, জিন ও মানুষের মধ্য থেকে।',
    reference: 'Quran 114 — recite 3 times morning and evening',
  ),
  Dua(
    id: 'bismillah-protection',
    title: 'Protection from all harm (3 times)',
    banglaTitle: 'সব ক্ষতি থেকে সুরক্ষা (৩ বার)',
    category: 'morning',
    arabic:
        'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
    transliteration:
        'Bismillahilladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\'i wa Huwas-Sami\'ul-\'Alim.',
    meaning:
        'In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, the All-Knowing.',
    banglaMeaning: 'আল্লাহর নামে, যাঁর নামের সঙ্গে পৃথিবীতে বা আকাশে কোনো কিছুই ক্ষতি করতে পারে না, আর তিনি সর্বশ্রোতা, সর্বজ্ঞ।',
    reference: 'Sunan Abu Dawud, Jami at-Tirmidhi — recite 3 times morning and evening',
  ),
  Dua(
    id: 'morning-asbahna',
    title: 'Morning remembrance',
    banglaTitle: 'সকালের জিকির',
    category: 'morning',
    arabic:
        'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
    transliteration:
        'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur.',
    meaning:
        'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.',
    banglaMeaning: 'হে আল্লাহ, আপনারই মাধ্যমে আমরা সকালে প্রবেশ করি এবং আপনারই মাধ্যমে আমরা সন্ধ্যায় প্রবেশ করি, আপনারই মাধ্যমে আমরা বাঁচি এবং আপনারই মাধ্যমে আমরা মরি, আর আপনারই দিকে পুনরুত্থান।',
    reference: 'Jami at-Tirmidhi, Sunan Abu Dawud — morning',
  ),
  Dua(
    id: 'evening-amsayna',
    title: 'Evening remembrance',
    banglaTitle: 'সন্ধ্যার জিকির',
    category: 'morning',
    arabic:
        'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ',
    transliteration:
        'Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namutu, wa ilaykal-masir.',
    meaning:
        'O Allah, by You we enter the evening and by You we enter the morning, by You we live and by You we die, and to You is the return.',
    banglaMeaning: 'হে আল্লাহ, আপনারই মাধ্যমে আমরা সন্ধ্যায় প্রবেশ করি এবং আপনারই মাধ্যমে আমরা সকালে প্রবেশ করি, আপনারই মাধ্যমে আমরা বাঁচি এবং আপনারই মাধ্যমে আমরা মরি, আর আপনারই দিকে প্রত্যাবর্তন।',
    reference: 'Jami at-Tirmidhi, Sunan Abu Dawud — evening',
  ),
  Dua(
    id: 'sayyidul-istighfar',
    title: 'Sayyidul Istighfar (best seeking of forgiveness)',
    banglaTitle: 'সাইয়্যিদুল ইস্তিগফার (শ্রেষ্ঠ ক্ষমা প্রার্থনা)',
    category: 'morning',
    arabic:
        'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    transliteration:
        'Allahumma Anta Rabbi, la ilaha illa Anta, khalaqtani wa ana \'abduk, wa ana \'ala \'ahdika wa wa\'dika mastata\'t, a\'udhu bika min sharri ma sana\'t, abu\'u laka bi ni\'matika \'alayya, wa abu\'u bi dhanbi, faghfir li, fa innahu la yaghfirudh-dhunuba illa Anta.',
    meaning:
        'O Allah, You are my Lord, there is no god except You. You created me and I am Your servant, and I am upon Your covenant and promise as much as I am able. I seek refuge in You from the evil of what I have done. I acknowledge Your favour upon me, and I acknowledge my sin, so forgive me, for none forgives sins except You.',
    banglaMeaning: 'হে আল্লাহ, আপনিই আমার প্রতিপালক, আপনি ছাড়া কোনো উপাস্য নেই। আপনিই আমাকে সৃষ্টি করেছেন এবং আমি আপনার বান্দা, আর আমি আমার সাধ্যমতো আপনার অঙ্গীকার ও প্রতিশ্রুতির ওপর অটল আছি। আমি যা করেছি তার অনিষ্ট থেকে আপনার আশ্রয় চাই। আমার প্রতি আপনার অনুগ্রহ আমি স্বীকার করছি, আর আমার গুনাহও স্বীকার করছি, তাই আমাকে ক্ষমা করুন, কেননা আপনি ছাড়া আর কেউ গুনাহ ক্ষমা করতে পারে না।',
    reference: 'Sahih al-Bukhari 6306 — morning and evening',
  ),
  Dua(
    id: 'afwa-afiyah',
    title: 'Asking for pardon and well-being',
    banglaTitle: 'ক্ষমা ও সুস্থতা প্রার্থনা',
    category: 'morning',
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
    transliteration:
        'Allahumma inni as\'alukal-\'afwa wal-\'afiyata fid-dunya wal-akhirah.',
    meaning:
        'O Allah, I ask You for pardon and well-being in this world and the Hereafter.',
    banglaMeaning: 'হে আল্লাহ, আমি আপনার কাছে এই দুনিয়া ও আখিরাতে ক্ষমা ও সুস্থতা প্রার্থনা করছি।',
    reference: 'Sunan Abu Dawud — morning and evening',
  ),
  Dua(
    id: 'hasbiyallah',
    title: 'Allah is sufficient for me (7 times)',
    banglaTitle: 'আল্লাহই আমার জন্য যথেষ্ট (৭ বার)',
    category: 'morning',
    arabic:
        'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ ۖ عَلَيْهِ تَوَكَّلْتُ ۖ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
    transliteration:
        'Hasbiyallahu la ilaha illa Huwa, \'alayhi tawakkaltu, wa Huwa Rabbul-\'Arshil-\'Azim.',
    meaning:
        'Allah is sufficient for me; there is no god except Him. In Him I put my trust, and He is the Lord of the Mighty Throne.',
    banglaMeaning: 'আল্লাহই আমার জন্য যথেষ্ট; তিনি ছাড়া কোনো উপাস্য নেই। আমি তাঁরই ওপর ভরসা করি, আর তিনিই মহান আরশের প্রতিপালক।',
    reference: 'Quran 9:129 — recite 7 times morning and evening',
  ),
  // ---------- Daily / Masnun duas ----------
  Dua(
    id: 'before-eating',
    title: 'Before eating',
    banglaTitle: 'খাওয়ার আগে',
    category: 'daily',
    arabic: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    transliteration: 'Bismillahi wa \'ala barakatillah.',
    meaning: 'In the name of Allah, and with the blessing of Allah.',
    banglaMeaning: 'আল্লাহর নামে, এবং আল্লাহর বরকতের সঙ্গে।',
    reference: 'Sunan Abu Dawud, Jami at-Tirmidhi',
  ),
  Dua(
    id: 'after-eating',
    title: 'After eating',
    banglaTitle: 'খাওয়ার পরে',
    category: 'daily',
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
    transliteration:
        'Alhamdu lillahilladhi at\'amani hadha wa razaqanihi min ghayri hawlim-minni wa la quwwah.',
    meaning:
        'All praise is for Allah who fed me this and provided it for me, without any power or strength from me.',
    banglaMeaning: 'সমস্ত প্রশংসা আল্লাহর, যিনি আমাকে এ খাবার খাইয়েছেন এবং আমার কোনো শক্তি বা সামর্থ্য ছাড়াই তা আমাকে রিজিক হিসেবে দিয়েছেন।',
    reference: 'Jami at-Tirmidhi, Sunan Abu Dawud',
  ),
  Dua(
    id: 'before-sleep',
    title: 'Before sleeping',
    banglaTitle: 'ঘুমানোর আগে',
    category: 'daily',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    transliteration: 'Bismika Allahumma amutu wa ahya.',
    meaning: 'In Your name, O Allah, I die and I live.',
    banglaMeaning: 'আপনার নামে, হে আল্লাহ, আমি মরি এবং বাঁচি।',
    reference: 'Sahih al-Bukhari 6324',
  ),
  Dua(
    id: 'waking-up',
    title: 'Upon waking up',
    banglaTitle: 'ঘুম থেকে জেগে',
    category: 'daily',
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    transliteration:
        'Alhamdu lillahilladhi ahyana ba\'da ma amatana wa ilayhin-nushur.',
    meaning:
        'All praise is for Allah who gave us life after having taken it from us, and to Him is the resurrection.',
    banglaMeaning: 'সমস্ত প্রশংসা আল্লাহর, যিনি আমাদের মৃত্যুর পর আবার জীবন দিয়েছেন, আর তাঁরই দিকে পুনরুত্থান।',
    reference: 'Sahih al-Bukhari 6324',
  ),
  Dua(
    id: 'entering-home',
    title: 'Entering the home',
    banglaTitle: 'ঘরে প্রবেশের সময়',
    category: 'daily',
    arabic:
        'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى رَبِّنَا تَوَكَّلْنَا',
    transliteration:
        'Bismillahi walajna, wa bismillahi kharajna, wa \'ala Rabbina tawakkalna.',
    meaning:
        'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we rely.',
    banglaMeaning: 'আল্লাহর নামে আমরা প্রবেশ করি, আল্লাহর নামে আমরা বের হই, আর আমরা আমাদের প্রতিপালকের ওপরই ভরসা করি।',
    reference: 'Sunan Abu Dawud',
  ),
  Dua(
    id: 'leaving-home',
    title: 'Leaving the home',
    banglaTitle: 'ঘর থেকে বের হওয়ার সময়',
    category: 'daily',
    arabic:
        'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration:
        'Bismillahi tawakkaltu \'alallah, la hawla wa la quwwata illa billah.',
    meaning:
        'In the name of Allah, I place my trust in Allah; there is no power and no strength except with Allah.',
    banglaMeaning: 'আল্লাহর নামে, আমি আল্লাহর ওপর ভরসা করলাম; আল্লাহ ছাড়া কোনো শক্তি ও সামর্থ্য নেই।',
    reference: 'Sunan Abu Dawud, Jami at-Tirmidhi',
  ),
  Dua(
    id: 'entering-masjid',
    title: 'Entering the masjid',
    banglaTitle: 'মসজিদে প্রবেশের সময়',
    category: 'daily',
    arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
    transliteration: 'Allahumma iftah li abwaba rahmatik.',
    meaning: 'O Allah, open for me the doors of Your mercy.',
    banglaMeaning: 'হে আল্লাহ, আমার জন্য আপনার রহমতের দরজাগুলো খুলে দিন।',
    reference: 'Sahih Muslim',
  ),
  Dua(
    id: 'leaving-masjid',
    title: 'Leaving the masjid',
    banglaTitle: 'মসজিদ থেকে বের হওয়ার সময়',
    category: 'daily',
    arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
    transliteration: 'Allahumma inni as\'aluka min fadlik.',
    meaning: 'O Allah, I ask You from Your bounty.',
    banglaMeaning: 'হে আল্লাহ, আমি আপনার অনুগ্রহ থেকে প্রার্থনা করছি।',
    reference: 'Sahih Muslim',
  ),
  Dua(
    id: 'entering-toilet',
    title: 'Entering the toilet',
    banglaTitle: 'টয়লেটে প্রবেশের সময়',
    category: 'daily',
    arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
    transliteration: 'Allahumma inni a\'udhu bika minal-khubuthi wal-khaba\'ith.',
    meaning: 'O Allah, I seek refuge in You from the male and female devils.',
    banglaMeaning: 'হে আল্লাহ, আমি আপনার আশ্রয় চাই পুরুষ ও নারী শয়তানদের থেকে।',
    reference: 'Sahih al-Bukhari, Sahih Muslim',
  ),
  Dua(
    id: 'leaving-toilet',
    title: 'Leaving the toilet',
    banglaTitle: 'টয়লেট থেকে বের হওয়ার সময়',
    category: 'daily',
    arabic: 'غُفْرَانَكَ',
    transliteration: 'Ghufranak.',
    meaning: 'I seek Your forgiveness.',
    banglaMeaning: 'আমি আপনার ক্ষমা প্রার্থনা করছি।',
    reference: 'Jami at-Tirmidhi',
  ),
  Dua(
    id: 'after-wudu',
    title: 'After wudu',
    banglaTitle: 'ওজুর পরে',
    category: 'daily',
    arabic:
        'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
    transliteration:
        'Ashhadu an la ilaha illallahu wahdahu la sharika lah, wa ashhadu anna Muhammadan \'abduhu wa rasuluh.',
    meaning:
        'I bear witness that there is no god except Allah alone, without partner, and I bear witness that Muhammad is His servant and Messenger.',
    banglaMeaning: 'আমি সাক্ষ্য দিচ্ছি যে আল্লাহ ছাড়া কোনো উপাস্য নেই, তিনি একক, তাঁর কোনো শরিক নেই, আর আমি সাক্ষ্য দিচ্ছি যে মুহাম্মদ তাঁর বান্দা ও রাসূল।',
    reference: 'Sahih Muslim',
  ),
  Dua(
    id: 'for-parents',
    title: 'Dua for parents',
    banglaTitle: 'পিতা-মাতার জন্য দুআ',
    category: 'daily',
    arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
    transliteration: 'Rabbir-hamhuma kama rabbayani saghira.',
    meaning:
        'My Lord, have mercy upon them as they brought me up when I was small.',
    banglaMeaning: 'হে আমার প্রতিপালক, তাঁদের প্রতি দয়া করুন, যেভাবে তাঁরা আমাকে ছোটবেলায় লালন-পালন করেছেন।',
    reference: 'Quran 17:24',
  ),
  Dua(
    id: 'in-distress',
    title: 'In distress (Dua of Yunus)',
    banglaTitle: 'বিপদে (ইউনুসের দুআ)',
    category: 'daily',
    arabic: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
    transliteration:
        'La ilaha illa Anta, subhanaka, inni kuntu minaz-zalimin.',
    meaning:
        'There is no god except You; glory be to You. Indeed, I was among the wrongdoers.',
    banglaMeaning: 'আপনি ছাড়া কোনো উপাস্য নেই; আপনি পবিত্র। নিশ্চয়ই আমি জালিমদের অন্তর্ভুক্ত ছিলাম।',
    reference: 'Quran 21:87',
  ),
  Dua(
    id: 'before-travel',
    title: 'Before travel',
    banglaTitle: 'ভ্রমণের আগে',
    category: 'daily',
    arabic:
        'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
    transliteration:
        'Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila Rabbina lamunqalibun.',
    meaning:
        'Glory be to the One who has subjected this for us, and we were not capable of it. And indeed, to our Lord we will surely return.',
    banglaMeaning: 'পবিত্র সেই সত্তা, যিনি এটিকে আমাদের অধীন করে দিয়েছেন, অথচ আমরা এর ওপর ক্ষমতাবান ছিলাম না। আর নিশ্চয়ই আমরা আমাদের প্রতিপালকের দিকেই ফিরে যাব।',
    reference: 'Quran 43:13–14',
  ),
  Dua(
    id: 'breaking-fast',
    title: 'When breaking the fast',
    banglaTitle: 'ইফতারের সময়',
    category: 'daily',
    arabic:
        'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ',
    transliteration:
        'Dhahabaz-zama\'u wabtallatil-\'uruqu wa thabatal-ajru in sha\' Allah.',
    meaning:
        'The thirst is gone, the veins are moistened, and the reward is assured, if Allah wills.',
    banglaMeaning: 'তৃষ্ণা দূর হয়েছে, শিরাগুলো সিক্ত হয়েছে, আর সওয়াব নিশ্চিত হয়েছে, যদি আল্লাহ চান।',
    reference: 'Sunan Abu Dawud',
  ),
  Dua(
    id: 'for-knowledge',
    title: 'Dua for knowledge',
    banglaTitle: 'জ্ঞানের জন্য দুআ',
    category: 'daily',
    arabic: 'رَبِّ زِدْنِي عِلْمًا',
    transliteration: 'Rabbi zidni \'ilma.',
    meaning: 'My Lord, increase me in knowledge.',
    banglaMeaning: 'হে আমার প্রতিপালক, আমার জ্ঞান বাড়িয়ে দিন।',
    reference: 'Quran 20:114',
  ),
  Dua(
    id: 'durood',
    title: 'Durood Sharif',
    banglaTitle: 'দরুদ শরিফ',
    category: 'daily',
    arabic:
        'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
    transliteration:
        'Allahumma salli \'ala Muhammadin wa \'ala ali Muhammadin kama sallayta \'ala Ibrahima wa \'ala ali Ibrahima, innaka Hamidum-Majid.',
    meaning:
        'O Allah, send blessings upon Muhammad and upon the family of Muhammad, as You sent blessings upon Ibrahim and the family of Ibrahim. Indeed, You are Praiseworthy, Glorious.',
    banglaMeaning: 'হে আল্লাহ, মুহাম্মদ ও মুহাম্মদের পরিবারের ওপর রহমত বর্ষণ করুন, যেমন আপনি ইবরাহিম ও ইবরাহিমের পরিবারের ওপর রহমত বর্ষণ করেছেন। নিশ্চয়ই আপনি প্রশংসনীয়, মহিমান্বিত।',
    reference: 'Sahih al-Bukhari',
  ),
  Dua(
    id: 'when-sneezing',
    title: 'When sneezing',
    banglaTitle: 'হাঁচি দিলে',
    category: 'daily',
    arabic: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah.',
    meaning: 'All praise is for Allah.',
    banglaMeaning: 'সমস্ত প্রশংসা আল্লাহর।',
    reference: 'Sahih al-Bukhari',
  ),
];

List<Dua> duasByCategory(String category) =>
    duas.where((d) => d.category == category).toList();
