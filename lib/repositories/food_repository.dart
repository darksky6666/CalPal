import 'package:calpal/models/foods.dart';
import 'package:calpal/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodRepository extends GetxController {
  static FoodRepository get instance => Get.find();
  final userRepo = Get.put(UserRepository());

  final _db = FirebaseFirestore.instance;

  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyyMMdd");
    return dateFormat.format(now);
  }

  createFood(FoodItem food) async {
    try {
      final DocumentReference documentReference = await _db
          .collection('Meals')
          .doc(userRepo.getCurrentUid())
          .collection(getFormattedDateTime())
          .add(food.toJson());

      final String docId = documentReference.id;
      await documentReference.update({'docId': docId});

      Fluttertoast.showToast(
        msg: "Successfully stored",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent.withOpacity(0.1),
        textColor: Colors.green,
        fontSize: 16.0,
      );
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Failed to store: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          textColor: Colors.red,
          fontSize: 16.0);
    }
  }

  // Update the food data
  Future<void> updateFood(FoodItem food, String date) async {
    await _db
        .collection('Meals')
        .doc(userRepo.getCurrentUid())
        .collection(date)
        .doc(food.docId.toString())
        .update({
          'servingSize': food.servingSize,
          'servingUnit': food.servingUnit,
          'mealType': food.mealType,
          'calories': food.calories,
          'fat': food.fat,
          'protein': food.protein,
          'carbs': food.carbs,
          'saturatedFat': food.saturatedFat,
          'cholesterol': food.cholesterol,
          'sodium': food.sodium,
          'fiber': food.fiber,
          'sugar': food.sugar,
          'potassium': food.potassium,
        })
        .whenComplete(() => Fluttertoast.showToast(
              msg: "Successfully updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.greenAccent.withOpacity(0.1),
              textColor: Colors.green,
              fontSize: 16.0,
            ))
        .catchError((error, stackTrace) {
          Fluttertoast.showToast(
              msg: "Failed to update: $error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              textColor: Colors.red,
              fontSize: 16.0);
        });
  }

  // Delete the food data
  Future<void> deleteFood(String docId, String date) async {
    await _db
        .collection('Meals')
        .doc(userRepo.getCurrentUid())
        .collection(date)
        .doc(docId)
        .delete()
        .whenComplete(() => Fluttertoast.showToast(
              msg: "Successfully deleted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.greenAccent.withOpacity(0.1),
              textColor: Colors.green,
              fontSize: 16.0,
            ))
        .catchError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Failed to delete: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          textColor: Colors.red,
          fontSize: 16.0);
    });
  }

  // Fetch all meal data for a particular day
  Future<List<FoodItem>> getMealDetails(String date, String mealType) async {
    final snapshot = await _db
        .collection('Meals')
        .doc(userRepo.getCurrentUid())
        .collection(date)
        .where('mealType', isEqualTo: mealType)
        .get();
    final mealData =
        snapshot.docs.map((e) => FoodItem.fromSnapshot(e)).toList();
    return mealData;
  }

  Future<List<FoodItem>> getFoodInfo(String date) async {
    final snapshot = await _db
        .collection('Meals')
        .doc(userRepo.getCurrentUid())
        .collection(date)
        .get();
    final mealData =
        snapshot.docs.map((e) => FoodItem.fromSnapshot(e)).toList();
    return mealData;
  }

  // Get the food data from the database with docId
  Future<FoodItem> getFoodFromID(String date, String docId) async {
    final snapshot = await _db
        .collection('Meals')
        .doc(userRepo.getCurrentUid())
        .collection(date)
        .doc(docId)
        .get();
    final mealData = FoodItem.fromSnapshot(snapshot);
    return mealData;
  }

  // Get calories value for last 7 days
  Future<List<double>> getCalorieData(DateTime date) async {
    // Calculate the starting date which is 7 days ago
    DateTime sevenDaysAgo = date.subtract(const Duration(days: 6));

    List<double> calorieData = [];

    // Loop through the last 7 days
    for (int i = 0; i < 7; i++) {
      // Calculate the date for the current iteration
      DateTime currentDate = sevenDaysAgo.add(Duration(days: i));
      // Format the date as yyyymmdd
      String formattedDate = DateFormat('yyyyMMdd').format(currentDate);

      // Find the collection with the same date as the current iteration
      final snapshot = await _db
          .collection('Meals')
          .doc(userRepo.getCurrentUid())
          .collection(formattedDate)
          .get();

      double totalCalories = 0;

      // Check if the collection exists
      if (snapshot.docs.isNotEmpty) {
        // Collection found, iterate through documents to get calorie values
        for (QueryDocumentSnapshot mealEntryDoc in snapshot.docs) {
          dynamic caloriesValue = mealEntryDoc['calories'];

          // Check if caloriesValue is not null
          if (caloriesValue != null) {
            double calories = (caloriesValue is int)
                ? caloriesValue.toDouble()
                : caloriesValue;
            totalCalories += calories;
          }
        }
      }

      // Add the total calories for the day to the data list
      calorieData.add(totalCalories);
    }

    return calorieData;
  }

  // Get top 3 food items for a particular day
  Future<List<FoodItem>> getTopFoodItems(String nutrient, String date) async {
    final snapshot = await _db
        .collection('Meals')
        .doc(userRepo.getCurrentUid())
        .collection(date)
        .orderBy(nutrient, descending: true)
        .limit(3)
        .get();

    final topFoodItems =
        snapshot.docs.map((e) => FoodItem.fromSnapshot(e)).toList();

    return topFoodItems;
  }
}
