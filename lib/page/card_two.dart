import 'package:flutter/material.dart';
import 'package:open/components/author_card.dart';
import 'package:open/model/models.dart';

import '../theme/fooderlich_theme.dart';

class Card2 extends StatelessWidget {
  final ExploreRecipe recipe;

  const Card2({Key? key, required this.recipe}) : super(key: key);

  // 2
  @override
  Widget build(BuildContext context) {
    // 3
    return Center(
      child: Container(
        child: Column(
          children: [
             AuthorCard(
                title: recipe.title??"",
                author: recipe.authorName??"",
                imageProvider:
                    AssetImage("assets/profile_pics/person_katz.jpeg")),
            Expanded(
                child: Stack(
              children: [
                Positioned(
                  child: Text(
                    "Recipe",
                    style: FooderlichTheme.lightTextTheme.headline1,
                  ),
                  bottom: 16,
                  right: 16,
                ),
                Positioned(
                  bottom: 70,
                  left: 16,
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        "Smoothies",
                        style: FooderlichTheme.lightTextTheme.headline1,
                      )),
                )
              ],
            ))
          ],
        ),
        // 1
//        padding: const EdgeInsets.all(16),
        // 2
        constraints: const BoxConstraints.expand(width: 350, height: 450),
        // 3
        decoration: const BoxDecoration(
          // 4
          image: DecorationImage(
            // 5
            image: AssetImage('assets/magazine_pics/mag5.png'),
            // 6
            fit: BoxFit.cover,
          ),
          // 7
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
