import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:open/network/recipe_model.dart';
import 'repository.dart';


class MemoryRepository extends Repository with ChangeNotifier {
  final List<APIRecipe> _currentRecipes = <APIRecipe>[];

  @override
  List<APIRecipe> findAllRecipes() {
    return _currentRecipes;
  }

  @override
  APIRecipe findRecipeById(int id) {
    return _currentRecipes.firstWhere((recipe) => recipe.id == id);
  }

  @override
  int insertRecipe(APIRecipe recipe) {
    _currentRecipes.add(recipe);
    notifyListeners();
    return 0;
  }


  @override
  void deleteRecipe(APIRecipe recipe) {
    _currentRecipes.remove(recipe);
    notifyListeners();
  }



  @override
  Future init() { return Future.value(null); }

  @override
  void close() {}
}
