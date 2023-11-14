import 'package:calpal/controllers/health_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  static RegistrationController get instance => Get.find();
  final healthController = Get.put(HealthCalculatorController());

  // Variables
  RxString biologicalSex = 'Male'.obs;
  RxString medicalCondition = 'None'.obs;

  // Update methods for each field
  void updateBiologicalSex(String value) => biologicalSex.value = value;
  void updateMedicalCondition(String value) => medicalCondition.value = value;

  // Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reenterPasswordController =
      TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController targetWeightController = TextEditingController();
  final TextEditingController calBudgetController = TextEditingController();

  // Method to reset all data
  void resetData() {
    biologicalSex.value = 'Male';
    medicalCondition.value = 'None';

    nameController.clear();
    emailController.clear();
    passwordController.clear();
    reenterPasswordController.clear();
    heightController.clear();
    weightController.clear();
    ageController.clear();
    targetWeightController.clear();
    calBudgetController.clear();
  }

  // Method to calculate calorie budget
  int getCalorieBudget() {
    return healthController.calculateRecommendedCalories(
        biologicalSex.value.toString(),
        double.parse(weightController.text),
        double.parse(heightController.text),
        int.parse(ageController.text));
  }
}
