import 'package:flutter/material.dart';
import 'package:open/components/recipes_screen.dart';
import 'package:open/model/models.dart';
import 'package:provider/provider.dart';

import 'card_one.dart';
import 'card_three.dart';
import 'card_two.dart';
import 'explore_screen.dart';
import 'grocery_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = <Widget>[
    ExploreScreen(),
    RecipesScreen(),
    GroceryScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TabManager>(builder: (context, tabManager, child) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Fooderlich',
                // 2
                style: Theme.of(context).textTheme.headline6)),
        body: IndexedStack(
          index: tabManager.selectedTab,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:
              Theme.of(context).textSelectionTheme.selectionColor,
          currentIndex: tabManager.selectedTab,
          onTap: (index) {
            tabManager.gotoTab(index);
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "explore"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.book), label: "Recipes"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.list), label: "To Buy")
          ],
        ),
      );
    });
  }
}
