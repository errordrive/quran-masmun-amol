// Quran & Masnun Amol — entry point.
// Shell: floating rounded NavigationBar with Home | Prayer | Me.
// The bar is visible on the three main tabs only; pushed sub-screens
// (reader, payment, etc.) cover it, and Android back returns to the parent.
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/me.dart';
import 'screens/prayer.dart';
import 'services/app_state.dart';
import 'services/navigation.dart';
import 'theme.dart';

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

  static const List<Widget> _tabs = [
    HomeScreen(),
    PrayerScreen(),
    MeScreen(),
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
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(index: _index, children: _tabs),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) {
                setState(() => _index = i);
                currentTab.value = i;
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.access_time_outlined),
                  selectedIcon: Icon(Icons.access_time),
                  label: 'Prayer',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Me',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
