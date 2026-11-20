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
          home: const MainShell(),
        );
      },
    );
  }
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
