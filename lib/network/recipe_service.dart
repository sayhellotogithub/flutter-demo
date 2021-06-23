
import 'package:http/http.dart';

const String apiKey = '396a0792d98b7f205e985d81711a40d1';
const String apiId = 'faed1095';
const String apiUrl = 'https://api.edamam.com/api/recipes/v2';
//https://api.edamam.com/api/recipes/v2?type=public&q=go&app_id=faed1095&app_key=396a0792d98b7f205e985d81711a40d1

class RecipeService {
  Future<dynamic> getRecipes(String query, int from, int to) async {
    final recipeData = await getData(
        '$apiUrl?type=public&app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
    return recipeData;
  }

  Future getData(String httpurl) async {
    print('Calling uri: $httpurl');
    Uri url = Uri.parse(httpurl);
    final response = await get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
    }
  }
}
