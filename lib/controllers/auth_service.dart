import 'package:calpal/controllers/registration_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final registrationController = Get.put(RegistrationController());

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
          msg: "Password reset email sent successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

// Function to register a user using Firebase Auth
  Future<void> registerUserWithEmailAndPassword(
      String email, String password, Function(bool, String) onResult) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      User? user = userCredential.user;

      // After successful registration
      if (user != null) {
        // Create a new user data
        DateTime currentDate = DateTime.now();
        DateTime dateAfterOneMonth = currentDate.add(Duration(days: 30));
        String formattedDate =
            DateFormat('dd/MM/yyyy').format(dateAfterOneMonth);

        UserModel newUser = UserModel(
          name: registrationController.nameController.text,
          height: int.parse(registrationController.heightController.text),
          weight: double.parse(registrationController.weightController.text),
          age: int.parse(registrationController.ageController.text),
          biologicalSex: registrationController.biologicalSex.value.toString(),
          medicalCondition:
              registrationController.medicalCondition.value.toString(),
          targetWeight:
              double.parse(registrationController.targetWeightController.text),
          targetDate: formattedDate,
          calBudget: int.parse(registrationController.calBudgetController.text),
        );
        createUser(newUser, user.uid);
        onResult(true, "");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code.toLowerCase() == 'email-already-in-use') {
        onResult(false, "The account already exists for that email. Please try again.");
      } else {
        onResult(false, e.toString());
      }
    }
  }

  // Create a user data
  Future<void> createUser(UserModel user, String uid) async {
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
        .catchError((error, stackTrace) {
          Fluttertoast.showToast(
              msg: "Failed to store registration data: $error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              textColor: Colors.red,
              fontSize: 16.0);
        });
  }
}
