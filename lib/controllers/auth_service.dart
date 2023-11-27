import 'dart:developer';

import 'package:calpal/controllers/registration_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final registrationController = Get.put(RegistrationController());

  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      String email, String password, Function(bool, String) onResult) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          // User has verified their email, proceed with login
          log('User logged in: ${user.uid}');
          onResult(true, "");
        } else {
          // Show an error message indicating that the user needs to verify their email
          Fluttertoast.showToast(
              msg: "Please verify your email to login.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          onResult(false, "failed-email-verification");
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      log(e.toString());
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        Fluttertoast.showToast(
            msg: "Invalid login credentials. Please try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(false, e.toString());
      } else if (e.code == 'too-many-requests') {
        Fluttertoast.showToast(
            msg: "Too many login attempts. Please try again later.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(false, e.toString());
      } else {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(false, e.toString());
      }
    } catch (e) {
      log("Catch not from firebase auth");
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      onResult(false, e.toString());
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
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

  // Function to send a verification email to the user
  Future<void> sendEmailVerify() async {
    User? user = auth.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification().then((_) {
        // Email verification link sent
        Fluttertoast.showToast(
            msg: "Verification email sent!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }).catchError((error) {
        // Handle errors if email verification fails
        Fluttertoast.showToast(
            msg: "Error sending verification email: $error",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }

  // Function to register a user using Firebase Auth
  Future<void> registerUserWithEmailAndPassword(
      String email, String password, Function(bool, String) onResult) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
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
        onResult(false,
            "The account already exists for that email. Please try again.");
      } else {
        onResult(false, e.toString());
      }
    }
  }

  // Create a user data
  Future<void> createUser(UserModel user, String uid) async {
    await db.collection('Users').doc(uid).set({
      'name': user.name,
      'height': user.height,
      'weight': user.weight,
      'age': user.age,
      'biologicalSex': user.biologicalSex,
      'medicalCondition': user.medicalCondition,
      'targetWeight': user.targetWeight,
      'targetDate': user.targetDate,
      'calBudget': user.calBudget,
    }).catchError((error, stackTrace) {
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

  // Function to verify user new email and update it
  Future<void> verifyAndUpdateUserNewEmail(String email, String newEmail,
      String currentPassword, Function(bool, String) onResult) async {
    User? user = auth.currentUser;

    if (user != null) {
      // Create a credential using the user's email and current password
      AuthCredential credential = EmailAuthProvider.credential(
          email: email.trim(), password: currentPassword.trim());

      try {
        // Reauthenticate the user with the credential
        await user.reauthenticateWithCredential(credential);

        // Check if the new email is not already in use
        await user.verifyBeforeUpdateEmail(newEmail);

        try {
          await auth.signOut();
        } catch (e) {
          log(e.toString());
        }

        log("Verification email sent to $newEmail");
        Fluttertoast.showToast(
            msg: "Verification email sent to $newEmail",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(true, "Verification email sent to $newEmail");
      } catch (error) {
        log(error.toString());
        Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(false, error.toString());
      }
    }
  }

  // Function to reauthenticate and change password
  Future<void> changeUserPassword(String email, String currentPassword,
      String newPassword, Function(bool, String) onResult) async {
    User? user = auth.currentUser;

    if (user != null) {
      // Create a credential using the user's email and current password
      AuthCredential credential = EmailAuthProvider.credential(
          email: email.trim(), password: currentPassword.trim());

      try {
        // Reauthenticate the user with the credential
        await user.reauthenticateWithCredential(credential);

        // After successful reauthentication, update the password
        await user.updatePassword(newPassword.trim());
        log("Password updated successfully!");
        try {
          await auth.signOut();
        } catch (e) {
          log(e.toString());
        }
        Fluttertoast.showToast(
            msg: "Password updated successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(true, "Password updated successfully!");
      } catch (error) {
        // Handle reauthentication or password change errors
        log(error.toString());
        Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(false, error.toString());
      }
    }
  }

  // Function to delete a user account
  void deleteUserAccount(
      String email, String password, Function(bool, String) onResult) async {
    User? user = auth.currentUser;

    if (user != null) {
      // Create a credential with the user's email and password
      AuthCredential credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password.trim(),
      );

      try {
        // Reauthenticate the user with the provided credential
        await user.reauthenticateWithCredential(credential);

        // Fetch the UID after reauthentication
        String uid = user.uid;

        // Delete documents from 'Meals' and 'Users' collections
        try {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .delete();
        } catch (e) {
          log(e.toString());
        }
        try {
          await FirebaseFirestore.instance
              .collection('Meals')
              .doc(uid)
              .delete();
        } catch (e) {
          log(e.toString());
        }

        // If reauthentication is successful, delete the account
        await user.delete();
        Fluttertoast.showToast(
            msg: "Account deleted successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(true, "Account deleted successfully!");
      } catch (e) {
        // Handle errors if reauthentication fails
        log(e.toString());
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        onResult(false, e.toString());
      }
    }
  }
}
