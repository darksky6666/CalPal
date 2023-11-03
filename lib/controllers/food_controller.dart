import 'package:calpal/models/foods.dart';
import 'package:calpal/repositories/food_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodController extends GetxController {
  static FoodController get instance => Get.find();
  final foodRepo = Get.put(FoodRepository());

  final TextEditingController searchController = TextEditingController();

  Future<void> createFood(FoodItem food, String mealType) async {
    await foodRepo.createFood(food, mealType);
  }

  getMealDetails(String date, String mealType) {
    return foodRepo.getMealDetails(date, mealType);
  }

  getFoodInfo(String date) {
    return foodRepo.getFoodInfo(date);
  }

  // Get food image path from the food name
  String getFoodImagePath(String foodName) {
    return 'assets/foods/${foodName.toLowerCase()}.jpg';
  }

  List<FoodItem> suggestions = FoodItem.foodSuggestions
      .map((foodName) => FoodItem(name: foodName))
      .toList();

  // Create a RxList to store the filtered suggestions
  RxList<FoodItem> filteredSuggestions = <FoodItem>[].obs;

  // Food suggestions
  void filterSuggestions(String query) {
    filteredSuggestions.clear(); // Clear the previous filtered suggestions

    // If the query is empty, return all the suggestions
    if (query.isEmpty) {
      filteredSuggestions.addAll(suggestions);
      return;
    } else {
      for (FoodItem food in suggestions) {
        if (food.name.toLowerCase().contains(query.toLowerCase())) {
          filteredSuggestions.add(food);
          // if (filteredSuggestions.length >= 5) {
          //   break; // Limit the suggestions to the first 5 matches
          // }
        }
      }
    }
  }
}
