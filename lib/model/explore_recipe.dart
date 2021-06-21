import 'ingredient.dart';
import 'instruction.dart';

/// recipes : [{"cardType":"card1","title":"The Art of Dough","subtitle":"Editor's Choice","backgroundImage":"assets/magazine_pics/card_bread.jpg","backgroundImageSource":"https://www.foodiesfeed.com/free-food-photo/baker-with-wheat-flour/","message":"Learn to make the perfect bread.","authorName":"Ray Wenderlich","role":"Founder of Raywenderlich","authorImage":"assets/profile_pics/person_ray.jpeg","durationInMinutes":15,"dietType":"🌯Standard","calories":136,"tags":["Carbs","Dough","Crunchy","Yummy"],"description":"food made of flour, water, and yeast or another leavening agent, mixed together and baked: a loaf of bread","source":"Apple Dictionary","ingredients":[{"imageUrl":"food_flour.jpg","title":"Flour","source":"https://pixabay.com/photos/bake-butter-flour-mountain-pile-599521/"},{"imageUrl":"food_dozen_eggs.jpg","title":"Dozen Eggs","source":"https://pixabay.com/photos/egg-hen-s-egg-food-nutrition-1374141/"}],"instructions":[{"imageUrl":"food_flour.jpg","description":"Pour the flour on the table.","durationInMinutes":5},{"imageUrl":"food_dozen_eggs.jpg","description":"Mix the eggs with the flour. ","durationInMinutes":5}]},{"cardType":"card2","title":"Recipe","subtitle":"Smoothies","backgroundImage":"assets/magazine_pics/card_smoothie.png","backgroundImageSource":"https://www.foodiesfeed.com/free-food-photo/peanut-butter-and-banana-smoothie/","message":"Much Tasty, Wow Smooth, Oh Nutty","authorName":"Mike Katz","role":"Smoothie Connoisseur","profileImage":"assets/profile_pics/person_katz.jpeg","durationInMinutes":15,"dietType":"Standard","calories":136,"tags":["Drink","Nuts","Smooth","Energy"],"description":"a thick, smooth drink of fresh fruit pureed with milk, yogurt, or ice cream.","source":"Apple Dictionary","ingredients":[{"imageUrl":"food_peanutbutter.png","title":"Peanut Butter","source":"https://pixabay.com/photos/almond-blue-cook-cooking-egg-fat-1850615/"},{"imageUrl":"food_soymilk.png","title":"Soy Milk","source":"https://pixabay.com/photos/soy-milk-soy-soybean-soy-milk-2263942/"},{"imageUrl":"food_banana.jpg","title":"Banana","source":"https://pixabay.com/photos/bananas-fruit-food-fresh-mature-3700718/"}],"instructions":[{"imageUrl":"food_banana.jpg","description":"Peel the banana, cut it in half and place it in the blender.","durationInMinutes":1},{"imageUrl":"","description":"Add two big scoops of peanut butter.","durationInMinutes":1},{"imageUrl":"","description":"Add 2 cups of almond milk. Depending on the portion you may want to add more milk. You can add any type of milk you want.","durationInMinutes":5}]},{"cardType":"card1","title":"Delicious Salad","subtitle":"Healthy Foods","backgroundImage":"assets/magazine_pics/card_salad.png","backgroundImageSource":"https://www.foodiesfeed.com/free-food-photo/green-salad-with-bread/","message":"Learn how to make a killer salad","authorName":"Kevin Moore","role":"Author at RW","profileImage":"assets/profile_pics/person_kevin.jpeg","durationInMinutes":15,"dietType":"🌱 Vegan","calories":136,"tags":["Healthy","Salads","Lunch"],"description":"a cold dish of various mixtures of raw or cooked vegetables, usually seasoned with oil, vinegar, or other dressing and sometimes accompanied by meat, fish, or other ingredients: a green salad","source":"Apple Dictionary","ingredients":[{"imageUrl":"food_cucumber.jpg","title":"Cucumber","source":"https://pixabay.com/photos/cucumbers-vegetables-green-healthy-849269/"},{"imageUrl":"food_green_beans.jpg","title":"Green beans","source":"https://pixabay.com/photos/beans-vegetables-green-market-4785/"},{"imageUrl":"food_brussels_sprouts.jpg","title":"Brussel Sprouts","source":"https://pixabay.com/photos/brussels-sprouts-vegetables-sprouts-22009/"}],"instructions":[{"imageUrl":"food_cucumber.jpg","description":"Cut the cucumber up into many pieces.","durationInMinutes":3},{"imageUrl":"","description":"Wash the green beans well with salt, and rinse it a couple of times.","durationInMinutes":2},{"imageUrl":"","description":"Peel the first layer of brussel sprout leaves and place them in a bowl of water. Make sure you add salt to kill the germs.","durationInMinutes":5},{"imageUrl":"","description":"Place everything in a clean bowl, and add some salad dressing of your choice.","durationInMinutes":5}]},{"cardType":"card3","title":"Recipe Trends","subtitle":"","backgroundImage":"assets/magazine_pics/card_carrot.png","backgroundImageSource":"https://www.foodiesfeed.com/free-food-photo/fresh-carrots-from-a-market/","message":"Trends of what people are making","chef":"","role":"","durationInMinutes":null,"dietType":null,"calories":null,"tags":["Healthy","Vegan","Carrots","Greens","Wheat","Pescetarian","Mint","Lemongrass","Salad","Water"],"description":null,"source":null,"ingredients":null,"instructions":null}]

/// cardType : "card1"
/// title : "The Art of Dough"
/// subtitle : "Editor's Choice"
/// backgroundImage : "assets/magazine_pics/card_bread.jpg"
/// backgroundImageSource : "https://www.foodiesfeed.com/free-food-photo/baker-with-wheat-flour/"
/// message : "Learn to make the perfect bread."
/// authorName : "Ray Wenderlich"
/// role : "Founder of Raywenderlich"
/// authorImage : "assets/profile_pics/person_ray.jpeg"
/// durationInMinutes : 15
/// dietType : "🌯Standard"
/// calories : 136
/// tags : ["Carbs","Dough","Crunchy","Yummy"]
/// description : "food made of flour, water, and yeast or another leavening agent, mixed together and baked: a loaf of bread"
/// source : "Apple Dictionary"
/// ingredients : [{"imageUrl":"food_flour.jpg","title":"Flour","source":"https://pixabay.com/photos/bake-butter-flour-mountain-pile-599521/"},{"imageUrl":"food_dozen_eggs.jpg","title":"Dozen Eggs","source":"https://pixabay.com/photos/egg-hen-s-egg-food-nutrition-1374141/"}]
/// instructions : [{"imageUrl":"food_flour.jpg","description":"Pour the flour on the table.","durationInMinutes":5},{"imageUrl":"food_dozen_eggs.jpg","description":"Mix the eggs with the flour. ","durationInMinutes":5}]

class ExploreRecipe {
  String? _cardType;
  String? _title;
  String? _subtitle;
  String? _backgroundImage;
  String? _backgroundImageSource;
  String? _message;
  String? _authorName;
  String? _role;
  String? _profileImage;
  String? _authorImage;
  int? _durationInMinutes;
  String? _dietType;
  int? _calories;
  List<String>? _tags;
  String? _description;
  String? _source;
  List<Ingredient>? _ingredients;
  List<Instruction>? _instructions;

  String? get cardType => _cardType;

  String? get title => _title;

  String? get subtitle => _subtitle;

  String? get backgroundImage => _backgroundImage;

  String? get backgroundImageSource => _backgroundImageSource;

  String? get message => _message;

  String? get authorName => _authorName;

  String? get role => _role;

  String? get authorImage => _authorImage;

  int? get durationInMinutes => _durationInMinutes;

  String? get dietType => _dietType;

  int? get calories => _calories;

  List<String>? get tags => _tags;

  String? get description => _description;

  String? get source => _source;

  List<Ingredient>? get ingredients => _ingredients;

  List<Instruction>? get instructions => _instructions;

  ExploreRecipe(
      {String? cardType,
      String? title,
      String? subtitle,
      String? backgroundImage,
      String? backgroundImageSource,
      String? message,
      String? authorName,
      String? role,
      String? profileImage,
      String? authorImage,
      int? durationInMinutes,
      String? dietType,
      int? calories,
      List<String>? tags,
      String? description,
      String? source,
      List<Ingredient>? ingredients,
      List<Instruction>? instructions}) {
    _cardType = cardType;
    _title = title;
    _subtitle = subtitle;
    _backgroundImage = backgroundImage;
    _backgroundImageSource = backgroundImageSource;
    _message = message;
    _authorName = authorName;
    _role = role;

    _authorImage = authorImage;
    _durationInMinutes = durationInMinutes;
    _dietType = dietType;
    _calories = calories;
    _tags = tags;
    _description = description;
    _source = source;
    _ingredients = ingredients;
    _instructions = instructions;
  }

  ExploreRecipe.fromJson(dynamic json) {
    _cardType = json["cardType"];
    _title = json["title"];
    _subtitle = json["subtitle"];
    _backgroundImage = json["backgroundImage"];
    _backgroundImageSource = json["backgroundImageSource"];
    _message = json["message"];
    _authorName = json["authorName"];
    _role = json["role"];
    _profileImage = json["profileImage"];
    _authorImage = json["authorImage"];
    _durationInMinutes = json["durationInMinutes"];
    _dietType = json["dietType"];
    _calories = json["calories"];
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    _description = json["description"];
    _source = json["source"];
    if (json["ingredients"] != null) {
      _ingredients = [];
      json["ingredients"].forEach((v) {
        _ingredients?.add(Ingredient.fromJson(v));
      });
    }
    if (json["instructions"] != null) {
      _instructions = [];
      json["instructions"].forEach((v) {
        _instructions?.add(Instruction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cardType"] = _cardType;
    map["title"] = _title;
    map["subtitle"] = _subtitle;
    map["backgroundImage"] = _backgroundImage;
    map["backgroundImageSource"] = _backgroundImageSource;
    map["message"] = _message;
    map["authorName"] = _authorName;
    map["role"] = _role;
    map["profileImage"] = _profileImage;
    map["authorImage"] = _authorImage;
    map["durationInMinutes"] = _durationInMinutes;
    map["dietType"] = _dietType;
    map["calories"] = _calories;
    map["tags"] = _tags;
    map["description"] = _description;
    map["source"] = _source;
    if (_ingredients != null) {
      map["ingredients"] = _ingredients?.map((v) => v.toJson()).toList();
    }
    if (_instructions != null) {
      map["instructions"] = _instructions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
