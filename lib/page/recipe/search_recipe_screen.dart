import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open/api/MockFooderlichService.dart';
import 'package:open/components/custom_dropdown.dart';
import 'package:open/components/recipe.dart';
import 'package:open/model/fooderlich_pages.dart';
import 'package:open/network/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recipe_detail_page.dart';

class SearchRecipeScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
        key: ValueKey(FooderlichPages.searchRecipePath),
        name: FooderlichPages.searchRecipePath,
        child: SearchRecipeScreen());
  }

  const SearchRecipeScreen({Key? key}) : super(key: key);

  @override
  _SearchRecipeScreenState createState() {
    return _SearchRecipeScreenState();
  }
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  static const String prefSearchKey = 'previousSearches';

  late TextEditingController searchTextController;
  final _scrollController = ScrollController();
  List currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];
  final exploreService = MockFooderlichService();
  late APIRecipeQuery? _currentRecipes1 = null;

  @override
  void initState() {
    super.initState();
    getPreviousSearchers();

    searchTextController = TextEditingController(text: '');
    _scrollController
      ..addListener(() {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (hasMore &&
              currentEndPosition < currentCount &&
              !loading &&
              !inErrorState) {
            setState(() {
              loading = true;
              currentStartPosition = currentEndPosition;
              currentEndPosition =
                  min(currentStartPosition + pageCount, currentCount);
            });
          }
        }
      });
    loadRecipes();
  }

  void loadRecipes() async {
    _currentRecipes1 = await exploreService.loadRecipes();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void savePreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void getPreviousSearchers() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefSearchKey)) {
      previousSearches = prefs.getStringList(prefSearchKey) ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _buildSearchCard(),
                _buildRecipeLoader(context),
              ],
            ),
          ),
        ));
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            // Replace
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  startSearch(searchTextController.text);
                  final currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                }),
            const SizedBox(
              width: 6.0,
            ),
            Expanded(
              child: TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Search'),
                  autofocus: false,
                  controller: searchTextController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    if (!previousSearches.contains(value)) {
                      previousSearches.add(value);
                      savePreviousSearches();
                    }
                  }),
            ),
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return previousSearches
                    .map<CustomDropdownMenuItem<String>>((String value) {
                  return CustomDropdownMenuItem(
                    text: value,
                    value: value,
                    callback: () {
                      setState(() {
                        previousSearches.remove(value);
                        Navigator.pop(context);
                      });
                    },
                  );
                }).toList();
              },
              icon: const Icon(Icons.arrow_drop_down),
              color: Colors.white,
              onSelected: (String value) {
                searchTextController.text = value;
                startSearch(searchTextController.text);
              },
            )
          ],
        ),
      ),
    );
  }

  void startSearch(String value) {
    setState(() {
      currentSearchList.clear();
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = true;
      if (!previousSearches.contains(value)) {
        if (value.isNotEmpty) {
          previousSearches.add(value);
          savePreviousSearches();
        }
      }
    });
  }

  Widget _buildRecipeCard(BuildContext context, List<APIHits> hits, int index) {
    // 1
    final recipe = hits[index].recipe;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const RecipeDetails();
          },
        ));
      },
      // 2
      child: recipeStringCard(recipe.image, recipe.label),
    );
  }

  Widget _buildRecipeLoader(BuildContext context) {
    // 1
    if (_currentRecipes1 == null || _currentRecipes1!.hits == null) {
      return Container();
    }
    // Show a loading indicator while waiting for the recipes
    return Center(
      // 2
      child: _buildRecipeCard(context, _currentRecipes1!.hits, 0),
    );
  }
}
