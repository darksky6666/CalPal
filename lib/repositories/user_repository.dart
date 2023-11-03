import 'package:calpal/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final uid = FirebaseAuth.instance.currentUser!.uid.toString().trim();

  final _db = FirebaseFirestore.instance;

  // Create a user data
  createUser(UserModel user) async {
    await _db
        .collection('Users')
        .doc(uid)
        .set({
          'name': user.name,
          'height': user.height,
          'weight': user.weight,
          'age': user.age,
          'biologicalSex': user.biologicalSex,
          'medicalCondition': user.medicalCondition,
          'targetWeight': user.targetWeight,
          'targetDate': user.targetDate,
          'calBudget': user.calBudget,
        })
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

  // Update user data
  updateUser(UserModel user) async {
    await _db
        .collection('Users')
        .doc(uid)
        .update({
          'name': user.name,
          'height': user.height,
          'weight': user.weight,
          'age': user.age,
          'biologicalSex': user.biologicalSex,
          'medicalCondition': user.medicalCondition,
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
        // ignore: body_might_complete_normally_catch_error
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

  // Update goal data
  updateGoal(UserModel user) async {
    await _db
        .collection('Users')
        .doc(uid)
        .update({
          'weight': user.weight,
          'targetWeight': user.targetWeight,
          'targetDate': user.targetDate,
          'calBudget': user.calBudget,
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
        // ignore: body_might_complete_normally_catch_error
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

  // Fetch user data
  Future<UserModel> getUserDetails(String uid) async {
    final snapshot = await _db.collection('Users').doc(uid).get();
    final userData = UserModel.fromSnapshot(snapshot);
    return userData;
  }

  // Fetch all users data
  Future<List<UserModel>> getAllUserDetails(String uid) async {
    final snapshot = await _db.collection('Users').get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }
}
