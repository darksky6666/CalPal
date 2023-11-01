import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String name;
  final String? mealType;
  final double? servingSize;
  final String? servingUnit;
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbs;

  FoodItem({
    required this.name,
    this.mealType,
    this.servingSize,
    this.servingUnit,
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
  });

  // Convert a FoodItem into a Map object
  toJson() {
    return {
      'name': name,
      'mealType': mealType,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
    };
  }

  // Get the data from the snapshot
  factory FoodItem.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return FoodItem(
      name: data['name'],
      mealType: data['mealType'],
      servingSize: data['servingSize'],
      servingUnit: data['servingUnit'],
      calories: data['calories'],
      protein: data['protein'],
      fat: data['fat'],
      carbs: data['carbs'],
    );
  }

  // Create an instance of the FoodItem class with the food suggestions
  static final List<String> foodSuggestions = [
    "Adobo",
    "Almond Jelly",
    "Apple Pie",
    "Ayam Bakar",
    "Ayam Goreng",
    "Bagel",
    "Baked Salmon",
    "Bean Curd Family Style",
    "Beef Bowl",
    "Beef Curry",
    "Beef In Oyster Sauce",
    "Beef Noodle",
    "Beef Noodle Soup",
    "Bibimbap",
    "Boiled Chicken And Vegetables",
    "Boiled Fish",
    "Broiled Eel Bowl",
    "Brownie",
    "Bubur Ayam",
    "Cabbage Roll",
    "Caesar Salad",
    "Champon",
    "Chicken And Egg On Rice",
    "Chicken Cutlet",
    "Chicken Nugget",
    "Chicken Rice",
    "Chicken Rice Curry With Coconut",
    "Chilled Noodle",
    "Chinese Pumpkin Pie",
    "Chinese Soup",
    "Chip Butty",
    "Chop Suey",
    "Chow Mein",
    "Churro",
    "Clear Soup",
    "Coconut Milk Flavored Crepes With Shrimp And Beef",
    "Coconut Milk Soup",
    "Cold Tofu",
    "Crape",
    "Cream Puff",
    "Crispy Noodles",
    "Croissant",
    "Croquette",
    "Crullers",
    "Curry Puff",
    "Custard Tart",
    "Cutlet Curry",
    "Dak Galbi",
    "Deep Fried Chicken Wing",
    "Dipping Noodles",
    "Dish Consisting Of Stir Fried Potato Eggplant And Green Pepper",
    "Doughnut",
    "Dried Fish",
    "Dry Curry",
    "Eels On Rice",
    "Egg Noodle In Chicken Yellow Curry",
    "Egg Roll",
    "Egg Sunny Side Up",
    "Eggplant With Garlic Sauce",
    "Eight Treasure Rice",
    "Fine White Noodles",
    "Fish Ball Soup",
    "Fish Shaped Pancake With Bean Jam",
    "French Bread",
    "French Fries",
    "French Toast",
    "Fried Chicken",
    "Fried Fish",
    "Fried Mussel Pancakes",
    "Fried Noodle",
    "Fried Rice",
    "Fried Shrimp",
    "Fried Spring Rolls",
    "Ganmodoki",
    "Glutinous Oil Rice",
    "Glutinous Rice Balls",
    "Goya Chanpuru",
    "Gratin",
    "Green Curry",
    "Green Salad",
    "Grilled Eggplant",
    "Grilled Pacific Saury",
    "Grilled Salmon",
    "Gulai",
    "Hainan Chicken With Marinated Rice",
    "Ham Cutlet",
    "Hambarg Steak",
    "Hamburger",
    "Haupia",
    "Hot & Sour Soup",
    "Hot And Sour, Fish And Vegetable Ragout",
    "Hot Dog",
    "Hot Pot",
    "Hue Beef Rice Vermicelli Soup",
    "Inarizushi",
    "Jambalaya",
    "Japanesestyle Pancake",
    "Japanesetofu And Vegetable Chowder",
    "Jiaozi",
    "Jjigae",
    "Kamameshi",
    "Kaya Toast",
    "Khao Soi",
    "Kinpirastyle Sauteed Burdock",
    "Kung Pao Chicken",
    "Kushikatu",
    "Laksa",
    "Lamb Kebabs",
    "Lasagna",
    "Laulau",
    "Lemon Fig Jelly",
    "Lightly Roasted Fish",
    "Loco Moco",
    "Lumpia",
    "Macaroni Salad",
    "Malasada",
    "Mango Pudding",
    "Meat Loaf",
    "Mie Ayam",
    "Mie Goreng",
    "Minced Meat Cutlet",
    "Minestrone",
    "Miso Soup",
    "Mixed Rice",
    "Moon Cake",
    "Mozuku",
    "Muffin",
    "Mushroom Risotto",
    "Nachos",
    "Namero",
    "Nanbanzuke",
    "Nasi Campur",
    "Nasi Goreng",
    "Nasi Padang",
    "Nasi Uduk",
    "Natto",
    "Noodles With Fish Curry",
    "Oatmeal",
    "Oden",
    "Okinawa Soba",
    "Omelet",
    "Omelet With Fried Rice",
    "Oshiruko",
    "Oxtail Soup",
    "Oyster Omelette",
    "Paella",
    "Pancake",
    "Parfait",
    "Pho",
    "Pilaf",
    "Pizza",
    "Pizza Toast",
    "Popcorn",
    "Pot Au Feu",
    "Potage",
    "Potato Salad",
    "Raisin Bread",
    "Ramen Noodle",
    "Rare Cheese Cake",
    "Rice",
    "Rice Ball",
    "Rice Gratin",
    "Rice Gruel",
    "Rice Vermicelli",
    "Rice With Roast Duck",
    "Roast Chicken",
    "Roast Duck",
    "Roll Bread",
    "Salmon Meuniere",
    "Salt & Pepper Fried Shrimp With Shell",
    "Samul",
    "Sandwiches",
    "Sashimi",
    "Sashimi Bowl",
    "Sausage",
    "Sauteed Spinach",
    "Sauteed Vegetables",
    "Scone",
    "Scrambled Egg",
    "Seasoned Beef With Potatoes",
    "Shortcake",
    "Shrimp Patties",
    "Shrimp With Chill Source",
    "Sirloin Cutlet",
    "Small Steamed Savory Rice Pancake",
    "Soba Noodle",
    "Sour Prawn Soup",
    "Spaghetti",
    "Spaghetti Meat Sauce",
    "Spam Musubi",
    "Spicy Chicken Salad",
    "Spicy Chili-Flavored Tofu",
    "Steak",
    "Steamed Egg Hotchpotch",
    "Steamed Meat Dumpling",
    "Steamed Rice Roll",
    "Steamed Spareribs",
    "Stew",
    "Stinky Tofu",
    "Stir-Fried Beef And Peppers",
    "Stir-Fried Mixed Vegetables",
    "Sukiyaki",
    "Sushi",
    "Sushi Bowl",
    "Tacos",
    "Takoyaki",
    "Tanmen",
    "Tempura",
    "Tempura Bowl",
    "Tempura Udon",
    "Tensin Noodle",
    "Teriyaki Grilled Fish",
    "Thai Papaya Salad",
    "Thinly Sliced Raw Horsemeat",
    "Three Cup Chicken",
    "Tiramisu",
    "Toast",
    "Tortilla",
    "Trunip Pudding",
    "Udon Noodle",
    "Vegetable Tempura",
    "Vermicelli Noodles With Snails",
    "Waffle",
    "Winter Melon Soup",
    "Wonton Soup",
    "Xiao Long Bao",
    "Yakitori",
    "Yellow Curry",
    "Yudofu",
    "Zha Jiang Mian",
    "Zoni",
  ];
}
