import 'package:flutter/material.dart';
import 'package:open/components/app_state_manager.dart';
import 'package:open/components/components.dart';
import 'package:open/components/recipes_screen.dart';
import 'package:open/model/fooderlich_pages.dart';
import 'package:provider/provider.dart';

import 'explore_screen.dart';
import 'grocery_screen.dart';

class Home extends StatefulWidget {
  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: FooderlichPages.home,
      key: ValueKey(FooderlichPages.home),
      child: Home(),
    );
  }

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
              style: Theme.of(context).textTheme.headline6),
          actions: [profileButton()],
        ),
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

  Widget profileButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/profile_pics/person_stef.jpeg'),
        ),
        onTap: () {
          Provider.of<ProfileManager>(context, listen: false)
              .tapOnProfile(true);
        },
      ),
    );
  }
}
