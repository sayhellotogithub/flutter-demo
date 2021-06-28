import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:open/network/mock/data/memory_stream_repository.dart';
import 'package:open/network/mock/data/stream_repository.dart';
import 'package:open/network/sqlite/sqlite_repository.dart';
import 'package:open/statemanager/grocery_manager.dart';
import 'package:provider/provider.dart';
import 'components/components.dart';
import 'navigation/app_route_parser.dart';
import 'navigation/app_router.dart';
import 'network/mock/data/memory_repository.dart';
import 'network/recipe_service.dart';
import 'network/service_interface.dart';
import 'statemanager/recipe_manager.dart';
import 'theme/fooderlich_theme.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

void main() {
  configureApp();
  _setupLogging();
  runApp(const MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    print('${event.level.name}: ${event.time}: ${event.message}');
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  late AppRouter _appRouter;
  final _appStateManager = AppStateManager();
  final _groceryManager = GroceryManager();
  final _profileManager = ProfileManager();
  final _recipeManager = RecipeManager();
  final routeParser = AppRouteParser();

//  final _memoryRepository = MemoryRepository();
  final _memoryStreamRepository = SqliteRepository();

  @override
  void initState() {
    _appRouter = AppRouter(
        appStateManager: _appStateManager,
        groceryManager: _groceryManager,
        profileManager: _profileManager,
        recipeManager: _recipeManager);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _appStateManager),
        ChangeNotifierProvider(create: (context) => _groceryManager),
        ChangeNotifierProvider(create: (context) => _profileManager),
        ChangeNotifierProvider(create: (context) => _recipeManager),
//        ChangeNotifierProvider(create: (context) => _memoryRepository),
        Provider<StreamRepository>(
          create: (_) => _memoryStreamRepository,
          dispose: (_, StreamRepository repository) => repository.close(),
        ),
        Provider<ServiceInterface>(
          create: (_) => RecipeService.create(),
        )
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = FooderlichTheme.dark();
          } else {
            theme = FooderlichTheme.light();
          }
          return MaterialApp.router(
            theme: theme,
            title: "title",
            backButtonDispatcher: RootBackButtonDispatcher(),
            routeInformationParser: routeParser,
            routerDelegate: _appRouter,
          );
        },
      ),
    );
  }
}
