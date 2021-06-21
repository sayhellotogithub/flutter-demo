import 'package:flutter/material.dart';
import 'package:open/model/grocery_manager.dart';
import 'components/components.dart';
import 'navigation/app_router.dart';

void main() {
  runApp( const MyApp());
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

  @override
  void initState() {
    _appRouter = AppRouter(
        appStateManager: _appStateManager,
        groceryManager: _groceryManager,
        profileManager: _profileManager);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Router(
        routerDelegate: _appRouter,
      ),
    );
  }
}
