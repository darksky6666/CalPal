import 'package:calpal/models/foods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodRepository extends GetxController {
  static FoodRepository get instance => Get.find();
  final uid = FirebaseAuth.instance.currentUser!.uid.toString().trim();
  
  final _db = FirebaseFirestore.instance;

  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyyMMdd");
    return dateFormat.format(now);
  }

  createFood(FoodItem food, String mealType) async {
    await _db
        .collection('Meals')
        .doc(uid)
        .collection(getFormattedDateTime())
        .add(food.toJson())
        .whenComplete(() => Fluttertoast.showToast(
              msg: "Successfully stored",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.greenAccent.withOpacity(0.1),
              textColor: Colors.green,
              fontSize: 16.0,
            ))
        // ignore: body_might_complete_normally_catch_error
        .catchError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Failed to store: $error",
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
    print("Debug food repo: " + date);
    // print("Debug: " + getFormattedDateTime());
    final snapshot = await _db
        .collection('Meals')
        .doc(uid)
        .collection(date)
        .where('mealType', isEqualTo: mealType)
        .get();
    final mealData = snapshot.docs.map((e) => FoodItem.fromSnapshot(e)).toList();
    return mealData;
  }
  
}