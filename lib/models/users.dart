import 'package:calpal/controllers/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserModel {
  final String? name;
  final int? height;
  final double? weight;
  final int? age;
  final String? biologicalSex;
  final String? medicalCondition;
  final double? targetWeight;
  final String? targetDate;
  final int? calBudget;

  const UserModel({
    this.name,
    this.height,
    this.weight,
    this.age,
    this.biologicalSex,
    this.medicalCondition,
    this.targetWeight,
    this.targetDate,
    this.calBudget,
  });

  // Get the data from the snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    try {
      final data = document.data()!;
      return UserModel(
        name: data['name'],
        height: data['height'],
        weight: data['weight'],
        age: data['age'],
        biologicalSex: data['biologicalSex'],
        medicalCondition: data['medicalCondition'],
        targetWeight: data['targetWeight'],
        targetDate: data['targetDate'],
        calBudget: data['calBudget'],
      );
    } catch (e) {
      AuthService().signOut();
      Fluttertoast.showToast(
          msg: "There's some unexpected error. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return UserModel();
    }
  }
}
