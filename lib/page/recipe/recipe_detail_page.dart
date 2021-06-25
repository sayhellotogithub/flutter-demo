import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open/const_field/colors.dart';
import 'package:open/network/mock/data/memory_stream_repository.dart';
import 'package:open/network/recipe_model.dart';
import 'package:provider/provider.dart';

class RecipeDetails extends StatelessWidget {
  final APIRecipe recipe;

  const RecipeDetails({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final repository = Provider.of<MemoryStreamRepository>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CachedNetworkImage(
                        imageUrl: recipe.image??"",
                        alignment: Alignment.topLeft,
                        fit: BoxFit.fill,
                        width: size.width,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: shim),
                        child: const BackButton(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    recipe.label??"",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.green),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Chip(
                      label: Text(getCalories(recipe.calories)),
                    )),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                    onPressed: () {
                      repository.insertRecipe(recipe);
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      'assets/fooderlich_assets/icon_bookmark.svg',
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Bookmark',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
