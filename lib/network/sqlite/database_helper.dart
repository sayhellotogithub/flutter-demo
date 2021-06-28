import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';

import '../recipe_model.dart';

class DatabaseHelper {
  static const _databaseName = 'MyDatabase.db';
  static const _databaseVersion = 1;

  static const recipeTable = 'Recipe';
  static const ingredientTable = 'Ingredient';
  static const columnId = '_id';

  static BriteDatabase? _streamDatabase;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static var lock = Lock();

  // only have a single app-wide reference to the database
  static Database? _database;

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $recipeTable (
            _id INTEGER PRIMARY KEY,
            label TEXT,
            image TEXT,
            url TEXT,
            calories REAL,
            totalWeight REAL,
            totalTime REAL
          )
          ''');
    await db.execute('''
          CREATE TABLE $ingredientTable (
            _id INTEGER PRIMARY KEY,
            recipeId INTEGER,
            name TEXT,
            weight REAL
          )
          ''');
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    Sqflite.setDebugModeOn(true);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Use this object to prevent concurrent access to data
    await lock.synchronized(() async {
      // lazily instantiate the db the first time it is accessed
      if (_database == null) {
        _database = await _initDatabase();

        _streamDatabase = BriteDatabase(_database!, logger: recordLogger);
      }
    });
    return _database!;
  }

  static void recordLogger(String msg) {
    print(msg);
  }

  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase!;
  }

  List<APIRecipe> parseRecipes(List<Map<String, dynamic>> recipeList) {
    final recipes = <APIRecipe>[];
    recipeList.forEach((recipeMap) {
      final recipe = APIRecipe.fromJson(recipeMap);
      recipes.add(recipe);
    });
    return recipes;
  }

  List<APIIngredients> parseIngredients(
      List<Map<String, dynamic>> ingredientList) {
    final ingredients = <APIIngredients>[];
    ingredientList.forEach((ingredientMap) {
      final ingredient = APIIngredients.fromJsonForSqlite(ingredientMap);
      ingredients.add(ingredient);
    });
    return ingredients;
  }

  Future<List<APIRecipe>> findAllRecipes() async {
    final db = await instance.streamDatabase;
    final recipeList = await db.query(recipeTable);
    final recipes = parseRecipes(recipeList);
    return recipes;
  }

  Stream<List<APIRecipe>> watchAllRecipes() async* {
    final db = await instance.streamDatabase;
    yield* db
        .createQuery(recipeTable)
        .mapToList((row) => APIRecipe.fromJson(row));
  }

  Stream<List<APIIngredients>> watchAllIngredients() async* {
    final db = await instance.streamDatabase;
    yield* db
        .createQuery(ingredientTable)
        .mapToList((row) => APIIngredients.fromJson(row));
  }

  Future<APIRecipe> findRecipeById(int id) async {
    final db = await instance.streamDatabase;
    final recipeList = await db.query(recipeTable, where: 'id = $id');
    final recipes = parseRecipes(recipeList);
    return recipes.first;
  }

  Future<List<APIIngredients>> findAllIngredients() async {
    final db = await instance.streamDatabase;
    final ingredientList = await db.query(ingredientTable);
    final ingredients = parseIngredients(ingredientList);
    return ingredients;
  }

  Future<List<APIIngredients>> findRecipeIngredients(int recipeId) async {
    final db = await instance.streamDatabase;
    final ingredientList =
        await db.query(ingredientTable, where: 'recipeId = $recipeId');
    final ingredients = parseIngredients(ingredientList);
    return ingredients;
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    return db.insert(table, row);
  }

  Future<int> insertRecipe(APIRecipe recipe) {
    return insert(recipeTable, recipe.toJson());
  }

  Future<int> insertIngredient(APIIngredients ingredient) {
    return insert(ingredientTable, ingredient.toJson());
  }

  Future<int> _delete(String table, int id) async {
    final db = await instance.streamDatabase;
    return db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteRecipe(APIRecipe recipe) async {
    return _delete(recipeTable, recipe.id ?? 0);
  }

  Future<int> deleteIngredient(APIIngredients ingredient) async {
    return _delete(ingredientTable, ingredient.id ?? 0);
  }

  Future<void> deleteIngredients(List<APIIngredients> ingredients) {
    if (ingredients != null) {
      ingredients.forEach((ingredient) {
        if (ingredient != null) {
          _delete(DatabaseHelper.ingredientTable, ingredient.id ?? 0);
        }
      });
    }
    return Future.value();
  }

  Future<int> deleteRecipeIngredients(int recipeId) async {
    final db = await instance.streamDatabase;
    return db
        .delete(ingredientTable, where: 'recipeId = ?', whereArgs: [recipeId]);
  }

  void close() {
    _streamDatabase?.close();
  }
}
