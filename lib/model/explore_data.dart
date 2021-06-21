import 'explore_recipe.dart';
import 'post.dart';

class ExploreData {
  List<ExploreRecipe>? _recipes;
  List<Post>? _friendPosts;

  List<ExploreRecipe>? get recipes => _recipes;
  List<Post>? get friendPosts => _friendPosts;

  ExploreData(List<ExploreRecipe> recipes, List<Post>? friendPosts) {
    _recipes = recipes;
    _friendPosts = friendPosts;
  }


}
