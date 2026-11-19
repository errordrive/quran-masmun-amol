# Quran & Masnun Amol

A clean, minimal Islamic companion app for Android (Flutter, Material 3):
prayer times, the full Quran, Hadith, daily duas, masnun amol, Asmaul Husna,
tasbih, a namaz tracker, and Sehri & Iftar times — **all working offline**.

- Package: `com.nayem.quranamol`
- Version: 1.0.0+1
- Flutter 3.35 stable, Material 3, light + dark theme (follows system)
- Primary green `#15803D`, no gradients, no heavy shadows, 8px grid, min touch 48px
- Dependencies: Flutter SDK + `shared_preferences` only

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
  search, 30 Juz tab with standard juz boundaries, reader with Bismillah
  (except At-Tawbah), adjustable Arabic size, translation switcher
  (English / Bangla / Off), tap an ayah for Copy/Share/Bookmark, last-read
  position auto-saved with a Continue Reading button.
- **Duas** — 28 bundled duas: morning & evening adhkar (Ayat al-Kursi, the
  three Quls, Sayyidul Istighfar, …) and daily masnun duas (eating, sleep,
  home, masjid, wudu, travel, …) with Arabic, transliteration, meaning and
  reference. Daily Dua card picks by day of year.
- **Asmaul Husna** — all 99 Names with Arabic, transliteration and meaning;
  tap a name to Copy/Share it.
- **Hadith** — 48 bundled hadiths across the 6 collections (Sahih al-Bukhari
  10, Sahih Muslim 10, Sunan Abu Dawud 8, Jami at-Tirmidhi 8,
  Sunan an-Nasa'i 6, Sunan Ibn Majah 6), grouped by book, with Arabic excerpt,
  English translation, narrator, reference and grade.
- **Tasbih** — SubhanAllah 33, Alhamdulillah 33, Allahu Akbar 34,
  La ilaha illallah 100, Astaghfirullah 100, Durood Sharif 100,
  SubhanAllahi wa bihamdihi 100, plus custom tasbihs. Big circular counter,
  haptic on tap (stronger at target), Reset with confirmation, vibration
  toggle, counts persisted. History: today's total, daily streak
  (consecutive days with at least 1 tasbih) and a last-7-days bar row.
- **Search** — full screen, 300ms debounce, min 2 characters, groups
  Quran / Hadith / Dua (up to 5 each), local data only.
- **Me tab** — Guest profile, local credit balance, Favorites, Bookmarks,
  Purchase History, Settings (theme, Arabic size, translation language,
  12h/24h, prayer method, Asr method), About, Sign out.

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
(Flutter 3.35.x, Java 17, `flutter build apk --debug`, artifact
`quran-masmun-amol-debug-apk`, retention 30 days), but triggered **only**
by `workflow_dispatch` (not on push), because the files are uploaded via
the API one by one and a push trigger would build incomplete trees.

```bash
git push origin main
# GitHub → Actions → "Build Quran & Masnun Amol APK" → Run workflow
# Download the artifact: quran-masmun-amol-debug-apk → app-debug.apk
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
  data/                cities.dart (~70 cities), duas.dart (28),
                       hadith.dart (47), tasbih.dart, juz.dart (30 juz),
                       asmaul_husna.dart (99)
  services/            prayer.dart (adhan calc + Hijri approx),
                       quran_service.dart (bundled JSON loader),
                       app_state.dart (settings + local data, SharedPreferences),
                       navigation.dart (tab switching)
  screens/             home.dart, prayer.dart, quran.dart (list + reader),
                       content.dart (duas, hadith, tasbih, search, Asmaul Husna),
                       me.dart (Me, settings, credit store, payment, lists)
  widgets/common.dart  Top bar, location picker, copy/share, empty/loading states
assets/
  quran.json           114 surahs, 6,236 ayahs (Arabic + English), 2.52 MB
  quran_bn.json        Bangla translation, same 6,236 ayahs, 2.35 MB
```

## Standing rule

Android builds are cloud-only (GitHub Actions). Never run `flutter build`
or Gradle locally for this project.
