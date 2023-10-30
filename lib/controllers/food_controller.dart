import 'package:calpal/models/foods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodController extends GetxController {
  static FoodController get instance => Get.find();

  final TextEditingController searchController = TextEditingController();

  List<FoodItem> suggestions = FoodItem.foodSuggestions;

  // Create a RxList to store the filtered suggestions
  RxList<FoodItem> filteredSuggestions = <FoodItem>[].obs;

  // Food suggestions
  void filterSuggestions(String query) {
    filteredSuggestions.clear(); // Clear the previous filtered suggestions
    print(FoodItem.foodSuggestions.first.name);
    for (FoodItem food in suggestions) {
      if (food.name.toLowerCase().contains(query.toLowerCase())) {
        filteredSuggestions.add(food);
        print("Debug" + FoodItem.foodSuggestions.last.name);
        if (filteredSuggestions.length >= 5) {
          break; // Limit the suggestions to the first 5 matches
        }
      }
    }
  }
}
