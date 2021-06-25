

import 'package:open/network/recipe_model.dart';

abstract class Repository {
  List<APIRecipe> findAllRecipes();

  APIRecipe findRecipeById(int id);

  int insertRecipe(APIRecipe recipe);


  void deleteRecipe(APIRecipe recipe);

  Future init();

  void close();
}
