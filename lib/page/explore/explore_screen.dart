import 'package:flutter/material.dart';
import 'package:open/api/MockFooderlichService.dart';
import 'package:open/components/components.dart';
import 'package:open/components/today_recipe_listview.dart';
import 'package:open/model/models.dart';

class ExploreScreen extends StatefulWidget {
  ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() {
    return _ExploreScreenState();
  }
}

class _ExploreScreenState extends State<ExploreScreen> {
  final mockService = MockFooderlichService();
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print('i am at the bottom!');
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      print('i am at the top!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExploreData>(
        future: mockService.getExploreData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var recipes = snapshot.data?.recipes;
            return ListView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              children: [
                TodayRecipeListView(
                  recipes: recipes ?? [],
                ),
                const SizedBox(
                  height: 16,
                ),
                FriendPostListView(
                  friendPost: snapshot.data?.friendPosts ?? [],
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
