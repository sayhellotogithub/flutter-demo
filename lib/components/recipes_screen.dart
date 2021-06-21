import 'package:flutter/material.dart';
import 'package:open/api/MockFooderlichService.dart';
import 'package:open/model/models.dart';

import 'recipes_grid_view.dart';

class RecipesScreen extends StatelessWidget {
  final exploreService = MockFooderlichService();

  RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SimpleRecipe>>(
        future: exploreService.getRecipes(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return RecipesGridView(
              recipes: snap.data ?? [],
            );
          }
          return CircularProgressIndicator();
        });
  }
}
