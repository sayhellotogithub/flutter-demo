import 'dart:convert';

import 'package:open/network/mock/data/stream_repository.dart';
import 'package:open/network/moor/moor_db.dart';
import 'package:open/network/recipe_model.dart';

class MoorRepository extends StreamRepository {
  late RecipeDatabase recipeDatabase;
  late RecipeDao recipeDao;
  late IngredientDao ingredientDao;

  Stream<List<APIRecipe>>? recipeStream;
  Stream<List<APIIngredients>>? ingredientStream;

  @override
  Future init() {
    recipeDatabase = RecipeDatabase();
    recipeDao = recipeDatabase.recipeDao;
    ingredientDao = recipeDatabase.ingredientDao;
    return Future.value();
  }

  @override
  void close() {
    recipeDatabase.close();
  }

  @override
  Future<void> deleteRecipe(APIRecipe recipe) {
    recipeDao.deleteRecipe(recipe.id ?? 0);
    return Future.value();
  }

  @override
  Future<List<APIRecipe>> findAllRecipes() {
    return recipeDao
        .findAllRecipes()
        .then<List<APIRecipe>>((List<MoorRecipeData> moorRecipes) {
      final recpies = <APIRecipe>[];
      moorRecipes.forEach((element) async {
        final recipe = moorRecipeToRecipe(element);
        recipe.ingredients = await findRecipeIngredients(recipe.id ?? 0);
        recpies.add(recipe);
      });
      return recpies;
    });
  }

  @override
  Future<APIRecipe> findRecipeById(int id) {
    return recipeDao
        .findRecipeById(id)
        .then((value) => moorRecipeToRecipe(value.first));
  }

  @override
  Future<List<APIIngredients>> findRecipeIngredients(int id) {
    return ingredientDao.findRecipeIngredients(id).then((value) {
      final ingredients = <APIIngredients>[];
      value.forEach((element) {
        final ingredient = moorIngredientToIngredient(element);
        ingredients.add(ingredient);
      });
      return ingredients;
    });
  }

  @override
  Future<int> insertRecipe(APIRecipe recipe) {
    return Future(() async {
      final id =
          await recipeDao.insertRecipe(recipeToInsertableMoorRecipe(recipe));
      recipe.ingredients?.forEach((element) {
        element.recipeId = id;
      });

      insertIngredients(recipe.ingredients);
      return id;
    });
  }

  Future<List<int>> insertIngredients(List<APIIngredients>? ingredients) {
    return Future(() {
      if (ingredients == null || ingredients.length == 0) {
        return <int>[];
      }
      final resultIds = <int>[];
      ingredients.forEach((ingredient) {
        final moorIngredient = ingredientToInsertableMoorIngredient(ingredient);
        if (moorIngredient != null) {
          ingredientDao
              .insertIngredient(moorIngredient)
              .then((int id) => resultIds.add(id));
        }
      });
      return resultIds;
    });
  }

  @override
  Stream<List<APIRecipe>> watchAllRecipes() {
    if (recipeStream == null) {
      recipeStream = recipeDao.watchAllRecipes();
    }
    return recipeStream!;
  }

  Stream<List<APIIngredients>> watchAllIngredients() {
    if (ingredientStream == null) {
      // 1
      final stream = ingredientDao.watchAllIngredients();
      // 2
      ingredientStream = stream.map((moorIngredients) {
        final ingredients = <APIIngredients>[];
        // 3
        moorIngredients.forEach((moorIngredient) {
          ingredients.add(moorIngredientToIngredient(moorIngredient));
        });
        return ingredients;
      });
    }
    return ingredientStream!;
  }
}
