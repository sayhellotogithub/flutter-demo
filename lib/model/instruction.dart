// imageUrl : "food_flour.jpg"
/// description : "Pour the flour on the table."
/// durationInMinutes : 5

class Instruction {
  String? _imageUrl;
  String? _description;
  int? _durationInMinutes;

  String? get imageUrl => _imageUrl;
  String? get description => _description;
  int? get durationInMinutes => _durationInMinutes;

  Instruction({
      String? imageUrl, 
      String? description, 
      int? durationInMinutes}){
    _imageUrl = imageUrl;
    _description = description;
    _durationInMinutes = durationInMinutes;
}

  Instruction.fromJson(dynamic json) {
    _imageUrl = json["imageUrl"];
    _description = json["description"];
    _durationInMinutes = json["durationInMinutes"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["imageUrl"] = _imageUrl;
    map["description"] = _description;
    map["durationInMinutes"] = _durationInMinutes;
    return map;
  }

}