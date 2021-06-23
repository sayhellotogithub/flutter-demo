import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@JsonSerializable()
class APIRecipeQuery {
  factory APIRecipeQuery.fromJson(Map<String, dynamic> json) =>
      _$APIRecipeQueryFromJson(json);

  Map<String, dynamic> toJson() => _$APIRecipeQueryToJson(this);
  @JsonKey(name: 'q')
  String? query;
  int? from;
  int? to;
  bool? more;
  int? count;
  List<APIHits>? hits;

  APIRecipeQuery({
    this.query,
    this.from,
    this.to,
    this.more,
    this.count,
    this.hits,
  });
}

@JsonSerializable()
class APIHits {
  APIRecipe? recipe;

  APIHits({
     this.recipe,
  });

  factory APIHits.fromJson(Map<String, dynamic> json) =>
      _$APIHitsFromJson(json);

  Map<String, dynamic>? toJson() => _$APIHitsToJson(this);
}

@JsonSerializable()
class APIRecipe {
  String? label;
  String? image;
  String? url;
  List<APIIngredients>? ingredients;
  double? calories;
  double? totalWeight;
  double? totalTime;

  APIRecipe({
    this.label,
    this.image,
    this.url,
    this.ingredients,
    this.calories,
    this.totalWeight,
    this.totalTime,
  });

  factory APIRecipe.fromJson(Map<String, dynamic> json) =>
      _$APIRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$APIRecipeToJson(this);
}

String getCalories(double? calories) {
  if (calories == null) {
    return '0 KCAL';
  }
  return calories.floor().toString() + ' KCAL';
}

String getWeight(double weight) {
  if (weight == null) {
    return '0g';
  }
  return weight.floor().toString() + 'g';
}

@JsonSerializable()
class APIIngredients {
  @JsonKey(name: 'text')
  String? name;
  double? weight;

  APIIngredients({
    this.name,
    this.weight,
  });

  factory APIIngredients.fromJson(Map<String, dynamic> json) =>
      _$APIIngredientsFromJson(json);

  Map<String, dynamic> toJson() => _$APIIngredientsToJson(this);
}
