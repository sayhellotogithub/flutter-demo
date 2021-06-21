import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:open/model/grocery_item_screen.dart';
import 'package:open/model/grocery_manager.dart';
import 'package:open/page/grocery_list_screen.dart';
import 'package:provider/provider.dart';

import 'empty_grocery_screen.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            final manager = Provider.of<GroceryManager>(context, listen: false);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroceryItemScreen(
                          onCreate: (item) {
                            manager.addItem(item);
                            Navigator.pop(context);
                          },
                        )));
          },
        ),
        body: buildGroceryScreen());
  }

  Widget buildGroceryScreen() {
    return Consumer<GroceryManager>(builder: (context, manager, child) {
      if (manager.groceryItems.isNotEmpty) {
        return GroceryListScreen(manager: manager);
      } else {
        return EmptyGroceryScreen();
      }
    });
  }
}
