// Prophet Stories (v2.1): brief summaries of major prophets in
// original Bangla words (no copied text), bundled offline. Each story
// is a few lines plus a moral/lesson. Tap a prophet to expand.
// Deep-green header + gold accent (reference look).
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class _Story {
  final String name;
  final String nameEn;
  final String title;
  final String body;
  final String lesson;
  final IconData icon;
  const _Story({
    required this.name,
    required this.nameEn,
    required this.title,
    required this.body,
    required this.lesson,
    required this.icon,
  });
}

const List<_Story> _stories = [
  _Story(
    name: 'আদম (আ.)',
    nameEn: 'Adam (AS)',
    title: 'প্রথম মানুষ, প্রথম নবী',
    icon: Icons.person,
    body:
        'আল্লাহ আদম (আ.)-কে মাটি দিয়ে সৃষ্টি করেন এবং তাঁকে প্রথম মানুষ ও প্রথম নবী হিসেবে পৃথিবীতে পাঠান। শয়তানের প্ররোচনায় তিনি নিষিদ্ধ গাছের ফল খেয়ে ফেলেন, কিন্তু সাথে সাথে তওবা করেন — আর আল্লাহ তাঁর তওবা কবুল করেন। তাঁর জীবন আমাদের শেখায়, ভুল করা মানুষের স্বভাব, কিন্তু তওবা করাই মুমিনের পরিচয়।',
    lesson: 'শিক্ষা: ভুল হলে তওবা করতে দেরি করো না — আল্লাহ ক্ষমাশীল।',
  ),
  _Story(
    name: 'নূহ (আ.)',
    nameEn: 'Nuh (AS)',
    title: 'ধৈর্যের নবী',
    icon: Icons.sailing,
    body:
        'নূহ (আ.) সাড়ে নয়শো বছর ধরে তাঁর জাতিকে আল্লাহর দিকে ডাকেন, কিন্তু অল্প কয়েকজন ছাড়া কেউ সাড়া দেয়নি। শেষ পর্যন্ত আল্লাহর নির্দেশে তিনি নৌকা বানান, আর মহাপ্লাবনে অবিশ্বাসীরা ডুবে যায়। তাঁর নিজের ছেলেও তাঁর কথা শোনেনি — তবু তিনি আল্লাহর হুকুমেই অটল ছিলেন।',
    lesson: 'শিক্ষা: সত্যের পথে ধৈর্য ধরো — ফলাফল আল্লাহর হাতে।',
  ),
  _Story(
    name: 'ইবরাহিম (আ.)',
    nameEn: 'Ibrahim (AS)',
    title: 'খলিলুল্লাহ — আল্লাহর বন্ধু',
    icon: Icons.local_fire_department,
    body:
        'ইবরাহিম (আ.) মূর্তিপূজার বিরুদ্ধে দাঁড়ান এবং আগুনে নিক্ষিপ্ত হন — কিন্তু আল্লাহ আগুনকে তাঁর জন্য ঠান্ডা ও শান্ত করে দেন। আল্লাহর নির্দেশে তিনি পুত্র ইসমাইল (আ.)-কে কুরবানি দিতে প্রস্তুত হন, আর আল্লাহ তার বদলে দুম্বা পাঠান। তিনি ও ইসমাইল (আ.) মিলে কাবা ঘর নির্মাণ করেন।',
    lesson: 'শিক্ষা: আল্লাহর উপর পূর্ণ ভরসা রাখলে অসম্ভবও সম্ভব হয়।',
  ),
  _Story(
    name: 'মূসা (আ.)',
    nameEn: 'Musa (AS)',
    title: 'ফেরাউনের বিরুদ্ধে দাঁড়ানো নবী',
    icon: Icons.waves,
    body:
        'মূসা (আ.) ফেরাউনের অত্যাচারের মুখে বনি ইসরাইলকে মুক্ত করতে আল্লাহর নির্দেশ পান। তাঁর লাঠি সাপে পরিণত হয়, আর লোহিত সাগর ভাগ হয়ে তাঁর জাতিকে পথ করে দেয় — ফেরাউন সেই সাগরেই ডুবে মরে। তুর পাহাড়ে তিনি আল্লাহর সাথে কথা বলেন এবং তাওরাত লাভ করেন।',
    lesson: 'শিক্ষা: জালিম যত শক্তিশালীই হোক, সত্যের জয় অবশ্যম্ভাবী।',
  ),
  _Story(
    name: 'ইউসুফ (আ.)',
    nameEn: 'Yusuf (AS)',
    title: 'স্বপ্ন থেকে সিংহাসন',
    icon: Icons.star,
    body:
        'ছোটবেলায় ভাইদের হিংসায় কুয়ায় ফেলে দেওয়া হয় ইউসুফ (আ.)-কে, তারপর তাঁকে দাস হিসেবে বিক্রি করা হয়। মিশরে মিথ্যা অপবাদে তিনি জেলে যান, কিন্তু স্বপ্নের ব্যাখ্যার জ্ঞান তাঁকে মিশরের খাদ্যমন্ত্রী বানায়। শেষে ভাইয়েরা তাঁর কাছে ক্ষমা চাইলে তিনি উদারভাবে ক্ষমা করে দেন।',
    lesson: 'শিক্ষা: ক্ষমা করাই বড় মনের পরিচয় — প্রতিশোধ নয়।',
  ),
  _Story(
    name: 'আইয়ুব (আ.)',
    nameEn: 'Ayyub (AS)',
    title: 'সবরের প্রতীক',
    icon: Icons.favorite,
    body:
        'আইয়ুব (আ.) ছিলেন ধনী ও সুখী মানুষ। আল্লাহর পরীক্ষায় তিনি একে একে সম্পদ, সন্তান ও সুস্থতা হারান — দীর্ঘ বছর কঠিন রোগে ভোগেন। তবু তিনি একবারও অভিযোগ করেননি, শুধু ধৈর্য ধরেন। শেষে আল্লাহ তাঁকে সুস্থতা ও আগের চেয়ে বেশি নিয়ামত ফিরিয়ে দেন।',
    lesson: 'শিক্ষা: কষ্টের সময় ধৈর্যই সবচেয়ে বড় ইবাদত।',
  ),
  _Story(
    name: 'সুলায়মান (আ.)',
    nameEn: 'Sulayman (AS)',
    title: 'জ্ঞান ও রাজত্বের নবী',
    icon: Icons.account_balance,
    body:
        'দাউদ (আ.)-এর পুত্র সুলায়মান (আ.) আল্লাহর কাছে ধন নয়, জ্ঞান ও প্রজ্ঞা চেয়েছিলেন — আর আল্লাহ তাঁকে জ্ঞানের সাথে বিশাল রাজত্বও দান করেন। তিনি পশু-পাখির ভাষা বুঝতেন, বাতাস ও জিন তাঁর অধীনে ছিল। বিলকিস রানির সাথে তাঁর ঘটনা কুরআনে বিস্তারিত এসেছে। এত ক্ষমতা পেয়েও তিনি বিনয়ী ছিলেন।',
    lesson: 'শিক্ষা: জ্ঞান চাও — সম্পদ তার পেছনে আসে; আর ক্ষমতা পেলে বিনয়ী থাকো।',
  ),
  _Story(
    name: 'ঈসা (আ.)',
    nameEn: 'Isa (AS)',
    title: 'অলৌকিক জন্মের নবী',
    icon: Icons.child_care,
    body:
        'মারইয়াম (আ.)-এর গর্ভে পিতা ছাড়াই জন্ম নেন ঈসা (আ.) — আল্লাহর কুদরতের নিদর্শন। দোলনায় থাকতেই তিনি কথা বলেন। আল্লাহর হুকুমে তিনি অন্ধকে দৃষ্টি দিতেন, কুষ্ঠরোগীকে সুস্থ করতেন এবং মৃতকে জীবিত করতেন। তাঁর উপর নাজিল হয় ইনজিল কিতাব। তিনি মানুষকে এক আল্লাহর ইবাদতের দিকে ডাকেন।',
    lesson: 'শিক্ষা: আল্লাহর কুদরতে কোনো কিছুই অসম্ভব নয়।',
  ),
  _Story(
    name: 'মুহাম্মাদ (সা.)',
    nameEn: 'Muhammad (SAW)',
    title: 'সর্বশেষ নবী, রহমতের নবী',
    icon: Icons.nightlight_round,
    body:
        'মুহাম্মাদ (সা.) ৫৭০ খ্রিস্টাব্দে মক্কায় জন্ম নেন। চল্লিশ বছর বয়সে হেরা গুহায় তাঁর উপর প্রথম ওহি নাজিল হয় — 'ইকরা'। তেইশ বছর ধরে কুরআন নাজিল হয়, আর তিনি মক্কা ও মদিনায় ইসলামের দাওয়াত দেন। তাঁর চরিত্র ছিল কুরআনের জীবন্ত রূপ: সত্যবাদী, আমানতদার, ক্ষমাশীল ও দয়ালু। তাঁর মাধ্যমেই নবুয়তের ধারা শেষ হয়।',
    lesson: 'শিক্ষা: উত্তম চরিত্রই সবচেয়ে বড় দাওয়াত — তাঁর সুন্নত অনুসরণ করো।',
  ),
];

class ProphetStoriesScreen extends StatelessWidget {
  const ProphetStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    return AppScaffold(
      appBar: AppBar(
          title: Text(bn ? 'নবীদের গল্প' : 'Stories of the Prophets')),
      body: ListView.builder(
        itemCount: _stories.length + 1,
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
                        child: const Icon(Icons.auto_stories,
                            color: Color(0xFFFFD54F), size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bn ? 'নবীদের গল্প' : 'Stories of the Prophets',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bn
                                  ? 'নবীদের জীবন থেকে শিক্ষা নিন'
                                  : 'Lessons from the lives of the prophets',
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
          final s = _stories[i - 1];
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
                  child: Icon(s.icon, color: primaryGreen),
                ),
                title: Text(
                  bn ? s.name : s.nameEn,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(s.title),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.body,
                          style: const TextStyle(fontSize: 15, height: 1.7),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: primaryGreen.withOpacity(0.25)),
                          ),
                          child: Text(
                            s.lesson,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: primaryGreen,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
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
