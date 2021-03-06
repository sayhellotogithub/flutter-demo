import 'package:flutter/material.dart';
import 'package:open/page/recipe/my_recipes_list.dart';
import 'package:open/statemanager/app_state_manager.dart';
import 'package:open/components/components.dart';
import 'package:open/components/recipes_screen.dart';
import 'package:open/model/fooderlich_pages.dart';
import 'package:provider/provider.dart';

import 'explore/explore_screen.dart';
import 'buy/grocery_screen.dart';

class Home extends StatefulWidget {
  final int currentTab;

  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: FooderlichPages.home,
      key: ValueKey(FooderlichPages.home),
      child: Home(
        currentTab: currentTab,
      ),
    );
  }

  const Home({Key? key, required this.currentTab}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = <Widget>[
    ExploreScreen(),
    RecipesScreen(),
    GroceryScreen(),
    MyRecipesList()
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
          index: widget.currentTab,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:
              Colors.white,
          currentIndex: widget.currentTab,
          onTap: (index) {
            Provider.of<AppStateManager>(context, listen: false).goToTab(index);
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "explore"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.book), label: "Recipes"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.list), label: "To Buy"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "BookMark"),
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
