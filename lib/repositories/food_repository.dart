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

  createFood(FoodItem food) async {
    try {
      final DocumentReference documentReference = await _db
          .collection('Meals')
          .doc(uid)
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
    print(food.docId.toString());
    print(food.servingSize);
    print(food.servingUnit);
    print(food.mealType);
    print(date);
    await _db
        .collection('Meals')
        .doc(uid)
        .collection(date)
        .doc(food.docId.toString())
        .update({
          'servingSize': food.servingSize,
          'servingUnit': food.servingUnit,
          'mealType': food.mealType,
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
        .doc(uid)
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
        .doc(uid)
        .collection(date)
        .where('mealType', isEqualTo: mealType)
        .get();
    final mealData =
        snapshot.docs.map((e) => FoodItem.fromSnapshot(e)).toList();
    return mealData;
  }

  Future<List<FoodItem>> getFoodInfo(String date) async {
    final snapshot =
        await _db.collection('Meals').doc(uid).collection(date).get();
    final mealData =
        snapshot.docs.map((e) => FoodItem.fromSnapshot(e)).toList();
    return mealData;
  }

  // Get the food data from the database with docId
  Future<FoodItem> getFoodFromID(String date, String docId) async {
    final snapshot = await _db
        .collection('Meals')
        .doc(uid)
        .collection(date)
        .doc(docId)
        .get();
    final mealData = FoodItem.fromSnapshot(snapshot);
    return mealData;
  }
}
