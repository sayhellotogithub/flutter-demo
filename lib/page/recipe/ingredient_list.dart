import 'package:flutter/material.dart';
import 'package:open/data/memory_repository.dart';
import 'package:open/network/recipe_model.dart';
import 'package:provider/provider.dart';

class IngredientList extends StatelessWidget {
  final APIRecipe recipe;

  const IngredientList({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryRepository>(builder: (context, repository, child) {
      final ingredients = recipe.ingredients ?? [];
      return Scaffold(
          appBar: AppBar(
            title: Text("ingredient list"),
          ),
          body: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: CheckboxListTile(
                  value: false,
                  title: Text(ingredients[index].name ?? ""),
                  onChanged: (newValue) {},
                ));
              }));
    });
  }
}
