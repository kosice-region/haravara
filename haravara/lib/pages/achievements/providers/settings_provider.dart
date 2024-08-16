import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends ChangeNotifier {
  String selectedValueView = 'Menej';
  String selectedValueSort = 'Otvorene';

  void toggleValueView(String value) {
    selectedValueView = value;
    notifyListeners();
  }

  String getCurrentValueView() {
    return selectedValueView;
  }

  void toggleValueSort(String value) {
    selectedValueSort = value;
    notifyListeners();
  }

  String getCurrentValueSort() {
    return selectedValueSort;
  }
}

final settingsProvider = ChangeNotifierProvider<SettingsNotifier>((ref) {
  return SettingsNotifier();
});
