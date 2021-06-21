

/// dishImage : "assets/food_pics/food_salmon.jpg"
/// title : "Smoked Salmon"
/// duration : "30 mins"
/// source : "https://pixabay.com/photos/salmon-dish-food-meal-fish-518032/"
/// information : ["Course: Main Course","Price: Cheap","Cuisine: Meditarrian","Skill Level: Beginner","Prep Time 5 minutes"]

class SimpleRecipe {
  String? _dishImage;
  String? _title;
  String? _duration;
  String? _source;
  List<String>? _information;

  String? get dishImage => _dishImage;
  String? get title => _title;
  String? get duration => _duration;
  String? get source => _source;
  List<String>? get information => _information;

  SimpleRecipe({
      String? dishImage, 
      String? title, 
      String? duration, 
      String? source, 
      List<String>? information}){
    _dishImage = dishImage;
    _title = title;
    _duration = duration;
    _source = source;
    _information = information;
}

  SimpleRecipe.fromJson(dynamic json) {
    _dishImage = json["dishImage"];
    _title = json["title"];
    _duration = json["duration"];
    _source = json["source"];
    _information = json["information"] != null ? json["information"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["dishImage"] = _dishImage;
    map["title"] = _title;
    map["duration"] = _duration;
    map["source"] = _source;
    map["information"] = _information;
    return map;
  }

}