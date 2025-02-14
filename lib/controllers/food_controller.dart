import 'dart:developer';

import 'package:calpal/models/foods.dart';
import 'package:calpal/repositories/food_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodController extends GetxController {
  static FoodController get instance => Get.find();
  final foodRepo = Get.put(FoodRepository());

  final TextEditingController searchController = TextEditingController();

  Future<void> createFood(FoodItem food) async {
    await foodRepo.createFood(food);
  }

  // Update the food data
  Future<void> updateFood(FoodItem food, String date) async {
    await foodRepo.updateFood(food, date);
  }

  // Delete the food data
  Future<void> deleteFood(String date, String docId) async {
    await foodRepo.deleteFood(date, docId);
  }

  getMealDetails(String date, String mealType) {
    return foodRepo.getMealDetails(date, mealType);
  }

  getFoodInfo(String date) {
    return foodRepo.getFoodInfo(date);
  }

  // Get the food data from the database with docId
  getFoodFromID(String date, String docId) {
    return foodRepo.getFoodFromID(date, docId);
  }

  // Set predefined food data
  String setPredefinedFood(String name) {
    final Map<String, String> foodTranslations = {
      "ayam goreng": "fried chicken",
      "bubur ayam": "chicken porridge",
      "crape": "crepe",
      "gratin": "potatoes gratin",
      "grilled pacific saury": "grilled fish",
      "gulai": "curry",
      "haupia": "coconut pudding",
      "inarizushi": "inari sushi",
      "kamameshi": "japanese rice",
      "kushikatu": "deep fried meat",
      "mie ayam": "chicken noodles",
      "namero": "fish tataki",
      "nanbanzuke": "marinated fried fish",
      "pilaf": "pilau",
      "potage": "thick soup",
      "pot au feu": "beef stew",
      "samul": "samgyeopsal",
      "tanmen": "ramen soup noodles",
      "thinly sliced raw horsemeat": "meat",
      "zha jiang mian": "chinese fried noodles",
    };

    name = name.toLowerCase();

    if (foodTranslations.containsKey(name)) {
      return foodTranslations[name]!;
    } else {
      return name;
    }
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
    try {
      filteredSuggestions.clear();
    } catch (e) {
      log(e.toString());
    }

    // If the query is empty, return all the suggestions
    try {
      if (query.isEmpty) {
        filteredSuggestions.addAll(suggestions);
        return;
      } else {
        for (FoodItem food in suggestions) {
          if (food.name!.toLowerCase().contains(query.toLowerCase())) {
            filteredSuggestions.add(food);
            // if (filteredSuggestions.length >= 5) {
            //   break; // Limit the suggestions to the first 5 matches
            // }
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Food Detection Searching
  String foodDetectionSearch(String query) {
    String foodName = "null";

    // If the query is empty, return all the suggestions
    try {
      if (query.isEmpty) {
        return foodName;
      } else {
        for (FoodItem food in suggestions) {
          if (food.name!.toLowerCase().contains(query.toLowerCase())) {
            foodName = food.name!;
            break;
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return foodName;
  }
}
