import 'dart:async';
import 'package:flutter/services.dart';
import 'package:open/network/mock/data/stream_repository.dart';
import 'package:open/network/recipe_model.dart';

import 'database_helper.dart';

class SqliteRepository extends StreamRepository {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<List<APIRecipe>> findAllRecipes() {
    return dbHelper.findAllRecipes();
  }

  @override
  Stream<List<APIRecipe>> watchAllRecipes() {
    return dbHelper.watchAllRecipes();
  }

  @override
  Stream<List<APIIngredients>> watchAllIngredients() {
    return dbHelper.watchAllIngredients();
  }

  @override
  Future<APIRecipe> findRecipeById(int id) {
    return dbHelper.findRecipeById(id);
  }

  Future<List<APIIngredients>> findAllIngredients() {
    return dbHelper.findAllIngredients();
  }
  @override
  Future<List<APIIngredients>> findRecipeIngredients(int id) {
    return dbHelper.findRecipeIngredients(id);
  }

  @override
  Future<int> insertRecipe(APIRecipe recipe) {
    return Future(() async {
      final id = await dbHelper.insertRecipe(recipe);
      recipe.id = id;
      print("recipe.id:${recipe.id}");
      if (recipe.ingredients != null) {
        recipe.ingredients?.forEach((ingredient) {
          print(ingredient.name);
          ingredient.recipeId = id;
        });
        insertIngredients(recipe.ingredients!);
      }

      return id;
    });
  }

  @override
  Future<List<int>> insertIngredients(List<APIIngredients> ingredients) {
    return Future(() async {
      if (ingredients.length != 0) {
        final ingredientIds = <int>[];

        await Future.forEach<APIIngredients>(ingredients, (ingredient) async {

          if (ingredient != null) {
            print("insertIngredients${ingredient.toJson()}");
            final futureId = await dbHelper.insertIngredient(ingredient);
            ingredient.id = futureId;
            ingredientIds.add(futureId);
          }
        });
        return Future.value(ingredientIds);
      } else {
        return Future.value(<int>[]);
      }
    });
  }

  @override
  Future<void> deleteRecipe(APIRecipe recipe) {
    dbHelper.deleteRecipe(recipe);
    deleteRecipeIngredients(recipe.id ?? 0);
    return Future.value();
  }

  @override
  Future<void> deleteIngredient(APIIngredients ingredient) {
    dbHelper.deleteIngredient(ingredient);
    return Future.value();
  }

  @override
  Future<void> deleteIngredients(List<APIIngredients> ingredients) {
    dbHelper.deleteIngredients(ingredients);
    return Future.value();
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId) {
    dbHelper.deleteRecipeIngredients(recipeId);
    return Future.value();
  }

  @override
  Future init() async {
    await dbHelper.database;
    return Future.value();
  }

  @override
  void close() {
    dbHelper.close();
  }
}
