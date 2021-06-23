import 'package:flutter/material.dart';
import 'package:open/model/grocery_item.dart';

class GroceryManager extends ChangeNotifier {
  final _groceryItems = <GroceryItem>[];
  bool _createNewItem = false;
  int? _selectedIndex = null;

  List<GroceryItem> get groceryItems => List.unmodifiable(_groceryItems);

  int? get selectedIndex => _selectedIndex;

  GroceryItem? selectedGroceryItem;

  bool get isCreatingNewItem => _createNewItem;

  void deleteItem(int index) {
    _groceryItems.removeAt(index);
    notifyListeners();
  }

  void createNewItem() {
    _selectedIndex = null;
    _createNewItem = true;
    notifyListeners();
  }

  void groceryItemTapped(int index) {
    _selectedIndex = index;
    _createNewItem = false;
    selectedGroceryItem = _groceryItems[index];
    notifyListeners();
  }

  void setSelectedGroceryItem(String id) {
    final index = groceryItems.indexWhere((element) => element.id == id);
    if (index != -1) {
      groceryItemTapped(index);
    }
  }

  void groceryItemBackNothingChange() {
    _selectedIndex = null;
    _createNewItem = false;
    notifyListeners();
  }

  void addItem(GroceryItem item) {
    _groceryItems.add(item);
    _createNewItem = false;
    notifyListeners();
  }

  void updateItem(GroceryItem item, int? index) {
    if (index != null) {
      _groceryItems[index] = item;
    }
    _selectedIndex = null;
    _createNewItem = false;
    notifyListeners();
  }

  void completeItem(int index, bool change) {
    final item = _groceryItems[index];
    _groceryItems[index] = item.copyWith(isComplete: change);
    notifyListeners();
  }
}
