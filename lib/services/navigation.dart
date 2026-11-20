// Shared navigation (v1.2).
// - Tab switching signal so any screen can switch the main tab.
// - Root-navigator pushes: every sub-screen is pushed on the ROOT
//   navigator, so it always covers the shell (and its bottom bar).
// - RouteObserver: the shell hides the bottom bar whenever ANY route is
//   pushed above the main tabs, so the bar can never appear on a
//   sub-screen even if a push were ever mis-routed.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ValueNotifier<int> currentTab = ValueNotifier<int>(0);

void goToTab(int index) => currentTab.value = index;

/// Observes the root navigator; MainShell subscribes its own route.
final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

/// True while the topmost route is a main tab (Home / Prayer / Me).
/// False while any sub-screen is pushed above the shell.
final ValueNotifier<bool> isTopLevelRoute = ValueNotifier<bool>(true);

/// Push a sub-screen on the ROOT navigator so it always covers the shell
/// (and its floating bottom bar) completely. Use this for EVERY push to a
/// sub-screen; never use a bare Navigator.of(context).push for one.
Future<T?> pushScreen<T>(BuildContext context, Widget page) {
  return Navigator.of(context, rootNavigator: true).push<T>(
    MaterialPageRoute(builder: (_) => page),
  );
}
