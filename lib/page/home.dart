import 'package:flutter/material.dart';
import 'package:open/components/app_state_manager.dart';
import 'package:open/components/recipes_screen.dart';
import 'package:provider/provider.dart';

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
    return Consumer<AppStateManager>(builder: (context, stateManager, child) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Fooderlich',
                // 2
                style: Theme.of(context).textTheme.headline6)),
        body: IndexedStack(
          index: stateManager.getSelectedTab,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:
              Theme.of(context).textSelectionTheme.selectionColor,
          currentIndex: stateManager.getSelectedTab,
          onTap: (index) {
            stateManager.goToTab(index);
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
