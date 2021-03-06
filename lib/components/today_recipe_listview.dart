import 'package:flutter/material.dart';
import 'package:open/model/card_type.dart';
import 'package:open/model/models.dart';
import 'package:open/page/explore/card_one.dart';
import 'package:open/page/explore/card_three.dart';
import 'package:open/page/explore/card_two.dart';
import 'package:open/statemanager/recipe_manager.dart';
import 'package:open/theme/fooderlich_theme.dart';
import 'package:provider/provider.dart';

class TodayRecipeListView extends StatelessWidget {
  final List<ExploreRecipe> recipes;

  const TodayRecipeListView({Key? key, required this.recipes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//    return Consumer<RecipeManager>(builder: (context, recipeManager, child) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                Text('Recipes of the Day',
                    style: FooderlichTheme.darkTextTheme.headline1),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Provider.of<RecipeManager>(context, listen: false)
                        .tapOnSearch(true);
//                    ScaffoldMessenger.of(context)
//                        .showSnackBar(SnackBar(content: Text("search click")));
                  },
                )
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 400,
              color: Colors.transparent,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return buildCard(recipe);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 16,
                    );
                  },
                  itemCount: recipes.length),
            )
          ],
        ),
      );
//    });
  }

  Widget buildCard(ExploreRecipe recipe) {
    if (recipe.cardType == CardType.CARD_ONE) {
      return Card1(recipe: recipe);
    } else if (recipe.cardType == CardType.CARD_TWO) {
      return Card2(recipe: recipe);
    } else if (recipe.cardType == CardType.CARD_THREE) {
      return Card3(recipe: recipe);
    } else {
      return Center(
        child: Text("no data"),
      );
    }
  }
}
