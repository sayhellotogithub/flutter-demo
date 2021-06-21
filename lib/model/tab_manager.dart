import 'package:flutter/material.dart';

class TabManager extends ChangeNotifier {
  int selectedTab = 0;

  void gotoTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  void gotoRecipe() {
    gotoTab(1);
  }
}
