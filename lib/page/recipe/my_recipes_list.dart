import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:open/network/mock/data/stream_repository.dart';
import 'package:open/network/recipe_model.dart';
import 'package:open/page/recipe/ingredient_list.dart';
import 'package:provider/provider.dart';

class MyRecipesList extends StatefulWidget {
  const MyRecipesList({Key? key}) : super(key: key);

  @override
  _MyRecipesListState createState() => _MyRecipesListState();
}

class _MyRecipesListState extends State<MyRecipesList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildRecipeList(context),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    final repository = Provider.of<StreamRepository>(context);
    return StreamBuilder<List<APIRecipe>>(
      stream: repository.watchAllRecipes(),
      builder: (context, AsyncSnapshot<List<APIRecipe>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final recipes = snapshot.data ?? [];
          return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (BuildContext context, int index) {
                final recipe = recipes[index];
                return SizedBox(
                  height: 100,
                  child: Slidable(
                    actionPane: const SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.grey,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return IngredientList(recipe: recipe);
                            },
                          ));
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                  imageUrl: recipe.image ?? "",
                                  height: 120,
                                  width: 60,
                                  fit: BoxFit.cover),
                              title: Text(recipe.label ?? ""),
                            ),
                          ),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                          caption: 'Delete',
                          color: Colors.transparent,
                          foregroundColor: Colors.black,
                          iconWidget:
                              const Icon(Icons.delete, color: Colors.red),
                          onTap: () => deleteRecipe(repository, recipe)),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                          caption: 'Delete',
                          color: Colors.transparent,
                          foregroundColor: Colors.black,
                          iconWidget:
                              const Icon(Icons.delete, color: Colors.red),
                          onTap: () => deleteRecipe(repository, recipe)),
                    ],
                  ),
                );
              });
        } else {
          return Container();
        }
      },
    );
  }

  void deleteRecipe(StreamRepository repository, APIRecipe recipe) async {
    repository.deleteRecipe(recipe);
    setState(() {});
  }
}
