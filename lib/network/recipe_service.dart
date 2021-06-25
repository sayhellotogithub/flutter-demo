import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:open/network/service_interface.dart';

import 'model_converter.dart';
import 'model_response.dart';
import 'recipe_model.dart';

const String apiKey = '396a0792d98b7f205e985d81711a40d1';
const String apiId = 'faed1095';
//const String apiUrl = 'https://api.edamam.com/api/recipes/v2';
const String apiUrl = 'https://api.edamam.com';

//https://api.edamam.com/api/recipes/v2?type=public&q=go&app_id=faed1095&app_key=396a0792d98b7f205e985d81711a40d1
@ChopperApi()
abstract class RecipeService extends ChopperService implements ServiceInterface {
  @Get(path: 'api/recipes/v2')
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      @Query('q') String query, @Query('from') int from, @Query('to') int to);

  static RecipeService create() {
    // 1
    final client = ChopperClient(
      // 2
      baseUrl: apiUrl,
      // 3
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      // 4
      converter: ModelConverter(),
      // 5
      errorConverter: const JsonConverter(),
      // 6
      services: [RecipeServiceImpl()],
    );
    // 7
    return RecipeServiceImpl(client);
  }
}

class RecipeServiceImpl extends RecipeService {
  RecipeServiceImpl([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = RecipeService;


  @override
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      String query, int from, int to) {
    final $url = 'api/recipes/v2';
    final $params = <String, dynamic>{'q': query, 'from': from, 'to': to};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<Result<APIRecipeQuery>, APIRecipeQuery>($request);
  }
}

Request _addQuery(Request req) {
  final params = Map<String, dynamic>.from(req.parameters);
  params['app_id'] = apiId;
  params['app_key'] = apiKey;
  params["type"] = "public";
  return req.copyWith(parameters: params);
}

//class RecipeService {
//  Future<dynamic> getRecipes(String query, int from, int to) async {
//    final recipeData = await getData(
//        '$apiUrl?type=public&app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
//    return recipeData;
//  }
//
//  Future getData(String httpurl) async {
//    print('Calling uri: $httpurl');
//    Uri url = Uri.parse(httpurl);
//    final response = await get(url);
//    if (response.statusCode == 200) {
//      return response.body;
//    } else {
//      print(response.statusCode);
//    }
//  }
//}
