import 'dart:convert';
import 'dart:math';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:open/components/custom_dropdown.dart';
import 'package:open/components/recipe.dart';
import 'package:open/model/fooderlich_pages.dart';
import 'package:open/network/model_response.dart';
import 'package:open/network/recipe_model.dart';
import 'package:open/network/recipe_service.dart';
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
  List<APIHits> currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];

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
  }

//  Future<APIRecipeQuery> getRecipeData(String query, int from, int to) async {
//    final recipeJson = await RecipeService().getRecipes(query, from, to);
//    print(recipeJson);
//    final recipeMap = jsonDecode(recipeJson);
//    return APIRecipeQuery.fromJson(recipeMap);
//  }

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
                        savePreviousSearches();
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
    if (recipe == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return RecipeDetails(
              recipe: recipe,
            );
          },
        ));
      },
      // 2
      child: recipeCard(recipe),
    );
  }

  Widget _buildRecipeList(BuildContext recipeListContext, List<APIHits> hits) {
    // 2
    final size = MediaQuery.of(context).size;
    const itemHeight = 310;
    final itemWidth = size.width / 2;
    // 3
    return Flexible(
      // 4
      child: GridView.builder(
        // 5
        controller: _scrollController,
        // 6
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        // 7
        itemCount: hits.length,
        // 8
        itemBuilder: (BuildContext context, int index) {
          return _buildRecipeCard(recipeListContext, hits, index);
        },
      ),
    );
  }

  Widget _buildRecipeLoader(BuildContext context) {
    if (searchTextController.text.length < 3) {
      return Container();
    }
    return FutureBuilder<Response<Result<APIRecipeQuery>>>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }
          loading = false;

          final result = snapshot.data?.body;
          if (result is Error) {
            inErrorState = true;
            return _buildRecipeList(context, currentSearchList);
          }

          final query = (result as Success).value;
          print("query:$query");

          if (query != null) {
            currentCount = query.count ?? 0;
            hasMore = query.more ?? false;
            currentSearchList.addAll(query.hits ?? []);

            var to = query.to ?? 0;
            if (to < currentEndPosition) {
              currentEndPosition = to;
            }
          }
          return _buildRecipeList(context, currentSearchList);
        } else {
          if (currentCount == 0) {
            // Show a loading indicator while waiting for the movies
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildRecipeList(context, currentSearchList);
          }
        }
      },
      future: RecipeService.create().queryRecipes(
          searchTextController.text.trim(),
          currentStartPosition,
          currentEndPosition),
    );
  }
}
