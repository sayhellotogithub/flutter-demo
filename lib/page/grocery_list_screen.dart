import 'package:flutter/material.dart';
import 'package:open/components/components.dart';
import 'package:open/model/grocery_item.dart';
import 'package:open/model/grocery_item_screen.dart';
import 'package:open/model/grocery_manager.dart';

class GroceryListScreen extends StatelessWidget {
  final GroceryManager manager;

  const GroceryListScreen({Key? key, required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groceryItems = manager.groceryItems;
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.separated(
          itemBuilder: (context, index) {
            return buildItemWithDismissable(context, index, manager.groceryItems[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 16,
            );
          },
          itemCount: groceryItems.length),
    );
  }

  Widget buildItem(BuildContext context, int index, GroceryItem groceryItem) {
    return InkWell(
      child: GroceryTile(
        item: groceryItem,
        key: Key(groceryItem.id ?? ""),
        onComplete: (change) {
          manager.completeItem(index, change ?? false);
        },
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroceryItemScreen(
                      originalItem: groceryItem,
                      onUpdate: (item) {
                        manager.updateItem(item, index);
                        Navigator.pop(context);
                      },
                    )));
      },
    );
  }

  Widget buildItemWithDismissable(
      BuildContext context, int index, GroceryItem groceryItem) {
    return Dismissible(
      key: Key(groceryItem.id ?? ""),
      child: buildItem(context, index, groceryItem),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 50,
        ),
      ),
      onDismissed: (direction) {
        manager.deleteItem(index);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${groceryItem.name ?? ""}dismissed")));
      },
    );
  }
}
