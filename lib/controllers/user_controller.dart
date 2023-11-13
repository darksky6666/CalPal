import 'package:calpal/repositories/user_repository.dart';
import 'package:calpal/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController {
  static UserController get instance => Get.find();

  // Text editing controllers
  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();
  final targetWeightController = TextEditingController();
  final calBudgetController = TextEditingController();
  final targetDateController = TextEditingController();

  final userRepo = Get.put(UserRepository());

  Future<void> createUserInfo(UserModel user) async {
    await userRepo.createUser(user);
  }

  // Update user data
  Future<void> updateUserInfo(UserModel user) async {
    await userRepo.updateUser(user);
  }

  // Update goal data
  Future<void> updateGoalInfo(UserModel user) async {
    await userRepo.updateGoal(user);
  }

  // Fetch single user data
  getUserData() {
    final uid = FirebaseAuth.instance.currentUser!.uid.toString().trim();
    return userRepo.getUserDetails(uid);
  }
}
