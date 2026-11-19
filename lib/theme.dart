// Material 3 theme (v1.1): one primary green, flat surfaces, no gradients,
// no heavy shadows. Soft 20px card corners, 52px buttons, radius 16.
// Light + dark follow the system by default.
import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF15803D);
const Color primaryGreenDark = Color(0xFF166534);

const double cardRadius = 20;
const double buttonRadius = 16;
const double buttonHeight = 52;

ThemeData lightTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: primaryGreen,
    brightness: Brightness.light,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF7F7F2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        side: BorderSide(color: Color(0xFFE5E5E0)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      indicatorColor: primaryGreen,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: primaryGreen);
        }
        return const TextStyle(fontSize: 12, color: Colors.black54);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Colors.white);
        }
        return const IconThemeData(color: Colors.black54);
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, buttonHeight),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, buttonHeight),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E5E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E5E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
    ),
    listTileTheme: const ListTileThemeData(minVerticalPadding: 8),
    chipTheme: ChipThemeData(
      backgroundColor: primaryGreen.withOpacity(0.12),
      labelStyle: const TextStyle(color: primaryGreen),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide.none,
    ),
  );
}

ThemeData darkTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: primaryGreen,
    brightness: Brightness.dark,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        side: BorderSide(color: Color(0xFF2E2E2E)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 0,
      indicatorColor: primaryGreen,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white);
        }
        return const TextStyle(fontSize: 12, color: Colors.white70);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Colors.white);
        }
        return const IconThemeData(color: Colors.white70);
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryGreenDark,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, buttonHeight),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, buttonHeight),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
    ),
    listTileTheme: const ListTileThemeData(minVerticalPadding: 8),
    chipTheme: ChipThemeData(
      backgroundColor: primaryGreen.withOpacity(0.22),
      labelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide.none,
    ),
  );
}
