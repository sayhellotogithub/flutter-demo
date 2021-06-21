/// imageUrl : "food_flour.jpg"
/// title : "Flour"
/// source : "https://pixabay.com/photos/bake-butter-flour-mountain-pile-599521/"

class Ingredient {
  String? _imageUrl;
  String? _title;
  String? _source;

  String? get imageUrl => _imageUrl;
  String? get title => _title;
  String? get source => _source;

  Ingredient({
      String? imageUrl, 
      String? title, 
      String? source}){
    _imageUrl = imageUrl;
    _title = title;
    _source = source;
}

  Ingredient.fromJson(dynamic json) {
    _imageUrl = json["imageUrl"];
    _title = json["title"];
    _source = json["source"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["imageUrl"] = _imageUrl;
    map["title"] = _title;
    map["source"] = _source;
    return map;
  }

}