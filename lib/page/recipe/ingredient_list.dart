import 'package:flutter/material.dart';
import 'package:open/network/mock/data/stream_repository.dart';
import 'package:open/network/recipe_model.dart';
import 'package:provider/provider.dart';

class IngredientList extends StatelessWidget {
  final APIRecipe recipe;

  const IngredientList({Key? key, required this.recipe}) : super(key: key);

  void getData(BuildContext context) async {
    var data = await Provider.of<StreamRepository>(context)
        .findRecipeIngredients(recipe.id ?? 0);
    print("id:${recipe.id}");
    print(data[0].toJson());
  }

  @override
  Widget build(BuildContext context) {
    getData(context);

    return FutureBuilder<List<APIIngredients>>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final ingredients = snapshot.data ?? [];

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
        } else {
          return Container();
        }
      },
      future: Provider.of<StreamRepository>(context)
          .findRecipeIngredients(recipe.id ?? 0),
    );
  }
}
