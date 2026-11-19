// Quran & Masnun Amol — entry point (v1.1).
// Each main tab (Home | Prayer | Me) owns its own AppScaffold with the
// floating pill MainNavBar. Sub-screens are pushed onto the root
// Navigator as plain AppScaffolds, so the bottom bar NEVER appears on
// them. Android back on a main tab returns to Home, then exits.
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/me.dart';
import 'screens/prayer.dart';
import 'services/app_state.dart';
import 'services/navigation.dart';
import 'theme.dart';
import 'widgets/common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init();
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

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // Each tab owns its scaffold + pill bar; pushed sub-screens cover the
  // whole screen and carry no bar.
  static const List<Widget> _tabs = [
    AppScaffold(
      bottomNavigationBar: MainNavBar(),
      body: SafeArea(child: HomeScreen()),
    ),
    AppScaffold(
      bottomNavigationBar: MainNavBar(),
      body: SafeArea(child: PrayerScreen()),
    ),
    AppScaffold(
      bottomNavigationBar: MainNavBar(),
      body: SafeArea(child: MeScreen()),
    ),
  ];

  @override
  void initState() {
    super.initState();
    currentTab.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (mounted && currentTab.value != _index) {
      setState(() => _index = currentTab.value);
    }
  }

  @override
  void dispose() {
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
      child: IndexedStack(index: _index, children: _tabs),
    );
  }
}
