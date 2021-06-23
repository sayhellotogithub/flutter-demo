import 'package:flutter/material.dart';

class RecipeManager extends ChangeNotifier {
  var _didSearchClick = false;

  bool get didSearchClick => _didSearchClick;

  void tapOnSearch(bool didSearchClick) {
    _didSearchClick = didSearchClick;
    notifyListeners();
  }
}
