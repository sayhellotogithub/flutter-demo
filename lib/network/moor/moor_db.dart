import 'package:moor_flutter/moor_flutter.dart';
import 'package:open/network/recipe_model.dart';

part 'moor_db.g.dart';

class MoorRecipe extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text()();

  TextColumn get image => text()();

  TextColumn get url => text()();

  RealColumn get calories => real()();

  RealColumn get totalWeight => real()();

  RealColumn get totalTime => real()();
}

class MoorIngredient extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get recipeId => integer()();

  TextColumn get name => text()();

  RealColumn get weight => real()();
}

@UseMoor(tables: [MoorRecipe, MoorIngredient], daos: [RecipeDao, IngredientDao])
class RecipeDatabase extends _$RecipeDatabase {
  RecipeDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'recipes.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [MoorRecipe])
class RecipeDao extends DatabaseAccessor<RecipeDatabase> with _$RecipeDaoMixin {
  // 3
  final RecipeDatabase db;

  RecipeDao(this.db) : super(db);

  // 4
  Future<List<MoorRecipeData>> findAllRecipes() => select(moorRecipe).get();

  // 5
  Stream<List<APIRecipe>> watchAllRecipes() {
    return select(moorRecipe).watch().map((rows) {
      final recipes = <APIRecipe>[];
      rows.forEach((element) {
        final recipe = moorRecipeToRecipe(element);
        if (!recipes.contains(recipe)) {
          recipe.ingredients = <APIIngredients>[];
          recipes.add(recipe);
        }
      });
      return recipes;
    });
  }

  // 6
  Future<List<MoorRecipeData>> findRecipeById(int id) =>
      (select(moorRecipe)..where((tbl) => tbl.id.equals(id))).get();

  // 7
  Future<int> insertRecipe(Insertable<MoorRecipeData> recipe) =>
      into(moorRecipe).insert(recipe);

  // 8
  Future deleteRecipe(int id) => Future.value(
      (delete(moorRecipe)..where((tbl) => tbl.id.equals(id))).go());
}

@UseDao(tables: [MoorIngredient])
class IngredientDao extends DatabaseAccessor<RecipeDatabase>
    with _$IngredientDaoMixin {
  final RecipeDatabase db;

  IngredientDao(this.db) : super(db);

  Future<List<MoorIngredientData>> findAllIngredients() =>
      select(moorIngredient).get();

  // 3
  Stream<List<MoorIngredientData>> watchAllIngredients() =>
      select(moorIngredient).watch();

  // 4
  Future<List<MoorIngredientData>> findRecipeIngredients(int id) =>
      (select(moorIngredient)..where((tbl) => tbl.recipeId.equals(id))).get();

  // 5
  Future<int> insertIngredient(Insertable<MoorIngredientData> ingredient) =>
      into(moorIngredient).insert(ingredient);

  // 6
  Future deleteIngredient(int id) => Future.value(
      (delete(moorIngredient)..where((tbl) => tbl.id.equals(id))).go());
}

// Conversion Methods
APIRecipe moorRecipeToRecipe(MoorRecipeData recipe) {
  return APIRecipe(
      id: recipe.id,
      label: recipe.label,
      image: recipe.image,
      url: recipe.url,
      calories: recipe.calories,
      totalWeight: recipe.totalWeight,
      totalTime: recipe.totalTime);
}

Insertable<MoorRecipeData> recipeToInsertableMoorRecipe(APIRecipe recipe) {
  return MoorRecipeCompanion.insert(
      label: recipe.label ?? "",
      image: recipe.image ?? "",
      url: recipe.url ?? "",
      calories: recipe.calories ?? 0,
      totalWeight: recipe.totalWeight ?? 0,
      totalTime: recipe.totalTime ?? 0);
}

APIIngredients moorIngredientToIngredient(MoorIngredientData ingredient) {
  return APIIngredients(
      id: ingredient.id,
      recipeId: ingredient.recipeId,
      name: ingredient.name,
      weight: ingredient.weight);
}

MoorIngredientCompanion? ingredientToInsertableMoorIngredient(
    APIIngredients? ingredient) {
  if (ingredient == null) {
    return null;
  }
  return MoorIngredientCompanion.insert(
      recipeId: ingredient.recipeId ?? 0,
      name: ingredient.name ?? "",
      weight: ingredient.weight ?? 0);
}
