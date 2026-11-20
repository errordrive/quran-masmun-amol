// Quran & Masnun Amol — entry point (v1.2).
// ONE shell Scaffold owns the minimal floating MainNavBar. The bar is built
// ONLY while the topmost route is a main tab: a RouteObserver flips
// isTopLevelRoute off whenever any sub-screen is pushed (and back on when
// it pops), AND every sub-screen is pushed on the root navigator, so it
// covers the shell completely. Either mechanism alone would hide the bar;
// both together make it impossible for the bar to appear on a sub-screen.
// Android back on a main tab returns to Home, then exits.
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/me.dart';
import 'screens/prayer.dart';
import 'services/app_state.dart';
import 'services/azan_service.dart';
import 'services/navigation.dart';
import 'services/widget_service.dart';
import 'theme.dart';
import 'widgets/common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init();
  // v2.0 — azan notifications: ask permission once, then schedule
  // today + tomorrow. After a phone restart, opening the app once
  // re-schedules everything. Failures here must never block startup.
  try {
    await AzanService.init();
    if (!AppState.instance.azanPermAsked) {
      await AzanService.requestPermissions();
      AppState.instance.markAzanPermAsked();
    }
    await AzanService.scheduleAll();
  } catch (_) {}
  // v2.0 — push the next prayer into the home-screen widget.
  try {
    await HomeWidgetService.update();
  } catch (_) {}
  runApp(const QuranAmolApp());
}

class QuranAmolApp extends StatelessWidget {
  const QuranAmolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Quran & Masnun Amol',
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: AppState.instance.themeMode,
          navigatorObservers: [routeObserver],
          home: const SplashScreen(),
        );
      },
    );
  }
}

// ---------------- Splash screen (v3.0) ----------------

/// Brief green splash (reference layout): gradient + star pattern,
/// crescent + mosque silhouette drawn with shapes only (no image
/// assets), hanging lanterns, app name, tagline, "Loading..." — then
/// straight to the main shell. Shows ~1.8s; all init already ran in
/// main() before runApp, so nothing here blocks startup.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: splashGradient),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: _SplashStarPainter(),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 220,
              child: CustomPaint(
                painter: MosqueSilhouettePainter(color: Colors.white),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 64, child: HangingLantern()),
                      SizedBox(width: 64, child: HangingLantern()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CustomPaint(
                      painter: CrescentPainter(
                          color: goldAccent.withOpacity(0.95)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Quran &',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        height: 1.1),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Masnun Amol',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        height: 1.1),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Read • Learn • Practice',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.menu_book,
                      size: 56, color: Colors.white),
                  const SizedBox(height: 16),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Faint white stars for the splash (same 8-point-star motif, white).
class _SplashStarPainter extends CustomPainter {
  const _SplashStarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const tile = 76.0;
    const r = 13.0;
    final rows = (size.height / tile).ceil() + 1;
    final cols = (size.width / tile).ceil() + 1;
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cx = col * tile + (row.isOdd ? tile / 2 : 0);
        final cy = row * tile;
        canvas.drawRect(
            Rect.fromCenter(
                center: Offset(cx, cy), width: r * 2, height: r * 2),
            paint);
        final diag = r * 1.41421356;
        final p2 = Path()
          ..moveTo(cx, cy - diag)
          ..lineTo(cx + diag, cy)
          ..lineTo(cx, cy + diag)
          ..lineTo(cx - diag, cy)
          ..close();
        canvas.drawPath(p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SplashStarPainter old) => false;
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with RouteAware {
  int _index = 0;
  bool _subscribed = false;

  @override
  void initState() {
    super.initState();
    currentTab.addListener(_onTabChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_subscribed) {
      final route = ModalRoute.of(context);
      if (route is PageRoute<dynamic>) {
        routeObserver.subscribe(this, route);
        _subscribed = true;
      }
    }
  }

  // A sub-screen was pushed above the shell: hide the bottom bar.
  @override
  void didPushNext() => isTopLevelRoute.value = false;

  // Back on a main tab: show the bottom bar again.
  @override
  void didPopNext() => isTopLevelRoute.value = true;

  void _onTabChanged() {
    if (mounted && currentTab.value != _index) {
      setState(() => _index = currentTab.value);
    }
  }

  @override
  void dispose() {
    if (_subscribed) routeObserver.unsubscribe(this);
    currentTab.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _index != 0) {
          setState(() => _index = 0);
          currentTab.value = 0;
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isTopLevelRoute,
        builder: (context, topLevel, _) {
          return AppScaffold(
            bottomNavigationBar: topLevel ? const MainNavBar() : null,
            body: IndexedStack(
              index: _index,
              children: const [
                SafeArea(child: HomeScreen()),
                SafeArea(child: PrayerScreen()),
                SafeArea(child: MeScreen()),
              ],
            ),
          );
        },
      ),
    );
  }
}
