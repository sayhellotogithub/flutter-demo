import 'package:chopper/chopper.dart';
import 'package:open/network/recipe_model.dart';

import 'model_response.dart';

abstract class ServiceInterface {
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      String query, int from, int to);
}