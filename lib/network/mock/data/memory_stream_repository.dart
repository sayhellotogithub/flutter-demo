import 'dart:async';
import 'dart:core';
import 'package:open/network/mock/data/stream_repository.dart';
import 'package:open/network/recipe_model.dart';

class MemoryStreamRepository extends StreamRepository {
  Stream<List<APIRecipe>>? _recipeStream;
  final List<APIRecipe> _currentRecipes = <APIRecipe>[];

  final StreamController<List<APIRecipe>> _recipeStreamController =
      StreamController<List<APIRecipe>>();

  @override
  Future init() {
    return Future.value();
  }

  @override
  void close() {
    _recipeStreamController.close();
  }

  @override
  Future<void> deleteRecipe(APIRecipe recipe) {
    var temp = _currentRecipes.firstWhere((element) => element.id == recipe.id);
    _currentRecipes.remove(temp);
    _recipeStreamController.sink.add(_currentRecipes);
    return Future.value();
  }

  @override
  Future<List<APIRecipe>> findAllRecipes() {
    return Future.value(_currentRecipes);
  }

  @override
  Future<APIRecipe> findRecipeById(int id) {
    final recipe = _currentRecipes.firstWhere((element) => element.id == id);
    return Future.value(recipe);
  }

  @override
  Future<int> insertRecipe(APIRecipe recipe) {
    _currentRecipes.add(recipe);
    _recipeStreamController.sink.add(_currentRecipes);
    return Future.value(0);
  }

  @override
  Stream<List<APIRecipe>> watchAllRecipes() {
    if (_recipeStream == null) {
      _recipeStream = _recipeStreamController.stream;
    }
    return _recipeStream!;
  }

  @override
  Future<List<APIIngredients>> findRecipeIngredients(int id) {
    return Future.value([]);
  }
}
