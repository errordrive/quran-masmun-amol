// Shared navigation signal so any screen can switch the main tab.
import 'package:flutter/foundation.dart';

final ValueNotifier<int> currentTab = ValueNotifier<int>(0);

void goToTab(int index) => currentTab.value = index;
