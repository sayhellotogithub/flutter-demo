/// profileImageUrl : "assets/profile_pics/person_cesare.jpeg"
/// comment : "Made this delicious pizza this morning"
/// foodPictureUrl : "card_carrot.png"
/// timestamp : "10"

class Post {
  String? _profileImageUrl;
  String? _comment;
  String? _foodPictureUrl;
  String? _timestamp;

  String? get profileImageUrl => _profileImageUrl;
  String? get comment => _comment;
  String? get foodPictureUrl => _foodPictureUrl;
  String? get timestamp => _timestamp;

  Post({
      String? profileImageUrl, 
      String? comment, 
      String? foodPictureUrl, 
      String? timestamp}){
    _profileImageUrl = profileImageUrl;
    _comment = comment;
    _foodPictureUrl = foodPictureUrl;
    _timestamp = timestamp;
}

  Post.fromJson(dynamic json) {
    _profileImageUrl = json["profileImageUrl"];
    _comment = json["comment"];
    _foodPictureUrl = json["foodPictureUrl"];
    _timestamp = json["timestamp"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["profileImageUrl"] = _profileImageUrl;
    map["comment"] = _comment;
    map["foodPictureUrl"] = _foodPictureUrl;
    map["timestamp"] = _timestamp;
    return map;
  }

}