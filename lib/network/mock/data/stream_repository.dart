import 'package:open/network/recipe_model.dart';

abstract class StreamRepository {
  Future init();

  void close();

  Future<List<APIRecipe>> findAllRecipes();

  Future<APIRecipe> findRecipeById(int id);

  Future<int> insertRecipe(APIRecipe recipe);

  Future<void> deleteRecipe(APIRecipe recipe);
  Future<List<APIIngredients>> findRecipeIngredients(int id);
  Stream<List<APIRecipe>> watchAllRecipes();

}
