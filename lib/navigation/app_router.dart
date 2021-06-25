import 'package:flutter/material.dart';
import 'package:open/components/components.dart';
import 'package:open/data/memory_repository.dart';
import 'package:open/model/fooderlich_pages.dart';
import 'package:open/model/grocery_item_screen.dart';
import 'package:open/page/recipe/search_recipe_screen.dart';
import 'package:open/statemanager/grocery_manager.dart';
import 'package:open/page/home.dart';
import 'package:open/page/login_screen.dart';
import 'package:open/page/onboard.dart';
import 'package:open/page/profile_screen.dart';
import 'package:open/page/splash_screen.dart';
import 'package:open/page/webview_screen.dart';
import 'package:open/statemanager/recipe_manager.dart';

import 'app_link.dart';

class AppRouter extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;

  final GroceryManager groceryManager;

  final ProfileManager profileManager;

  final RecipeManager recipeManager;

  final MemoryRepository memoryRepository;

  AppRouter(
      {required this.appStateManager,
      required this.groceryManager,
      required this.profileManager,
      required this.recipeManager,
      required this.memoryRepository})
      : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
    recipeManager.addListener(notifyListeners);
    memoryRepository.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    recipeManager.removeListener(notifyListeners);
    memoryRepository.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),
        if (groceryManager.isCreatingNewItem)
          GroceryItemScreen.page(
            onCreate: (item) {
              groceryManager.addItem(item);
            },
          ),
        if (groceryManager.selectedIndex != null)
          GroceryItemScreen.page(
            item: groceryManager.selectedGroceryItem,
            onUpdate: (item) {
              groceryManager.updateItem(item, groceryManager.selectedIndex);
            },
          ),
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
        if (recipeManager.didSearchClick) SearchRecipeScreen.page()
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    print("_handlePopPage:$route");
    if (!route.didPop(result)) {
      return false;
    }
    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }
    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemBackNothingChange();
    }
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }
    if (route.settings.name == FooderlichPages.searchRecipePath) {
      recipeManager.tapOnSearch(false);
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(AppLink newLink) async {
    print("setNewRoutePath:$newLink");
    switch (newLink.location) {
      case AppLink.kProfilePath:
        profileManager.tapOnProfile(true);
        break;
      case AppLink.kSearchPath:
        recipeManager.tapOnSearch(true);
        break;
      case AppLink.kItemPath:
        if (newLink.itemId != null) {
          groceryManager.setSelectedGroceryItem(newLink.itemId ?? "");
        } else {
          groceryManager.createNewItem();
        }
        profileManager.tapOnProfile(false);
        break;
      // 8
      case AppLink.kHomePath:
        // 9
        appStateManager.goToTab(newLink.currentTab ?? 0);
        // 10
        profileManager.tapOnProfile(false);
        groceryManager.groceryItemBackNothingChange();
        break;
      // 11
      default:
        break;
    }
  }

  AppLink getCurrentPath() {
    if (!appStateManager.isLoggedIn) {
      return AppLink(location: AppLink.kLoginPath);
    } else if (!appStateManager.isOnboardingComplete) {
      return AppLink(location: AppLink.kOnboardingPath);
    } else if (profileManager.didSelectUser) {
      return AppLink(location: AppLink.kProfilePath);
    } else if (groceryManager.isCreatingNewItem) {
      return AppLink(location: AppLink.kItemPath);
    } else if (groceryManager.selectedGroceryItem != null) {
      final id = groceryManager.selectedGroceryItem?.id ?? "";
      return AppLink(location: AppLink.kItemPath, itemId: id);
    } else if (recipeManager.didSearchClick) {
      return AppLink(location: AppLink.kSearchPath);
    } else {
      return AppLink(
          location: AppLink.kHomePath,
          currentTab: appStateManager.getSelectedTab);
    }
  }

  @override
  get currentConfiguration => getCurrentPath();
}
