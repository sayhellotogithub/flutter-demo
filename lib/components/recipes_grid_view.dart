import 'package:flutter/material.dart';
import 'package:open/model/models.dart';

import 'recipe_thumbnail.dart';

class RecipesGridView extends StatelessWidget {
  // 1
  final List<SimpleRecipe> recipes;

  const RecipesGridView({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 500),
        itemBuilder: (context, index) {
          return RecipeThumbnail(
            recipe: recipes[index],
          );
        },
        itemCount: recipes.length,
      ),
    );
  }
}
