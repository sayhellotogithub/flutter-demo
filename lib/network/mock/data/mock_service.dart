import 'dart:convert';
import 'dart:math';

import 'package:chopper/chopper.dart';
import 'package:flutter/services.dart';
import 'package:open/network/model_response.dart';
import 'package:open/network/recipe_model.dart';
import 'package:http/http.dart' as model;
import 'package:open/network/service_interface.dart';

class MockService implements ServiceInterface{
  APIRecipeQuery? _currentRecipes1;
  APIRecipeQuery? _currentRecipes2;
  Random nextRecipe = Random();

  void create() {
    loadRecipes();
  }

  void loadRecipes() async {
    var jsonString = await rootBundle.loadString('assets/recipes1.json');
    _currentRecipes1 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
    jsonString = await rootBundle.loadString('assets/recipes2.json');
    _currentRecipes2 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
  }
  @override
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      String query, int from, int to) {
    model.BaseResponse baseResponse = model.Response("", 200);
    switch (nextRecipe.nextInt(2)) {
      case 0:
        return Future.value(
            Response(baseResponse, Success<APIRecipeQuery>(_currentRecipes1!)));
      case 1:
        return Future.value(
            Response(baseResponse, Success<APIRecipeQuery>(_currentRecipes2!)));
      default:
        return Future.value(
            Response(baseResponse, Success<APIRecipeQuery>(_currentRecipes1!)));
    }
  }
}
