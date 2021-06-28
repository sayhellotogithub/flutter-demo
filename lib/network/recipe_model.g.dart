// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIRecipeQuery _$APIRecipeQueryFromJson(Map<String, dynamic> json) {
  return APIRecipeQuery(
    query: json['q'] as String?,
    from: json['from'] as int?,
    to: json['to'] as int?,
    more: json['more'] as bool?,
    count: json['count'] as int?,
    hits: (json['hits'] as List<dynamic>?)
        ?.map((e) => APIHits.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$APIRecipeQueryToJson(APIRecipeQuery instance) =>
    <String, dynamic>{
      'q': instance.query,
      'from': instance.from,
      'to': instance.to,
      'more': instance.more,
      'count': instance.count,
      'hits': instance.hits,
    };

APIHits _$APIHitsFromJson(Map<String, dynamic> json) {
  return APIHits(
    recipe: json['recipe'] == null
        ? null
        : APIRecipe.fromJson(json['recipe'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$APIHitsToJson(APIHits instance) => <String, dynamic>{
      'recipe': instance.recipe,
    };

APIRecipe _$APIRecipeFromJson(Map<String, dynamic> json) {
  return APIRecipe(
    id: json['id'] as int?,
    label: json['label'] as String?,
    image: json['image'] as String?,
    url: json['url'] as String?,
    ingredients: (json['ingredients'] as List<dynamic>?)
        ?.map((e) => APIIngredients.fromJson(e as Map<String, dynamic>))
        .toList(),
    calories: (json['calories'] as num?)?.toDouble(),
    totalWeight: (json['totalWeight'] as num?)?.toDouble(),
    totalTime: (json['totalTime'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$APIRecipeToJson(APIRecipe instance) => <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'image': instance.image,
      'url': instance.url,
      'ingredients': instance.ingredients,
      'calories': instance.calories,
      'totalWeight': instance.totalWeight,
      'totalTime': instance.totalTime,
    };

APIIngredients _$APIIngredientsFromJson(Map<String, dynamic> json) {
  return APIIngredients(
    recipeId: json['recipeId'] as int?,
    name: json['text'] as String?,
    weight: (json['weight'] as num?)?.toDouble(),
    id: json['id'] as int?,
  );
}

Map<String, dynamic> _$APIIngredientsToJson(APIIngredients instance) =>
    <String, dynamic>{
      'text': instance.name,
      'id': instance.id,
      'weight': instance.weight,
      'recipeId': instance.recipeId,
    };
