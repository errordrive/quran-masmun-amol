# Quran & Masnun Amol

A clean, minimal Islamic companion app for Android (Flutter, Material 3):
prayer times, the full Quran, Hadith, daily duas, masnun amol, Asmaul Husna,
tasbih, a namaz tracker, and Sehri & Iftar times — **all working offline**.

- Package: `com.nayem.quranamol`
- Version: 3.3.0+9
- Flutter 3.35 stable, Material 3, light + dark theme (follows system)
- Deep green `#0E6E36` headers/hero cards + gold `#D9A441` accents on a warm
  off-white background; subtle gradients only on the splash screen and
  the Next Prayer hero card; 8px grid, min touch 48px
- Dependencies: Flutter SDK + `shared_preferences`, `flutter_local_notifications`,
  `timezone`, `just_audio`, `path_provider`, `flutter_compass`, `home_widget`

## What's new in v3.3

Approved dark-emerald redesign (the 6 preview mockups), built on the
v3.2 features — no feature removed, no storage key changed:

- **New dark design system** (`lib/widgets/dark_ui.dart`) — background
  `#071510`, emerald hero gradient `#0E5B3E → #083626`, gold accent
  `#F2C96B`, cards `white 5.5%` with a `white 8%` border. The Home,
  Namaz, Quran list, Tasbih, Hadith and Profile screens use this palette
  as designed; the floating nav is now a dark translucent pill.
- **Home** — location header (tap to change city), real Quran search,
  Hijri (Arabic month name) + Gregorian date chips, Next Prayer hero
  with a code-drawn mosque silhouette, live HH:MM:SS countdown,
  day-progress bar and a real "আজান চালু আছে" pill, the full 6-row
  prayer list (bell + prayed checkbox, next prayer highlighted +
  "পরবর্তী" tag), 6 quick actions, a compact daily-hadith gold card,
  and an "আরও" section (Azkar, Asmaul Husna, Khatam, Knowledge,
  Prophet Stories, Events, Fasting). Jumu'ah Friday card kept. The old
  3-col category grid is gone — its entries live in the quick actions
  and "আরও".
- **Namaz** — same hero + full list, Sehri & Iftar gold card (Sehri =
  Fajr, Iftar = Maghrib, with Iftar countdown), Monthly Calendar +
  Qibla buttons, Namaz tracker, method/Asr settings and the times note.
- **Quran list** — continue-reading card (real last surah/ayah +
  progress), filter chips (সবগুলো / মক্কী / মাদানী / বুকমার্ক / পারা —
  পারা switches to the Juz list), dark surah rows (Bangla name, Arabic
  name, ayah count, মক্কী/মাদানী, gold bookmark when any ayah is
  bookmarked). The reader itself is unchanged.
- **Tasbih** — layout aligned to the preview (dhikr card with gold
  Arabic + prev | N/M | next row inside the card, preset chips,
  counter X/target + Rounds below the bead stage, target chips, tap
  hint). The v3.2 `BeadStringPainter` and slide logic are untouched.
- **Hadith** — collection chips (6 real collections, Bangla short
  names), a main hadith card (Arabic + Bangla + source/number + grade)
  with prev/next, the "আজকের হাদিস" gold card, a real stats strip
  (collections • hadiths • bookmarks) and an "আরও" list of the
  collection's other hadiths.
- **Profile** — header with settings gear, profile card (gold avatar
  initial "ন", name, city, sign-in button), Credit Wallet gold card
  (real local balance + Buy → store, demo mode unchanged), premium card
  (honest demo wording, no "Active" badge), and one dark menu card:
  Bookmarks, Reading Progress (real khatam % + progress bar),
  Namaz Tracker (last-7-days total / 35), Favorites, Purchase
  History, Settings, Help & Support, About (v3.3.0). The sign-out
  tile is gone — it only showed a "guest mode" snackbar.

## What's new in v2.0

- **Azan notifications** — a local notification at each of the 5 prayer
  times (Fajr, Dhuhr, Asr, Maghrib, Isha), scheduled on-device from the
  app's own prayer-time calculation (selected city + method). Master
  on/off + per-prayer toggles in Settings → আজান নোটিফিকেশন. Default
  notification sound only — **no azan audio is bundled or downloaded**
  (licensing risk). Android 13+ notification permission is asked once on
  first run; if exact alarms are denied, scheduling falls back to
  inexact mode instead of crashing. Today + tomorrow are scheduled on
  app start and whenever city/method/azan settings change; after a phone
  restart, opening the app once re-schedules everything.
- **Audio tilawat (streaming, NOT bundled)** — the Quran reader has a
  player bar: play/pause/stop for the current surah, ayah-by-ayah
  auto-advance with the playing ayah highlighted, and "এই আয়াত থেকে
  তিলাওয়াত শুনুন" from any ayah's action sheet. Reciter: Mishary Rashid
  Alafasy. Audio streams per-ayah MP3s from EveryAyah
  (`everyayah.com/data/Alafasy_64kbps/001001.mp3` …) — the APK stays
  small because **no audio is bundled**. (v2.0.1: the Islamic Network
  CDN per-ayah path returned HTTP 403, so the host was switched; file
  names are identical.) A per-surah download button saves that surah's
  MP3s into the app documents folder for offline playback (with
  progress + delete); the whole Quran is never downloaded at once.
  Errors blame the right cause: genuinely no network → "ইন্টারনেট
  সংযোগ নেই", server/audio unavailable → "অডিও পাওয়া যায়নি — পরে
  আবার চেষ্টা করুন", local-playback failure → a plain retry message.
- **Qibla compass** — reachable from Home and the Prayer tab. Bearing +
  distance to the Kaaba are computed in pure Dart from the selected
  city's coordinates; the live heading comes from the device compass
  sensor (`flutter_compass`). Rotating dial with a Kaaba marker, turn
  left/right guidance, and an "aligned" state. Devices without a compass
  sensor still show the bearing, direction and distance with a static
  dial and a clear message.
- **Home widget (Android)** — a home-screen widget showing the next
  prayer name, time and countdown (native `PrayerWidgetProvider` +
  `prayer_widget.xml`, data pushed from Flutter via `home_widget` on
  app start / city change; the system also refreshes it every 30 min).
  The countdown text is as fresh as the last app open.
- **আজকের হাদিস** — a Home card picking one hadith per day with the
  same date-seeded random as the daily dua (same hadith all day,
  different each day), from the bundled 48 hadiths, fully offline.
  Tapping opens the hadith detail screen.
- **খতম ট্র্যাকার** — mark whole surahs as read; total ayahs read /
  6,236 with a progress bar, a daily ayah goal (10/20/50/100) and an
  estimated completion date. All stored locally. A progress card on
  Home shows the same.
- **ইসলামিক ইভেন্ট ক্যালেন্ডার** — upcoming events (রমজান শুরু, ঈদুল
  ফিতর, ঈদুল আজহা, শবে বরাত, শবে কদর, আশুরা, শবে মেরাজ, ঈদে
  মিলাদুন্নবী) for 2026–2028 with a days-remaining countdown for the
  next event. Every date is labelled **"চাঁদ দেখা সাপেক্ষে"** — Hijri
  dates depend on moon sighting and are never presented as exact. Dates
  live in one table (`lib/data/islamic_events.dart`) so they are easy
  to correct later.

## What's new in v3.2 (part 1 — auto azan + tasbih loop)

- **Auto azan after restart** — AlarmManager alarms are wiped on
  reboot, so v3.1's azan stayed silent until the app was opened once.
  v3.2 adds a native `BootReceiver` (Kotlin) + the `bootReschedule`
  Dart entrypoint in `lib/main.dart`: on `BOOT_COMPLETED` (also
  `TIME_SET` / `TIMEZONE_CHANGED`) a background FlutterEngine
  re-schedules today + tomorrow from the stored prefs, with no UI.
  The Dart side signals the receiver on the `boot_reschedule`
  MethodChannel when done (9s safety net). No new permissions —
  `RECEIVE_BOOT_COMPLETED` was already declared. Master toggle,
  per-prayer toggles and the sound toggle are all respected; Sunrise
  never gets azan.
- **Exact-alarm status + test azan (Settings → আজান নোটিফিকেশন)**
  — a status row shows whether the system allows exact alarms
  (Bangla explanation: without it azan may be a few minutes late)
  with an "অনুমতি দিন" button that opens the system Alarms &
  reminders screen; "আজান পরীক্ষা করুন" fires a test azan
  notification ~5 seconds later using the same channel + real azan
  sound, so sound can be verified without waiting for prayer time.
- **Tasbih bead loop (replaces the v3.1 string)** — the beads now
  hang on an open loop with a small empty gap at the top centre (the
  loop's opening). Uncounted beads rest on the left half, counted
  beads accumulate on the right half; every tap hops the next bead
  across the gap while the rest of the string re-spreads one slot,
  and a new round sweeps all beads back to the left around the
  bottom (800ms staggered wave, not a jump cut). Beads are
  3D-textured: layered radial gradients, carved grain ring, rim
  light, specular glints, drop shadow, plus deterministic per-bead
  tone/size/highlight variation. Targets 33/99 show one bead per
  tap; 100/500/1000 show 33 representative beads (one moves per
  target/33 taps). Counts, presets, targets, streak and history
  storage are untouched — no data reset.

## What's new in v3.1

- **3D tasbih (reference video)** — the counter screen's ring is
  replaced by a realistic bead string drawn with a CustomPainter
  (`lib/widgets/bead_string.dart`): a curved thread with glossy
  spherical beads (radial-gradient highlight top-left, dark edge, soft
  drop shadow, specular dot). On every tap the string slides one bead
  along the thread with a 350ms easeOutCubic animation (single
  AnimationController + painter repaint only — no jank), the counter
  pops a floating "+1", and the active bead gets a green glow + ring.
  Bead colours: black / green / amber / white via the palette button
  (persisted in AppState). Dhikr card on top shows Arabic +
  transliteration + meaning separated by dashed lines; swipe or use
  the arrows to move between dhikrs with a "N/M" position indicator.
  Counter shows "X/target" + "Rounds: N" (rolls to round 2 after the
  target, like the video). Existing counts, presets, targets, streak
  and history storage are untouched — no data reset.
- **City Select screen (reference video)** — replaces the old bottom
  sheet picker: search bar, "Current Location" row, "Popular Cities"
  chips (8 Bangladeshi cities), full city list grouped alphabetically
  with letter headers, and a right-side A–Z fast-scroll rail (tap or
  drag a letter to jump; current letter highlighted green; big letter
  bubble while dragging). Selecting a city applies it everywhere
  (prayer times, widget, azan), exactly like before.
- **Prayer list upgrades (reference video)** — each prayer row on the
  Prayer tab now has a speaker toggle for that prayer's azan (wired to
  the SAME per-prayer toggles as Settings) and a checkbox to mark the
  prayer as prayed today (wired to the SAME namaz-tracker state/keys
  as the tracker card). Sunrise has neither. The Home prayer strip
  shows a green check under prayers marked today. The live countdown
  and Hijri date bar are unchanged.
- **Home quick-access row (reference video)** — compact horizontal
  icon row under the prayer strip: Azkar, Tasbih, Calendar, Duas,
  Names, Tracker, Fasting — all map to existing screens (no new
  screens; Shahada from the video is skipped — no screen exists).

## What's new in v3.0

- **Full UI redesign (reference look)** — deep green headers/cards,
  white content areas, green + gold/amber accents, clean rounded cards,
  built with Flutter widgets + icons + solid colors only (no images;
  the crescent, mosque silhouette and star pattern are drawn in code).
  A subtle gradient is allowed only on the splash screen and the Next
  Prayer hero card. The v2.0.1 minimal floating bottom nav is unchanged
  (transparent Row, active = green rounded rect + white icon/label,
  inactive = muted grey) and still hides on every sub-screen.
- **Splash screen (new)** — green gradient, crescent + mosque motif,
  "Quran & Masnun Amol", "Read • Learn • Practice", "Loading..." —
  brief, then straight to Home.
- **Home rebuilt** — location row + search bar, Hijri/Gregorian date
  header under the location row, Next Prayer hero card (name + time in
  gold + countdown), prayer strip (Fajr/Sunrise/Dhuhr/Asr/Maghrib/Isha),
  3-column category grid, Daily Dua + Daily Hadith cards, Khatam
  progress. **Jumu'ah:** on Fridays a special green reminder card
  appears ("জুম'আর দিন" — Surah Al-Kahf, salawat, Jumu'ah preparation),
  and Dhuhr is labelled "জুম'আ" everywhere (Home strip, Next Prayer
  card, Prayer list, azan toggles) via `displayPrayerName()`.
- **New categories** — Zakat Calculator, Islamic Knowledge, and Stories
  of Prophets tiles on Home (each opens its own screen).
- **Quran reader rebuilt** — green surah header card (Arabic name,
  meaning, ayah count, Bismillah + transliteration), ayah cards with
  number circle, Arabic text, Bangla translation, per-ayah speaker
  button, and a bottom action row (Bookmark / Share / Ayah / More)
  acting on the tapped ayah. Player controls are now prev /
  play-pause / next with ayah-based progress (Ayah X / N) wired to the
  existing audio service — no API change.
- **Prayer Times rebuilt** — green header band with location, Next
  Prayer hero, full prayer list with icons, and a **Monthly Calendar**
  button: a month grid where every day shows its Fajr + Maghrib times
  (on-device calculation, no network), tapping a day shows its full
  prayer list. Sehri & Iftar, Namaz tracker, Qibla and method settings
  are unchanged.
- **Me / My Account rebuilt** — green profile header, Credit Wallet
  card, Premium Access row, Bookmarks, Reading Progress (khatam),
  Settings, Help & Support — same navigation targets as before.
- **Real azan sound** — Settings → আজান নোটিফিকেশন has a new
  "আজানের শব্দ" toggle (on by default): notifications can now play the
  real azan sound instead of the default notification sound only.
- **Home dates** — the Hijri + Gregorian date header now sits on Home
  under the location row.
- **Beautified tasbih** — the tasbih counter screens were restyled to
  match the new deep-green + gold look.

## What's new in v2.0.1

- **Minimal floating bottom navigation** — the full-width pill is
  gone: no background container, no border, no shadow. Just 3 items
  (হোম / নামাজ / আমি) in a transparent Row floating above the system
  gesture area (SafeArea). Active item: green rounded rectangle with
  white icon + label; inactive: muted grey, no background. Custom
  widget, not BottomNavigationBar / NavigationBar. Still only on the
  3 main tabs (RouteObserver + rootNavigator hiding unchanged); main
  tabs keep their 96px bottom padding, which clears the new bar.
- **Audio CDN fixed** — the Islamic Network per-ayah path returned
  HTTP 403 (the app wrongly blamed the internet), so per-ayah MP3s
  now stream/download from `everyayah.com/data/Alafasy_64kbps/`
  (verified HTTP 200). Same file names, same Alafasy reciter, same
  per-surah download. Errors now blame the right cause: no network,
  audio unavailable on the server, or a local playback failure.

## What's new in v1.2

- **Bottom bar can never appear on a sub-screen** — two independent
  guarantees: (1) the shell owns ONE floating pill bar and a RouteObserver
  hides it whenever any route is pushed above the main tabs (it reappears
  on back); (2) all 32 sub-screen pushes use
  `Navigator.of(context, rootNavigator: true)`, so every sub-screen covers
  the shell completely. The bar lives only on Home / Prayer / Me.
- **Tighter floating bar** — the empty space below the pill is now 8px
  (was 16px), so the bar reads as properly floating over the content.
- **Category tiles never clip** — label font 15sp → 13sp (line height
  1.35), icon 48px → 44px, grid tiles taller (aspect 2.2 → 1.9), so
  "সকাল-সন্ধ্যার আমল" and every other Bangla label shows in full.
- **Daily Dua is random every day** — `dailyDua()` now draws with a
  date-seeded `Random(year * 372 + month * 31 + day)`: same dua all day,
  a different random-feeling one each day, never sequential, fully offline.
- **Safe bottom padding** — all detail/list screens now end with 32px of
  bottom padding, so no content can hide behind any bottom UI.

## What's new in v1.1

- **Bangla by default** — the whole UI is in Bangla (tabs, section titles,
  Settings, Copy/Share buttons) with an "English UI" toggle in Settings
  (saved in SharedPreferences). Quran reader translation defaults to Bangla
  (Muhiuddin Khan); English is the toggle option. Surah list shows Bangla
  surah names + Bangla meanings for all 114 surahs (`lib/data/surah_names_bn.dart`).
  All 28 duas have Bangla titles + Bangla meanings, all 48 hadiths have
  Bangla meanings, and all 99 Asmaul Husna names have Bangla meanings.
  Search also matches Bangla surah names, dua titles and hadith meanings.
- **Premium UI** — a very subtle Islamic geometric 8-point-star pattern
  (lightweight `CustomPainter`, ~4% opacity green on light theme, ~5% white
  on dark) tiles behind every screen's content; card corners are now 20px,
  section titles slightly larger, spacing softer. No gradients.
- **Modern buttons** — primary CTAs are full-width filled buttons (52px,
  radius 16, green + white text + leading icon); secondary actions are
  tonal; icon buttons are 44px circular tonal; Copy/Share/Favorite rows are
  proper segmented tonal buttons; the NavigationBar is a floating pill
  (radius 28) whose selected item is a filled green pill.
- **Tasbih counter** — thin progress ring around the circle, soft shadow,
  and a scale animation on tap.
- **Bottom bar fix** — the floating NavigationBar is visible ONLY on the
  three main tabs (Home, Prayer, Me). Every sub-screen (Quran reader,
  Surah list, Juz, Hadith list/detail, Category/Item detail, Daily Dua
  detail, Tasbih counter, Search, Credit Store, Payment, Settings,
  Favorites/Bookmarks/History) pushes without the bar. Loading states show
  a centered spinner with text.
- **12-hour time** — prayer times, countdowns and Sehri/Iftar are in 12-hour
  format with AM/PM by default (Latin digits); Settings keeps a 12h/24h
  toggle. Hijri/Gregorian date header unchanged.
- **Smaller APK** — the cloud build now uses `--split-per-abi` and ships
  only the arm64 APK (`app-arm64-v8a-release.apk`), so the download is much
  smaller than the 138 MB multi-ABI debug build.

## What works (all offline, no account needed)

- **Prayer times** — pure-Dart solar calculation on the device. Default method
  Karachi (University of Islamic Sciences), Asr Standard/Hanafi switch.
  Default location Dhaka; location picker with ~70 bundled cities (Bangladesh
  divisions + major world cities), saved locally. Live countdown to the next
  prayer, previous/next day, Gregorian + Hijri date (Hijri is an arithmetic
  approximation and may differ by a day). Verified against the algorithm:
  Dhaka 2026-11-20 (Karachi): Fajr 04:58, Sunrise 06:16, Dhuhr 11:44,
  Asr 14:50 Standard / 15:36 Hanafi, Maghrib 17:11, Isha 18:30.
- **Sehri & Iftar** — card on the Prayer tab: Sehri ends at Fajr, Iftar at
  Maghrib, with a live countdown to whichever comes next.
- **Namaz tracker** — tap the 5 check circles to mark prayers for the day
  (saved per date), plus a last-7-days bar row.
- **Quran** — full 114 surahs / 6,236 ayahs bundled as `assets/quran.json`
  (Arabic, Uthmani script) with English translation (Sahih International) and
  Bangla translation (Muhiuddin Khan, `assets/quran_bn.json`). Surah list with
  Bangla names + meanings, search, 30 Juz tab with standard juz boundaries, reader with Bismillah
  (except At-Tawbah), adjustable Arabic size, translation switcher
  (Bangla / English / Off, Bangla is the default), tap an ayah for Copy/Share/Bookmark, last-read
  position auto-saved with a Continue Reading button.
- **Duas** — 28 bundled duas: morning & evening adhkar (Ayat al-Kursi, the
  three Quls, Sayyidul Istighfar, …) and daily masnun duas (eating, sleep,
  home, masjid, wudu, travel, …) with Arabic, transliteration, Bangla title,
  Bangla meaning and reference. Daily Dua card picks by day of year.
- **Asmaul Husna** — all 99 Names with Arabic, transliteration, Bangla
  meaning (English as secondary); tap a name to Copy/Share it.
- **Hadith** — 48 bundled hadiths across the 6 collections (Sahih al-Bukhari
  10, Sahih Muslim 10, Sunan Abu Dawud 8, Jami at-Tirmidhi 8,
  Sunan an-Nasa'i 6, Sunan Ibn Majah 6), grouped by book, with Arabic excerpt,
  Bangla translation (English as secondary), narrator, reference and grade.
- **Tasbih** — SubhanAllah 33, Alhamdulillah 33, Allahu Akbar 34,
  La ilaha illallah 100, Astaghfirullah 100, Durood Sharif 100,
  SubhanAllahi wa bihamdihi 100, plus custom tasbihs. Big circular counter
  with a progress ring, soft shadow and tap scale animation,
  haptic on tap (stronger at target), Reset with confirmation, vibration
  toggle, counts persisted. History: today's total, daily streak
  (consecutive days with at least 1 tasbih) and a last-7-days bar row.
- **Search** — full screen, 300ms debounce, min 2 characters, groups
  Quran / Hadith / Dua (up to 5 each), local data only; matches Bangla
  surah names, dua titles and hadith meanings too.
- **Me tab** — Guest profile, local credit balance, Favorites, Bookmarks,
  Purchase History, Settings (language: Bangla/English, theme, Arabic size,
  translation language, 12h/24h, prayer method, Asr method), About, Sign out.

## What is intentionally demo / not yet real

- **Google sign-in** — tapping Sign in shows a dialog explaining that
  Firebase Authentication setup is needed. No sign-in is faked; the app
  runs as a guest and all data stays on the device.
- **Credit purchases** — the Credit Store lists 3 packages with placeholder
  prices (৳100 / ৳200 / ৳450). The Payment page simulates processing and
  adds credits locally, clearly labelled "Demo mode". Real Play Billing
  needs Google Play Console products + the Cloudflare verification Worker
  from the PRD (section 6); no real money is charged.
- **Share** — no share plugin is bundled (minimal dependencies), so Share
  copies the text to the clipboard with a note to paste it anywhere.
- **Location** — city search from the bundled list only; GPS ("use current
  location") needs the geolocator plugin and is not included. City UTC
  offsets are standard time; daylight saving is not applied.
- **Wakelock** — the tasbih counter does not keep the screen awake (would
  need the wakelock plugin).

## Data sources

- Quran Arabic (Uthmani) + English (Sahih International):
  `api.alquran.cloud/v1/quran/quran-uthmani` and `/v1/quran/en.sahih`
  (the jsDelivr `eng-sahih.json` file did not exist; the Arabic jsDelivr
  file was a flat verse list, so alquran.cloud was used for both).
  Verified: 114 surahs, 6,236 ayahs; Al-Fatiha 7, Al-Baqarah 286, At-Tawbah 129.
- Bangla translation (Muhiuddin Khan):
  `cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions/ben-muhiuddinkhan.json`
  — verified 114 surahs / 6,236 ayahs, aligned 1:1 with the Arabic file.
- Bismillah handling: the Uthmani text prefixes Bismillah to ayah 1 of
  surahs 2–114; it was stripped from the ayah text during normalization and
  is rendered as a separate header (except At-Tawbah, surah 9; surah 1 keeps
  it as ayah 1).
- Hadith and duas are bundled from well-known authentic texts; a hadith
  number is shown only where it is well established.

## Cloud build (GitHub Actions)

`.github/workflows/build.yml` — copied from the proven ArrowFlow pattern
(Flutter 3.35.x, Java 17, artifact `quran-masmun-amol-release-arm64`,
retention 30 days), but triggered **only** by `workflow_dispatch` (not on
push), because the files are uploaded via the API one by one and a push
trigger would build incomplete trees. The build step is
`flutter build apk --release --split-per-abi` and only the arm64 APK is
uploaded (`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`).

```bash
git push origin main
# GitHub → Actions → "Build Quran & Masnun Amol APK" → Run workflow
# Download the artifact: quran-masmun-amol-release-arm64 → app-arm64-v8a-release.apk
```

The Gradle wrapper (`android/gradlew` + `gradle/wrapper/`) is committed so
the cloud build works without a local Gradle install.

## Project layout

```
lib/
  main.dart            App entry + shell (floating rounded bottom nav)
  theme.dart           Material 3 light/dark themes
  models/models.dart   Surah, Ayah, Dua, Hadith, TasbihItem, CreditPackage,
                       PurchaseRecord, City, AsmaulHusna
  data/                cities.dart (~70 cities), duas.dart (28, Bangla
                       titles + meanings), hadith.dart (48, Bangla meanings),
                       tasbih.dart, juz.dart (30 juz),
                       asmaul_husna.dart (99, Bangla meanings),
                       surah_names_bn.dart (114 Bangla names + meanings)
  services/            prayer.dart (adhan calc + Hijri approx),
                       quran_service.dart (bundled JSON loader),
                       app_state.dart (settings + local data, SharedPreferences),
                       navigation.dart (tab switching),
                       strings.dart (Bangla/English UI strings, ~210 keys)
  screens/             home.dart, prayer.dart, quran.dart (list + reader),
                       month_calendar.dart (v3.0 monthly grid),
                       zakat.dart, knowledge.dart, stories.dart (v3.0),
                       content.dart (duas, hadith, tasbih, search, Asmaul Husna),
                       me.dart (Me, settings, credit store, payment, lists)
  widgets/common.dart  AppScaffold (8-point-star texture background),
                       MainNavBar (floating pill), PrimaryButton/TonalButton/
                       TonalIconButton/CopyShareRow, SectionTitle, Top bar,
                       location picker, copy/share, empty/loading states,
                       NextPrayerHero, PrayerStrip, CategoryTile (v3.0)
  widgets/date_header.dart  DateHeader (v3.0, Hijri + Gregorian on Home)
assets/
  quran.json           114 surahs, 6,236 ayahs (Arabic + English), 2.52 MB
  quran_bn.json        Bangla translation, same 6,236 ayahs, 2.35 MB
```

## Standing rule

Android builds are cloud-only (GitHub Actions). Never run `flutter build`
or Gradle locally for this project.
