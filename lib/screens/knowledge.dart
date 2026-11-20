// Islamic Knowledge (v2.1): ~12 short entries written in original
// Bangla words (no copied text), bundled offline. Tap an entry to
// expand it. Deep-green header + gold accent (reference look).
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class _Entry {
  final String title;
  final String titleEn;
  final String body;
  final IconData icon;
  const _Entry({
    required this.title,
    required this.titleEn,
    required this.body,
    required this.icon,
  });
}

const List<_Entry> _entries = [
  _Entry(
    title: 'ইসলামের ৫টি স্তম্ভ',
    titleEn: 'The Five Pillars',
    icon: Icons.account_balance,
    body:
        'ইসলাম দাঁড়িয়ে আছে পাঁচটি ভিত্তির উপর — শাহাদাহ (আল্লাহ ছাড়া কোনো ইলাহ নেই এবং মুহাম্মাদ (সা.) আল্লাহর রাসূল — এই সাক্ষ্য দেওয়া), নামাজ কায়েম করা, যাকাত দেওয়া, রমজানে রোজা রাখা এবং সামর্থ্য থাকলে হজ করা। এই পাঁচটি একসাথে একজন মুসলিমের জীবনের কাঠামো তৈরি করে: বিশ্বাস, ইবাদত, দান, সংযম আর ঐক্যের সফর।',
  ),
  _Entry(
    title: 'ওজুর ধাপ',
    titleEn: 'Steps of Wudu',
    icon: Icons.water_drop,
    body:
        'প্রথমে নিয়ত করুন, তারপর বিসমিল্লাহ বলে দুই হাত কবজি পর্যন্ত তিনবার ধুয়ে নিন। এরপর তিনবার কুলি করুন ও নাকে পানি দিন, তারপর পুরো মুখ তিনবার ধুয়ে নিন। দুই হাত কনুইসহ তিনবার, মাথা একবার মাসেহ করুন এবং দুই কান মাসেহ করুন। শেষে দুই পা গোড়ালিসহ তিনবার ধুয়ে নিন। প্রতিটি ধাপে পানি যেন শরীরের প্রতিটি অংশে পৌঁছায়, সেদিকে খেয়াল রাখুন।',
  ),
  _Entry(
    title: 'কী কী ওজু ভাঙে',
    titleEn: 'What Breaks Wudu',
    icon: Icons.warning_amber,
    body:
        'ওজু ভেঙে যায় যখন শরীর থেকে প্রস্রাব, পায়খানা বা বায়ু বের হয়; যখন গভীর ঘুমে শরীরের নিয়ন্ত্রণ চলে যায়; যখন অজ্ঞান হয়ে পড়েন; এবং যখন শরীর থেকে রক্ত বা পুঁজ বেশি পরিমাণে বের হয়ে গড়িয়ে পড়ে। এছাড়া নামাজে জোরে হাসলেও (হানাফি মতে) ওজু ভেঙে যায়। এসবের যেকোনো একটি হলে নতুন করে ওজু করে নিতে হয়।',
  ),
  _Entry(
    title: 'সুন্নত নামাজ',
    titleEn: 'Sunnah Prayers',
    icon: Icons.access_time,
    body:
        'ফরজ নামাজের সাথে সাথে নবী (সা.) নিয়মিত কিছু সুন্নত নামাজ পড়তেন। ফজরের আগে ২ রাকাত, যোহরের আগে ৪ ও পরে ২ রাকাত, মাগরিবের পরে ২ রাকাত এবং এশার পরে ২ রাকাত — এগুলো সুন্নতে মুআক্কাদা। ফজরের আগের ২ রাকাত সম্পর্কে বলা হয়েছে, তা দুনিয়া ও দুনিয়ার সবকিছুর চেয়ে উত্তম। সময় পেলে এসব পড়ার চেষ্টা করুন।',
  ),
  _Entry(
    title: 'নামাজের শর্ত',
    titleEn: 'Conditions of Prayer',
    icon: Icons.checklist,
    body:
        'নামাজ শুদ্ধ হতে কয়েকটি শর্ত পূরণ করা জরুরি: শরীর, কাপড় ও নামাজের জায়গা পবিত্র থাকা; ওজু বা প্রয়োজনে গোসল করা; সতর ঢাকা থাকা; কিবলার দিকে মুখ করা; নামাজের সময় হয়ে যাওয়া এবং নিয়ত করা। কোনো শর্ত ছুটে গেলে নামাজ শুদ্ধ হয় না, তাই নামাজের আগে একবার নিজেকে যাচাই করে নেওয়া ভালো অভ্যাস।',
  ),
  _Entry(
    title: 'রোজার নিয়ম',
    titleEn: 'Rules of Fasting',
    icon: Icons.nightlight,
    body:
        'রমজানের রোজা সুবহে সাদিক থেকে সূর্যাস্ত পর্যন্ত পানাহার ও স্বামী-স্ত্রীর সম্পর্ক থেকে বিরত থাকা। রোজার নিয়ত রাতে বা সেহরির সময় করে নিতে হয়। ইচ্ছাকৃতভাবে রোজা ভাঙলে কাযা ও ক্ষেত্রবিশেষে কাফফারা দিতে হয়। অসুস্থতা, সফর বা অন্য বৈধ কারণে রোজা না রাখলে পরে কাযা করে নেওয়া যায়। রোজা শুধু ক্ষুধা নয় — জিহ্বা, চোখ ও মনকেও সংযত রাখার অনুশীলন।',
  ),
  _Entry(
    title: 'যাকাতের সংক্ষিপ্ত নিয়ম',
    titleEn: 'Zakat in Brief',
    icon: Icons.calculate,
    body:
        'যাকাত ইসলামের ফরজ ইবাদত। নগদ টাকা, সোনা-রূপা ও ব্যবসার সম্পদ মিলিয়ে যদি নিসাব (৮৭.৪৮ গ্রাম সোনা বা ৬১২.৩৬ গ্রাম রূপার মূল্য) পরিমাণ সম্পদ এক চন্দ্রবছর ধরে থাকে, তবে তার ২.৫% যাকাত দিতে হয়। ঋণ বাদ দিয়ে হিসাব করতে হয়। যাকাত দেওয়ার উপযুক্ত খাতের মধ্যে গরিব, মিসকিন, ঋণগ্রস্ত ও মুসাফির অন্যতম।',
  ),
  _Entry(
    title: 'গোসলের ফরজ',
    titleEn: 'Obligatory Bath',
    icon: Icons.shower,
    body:
        'গোসলের ফরজ তিনটি: কুলি করা, নাকে পানি দেওয়া এবং পুরো শরীরে পানি পৌঁছানো — যাতে শরীরের কোনো অংশ শুকনো না থাকে। স্বপ্নদোষ, স্ত্রী-সহবাস, মাসিক বা নিফাসের পর গোসল ফরজ হয়। গোসলের আগে নিয়ত করে নিন, তারপর শরীর ধুয়ে নেওয়ার সময় চুলের গোড়া পর্যন্ত পানি পৌঁছেছে কি না, তা নিশ্চিত করুন।',
  ),
  _Entry(
    title: 'তায়াম্মুম',
    titleEn: 'Tayammum',
    icon: Icons.handshake,
    body:
        'পানি না পাওয়া গেলে বা পানি ব্যবহারে অসুস্থতার আশঙ্কা থাকলে মাটি দিয়ে তায়াম্মুম করা যায়। নিয়ত করে পবিত্র মাটিতে দুই হাত মেরে মুখ মাসেহ করুন, আবার হাত মেরে দুই হাত কনুই পর্যন্ত মাসেহ করুন। পানি পেয়ে গেলে তায়াম্মুম ভেঙে যায় এবং ওজু করে নিতে হয়। সফরে বা অসুস্থতায় এটি আল্লাহর পক্ষ থেকে সহজ ব্যবস্থা।',
  ),
  _Entry(
    title: 'দৈনিক সুন্নত আমল',
    titleEn: 'Daily Sunnah Habits',
    icon: Icons.wb_sunny,
    body:
        'ছোট ছোট সুন্নত আমল দিনটিকে বরকতময় করে তোলে: ঘুম থেকে উঠে দুয়া পড়া, মিসওয়াক করা, ডান হাতে খাওয়া, খাবারের আগে বিসমিল্লাহ ও পরে আলহামদুলিল্লাহ বলা, ঘরে ঢুকতে ও বের হতে সালাম ও দুয়া পড়া, রাতে ঘুমের আগে আয়াতুল কুরসি ও সূরা ইখলাস-ফালাক-নাস পড়া। এগুলো সহজ, কিন্তু নিয়মিত করলে জীবনে এর প্রভাব টের পাওয়া যায়।',
  ),
  _Entry(
    title: 'কুরআন তিলাওয়াতের আদব',
    titleEn: 'Etiquette of Recitation',
    icon: Icons.menu_book,
    body:
        'কুরআন তিলাওয়াতের আগে ওজু করে নেওয়া, কিবলার দিকে বসা ও ধীরে ধীরে তাজবিদসহ পড়া উত্তম। আয়াতের অর্থ নিয়ে ভাবুন — শুধু পড়ে যাওয়া নয়, বুঝে পড়াই আসল উদ্দেশ্য। তিলাওয়াতের সময় কথা বলা বা মনোযোগ ছিন্ন করা এড়িয়ে চলুন। প্রতিদিন অল্প হলেও নিয়মিত পড়ার অভ্যাস গড়ে তুলুন; এক পৃষ্ঠা প্রতিদিনও এক বছরে বড় অর্জন হয়ে যায়।',
  ),
  _Entry(
    title: 'দুয়া কবুলের সময়',
    titleEn: 'Times When Dua Is Accepted',
    icon: Icons.favorite,
    body:
        'কিছু বিশেষ সময়ে দুয়া কবুলের সম্ভাবনা বেশি বলে হাদিসে এসেছে: রাতের শেষ তৃতীয়াংশে (তাহাজ্জুদের সময়), ফরজ নামাজের পরে, আযান ও ইকামতের মাঝখানে, জুমার দিনের শেষ সময়ে, রোজাদারের ইফতারের মুহূর্তে, বৃষ্টির সময় এবং সিজদায়। এসব সময়ে মন থেকে, আন্তরিকভাবে দুয়া করুন — আল্লাহ বান্দার ডাকে সাড়া দেন।',
  ),
];

class IslamicKnowledgeScreen extends StatelessWidget {
  const IslamicKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    return AppScaffold(
      appBar: AppBar(
          title: Text(bn ? 'ইসলামিক জ্ঞান' : 'Islamic Knowledge')),
      body: ListView.builder(
        itemCount: _entries.length + 1,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  color: primaryGreenDark,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.school,
                            color: Color(0xFFFFD54F), size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bn ? 'ইসলামিক জ্ঞান' : 'Islamic Knowledge',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bn
                                  ? 'দৈনন্দিন ইসলামি জীবনের সংক্ষিপ্ত নির্দেশনা'
                                  : 'Short guides for everyday Islamic life',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final e = _entries[i - 1];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(e.icon, color: primaryGreen),
                ),
                title: Text(
                  bn ? e.title : e.titleEn,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      e.body,
                      style: const TextStyle(fontSize: 15, height: 1.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
