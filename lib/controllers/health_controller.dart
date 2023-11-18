import 'dart:developer';

import 'package:intl/intl.dart';

class HealthCalculatorController {
  static HealthCalculatorController get instance =>
      HealthCalculatorController();

  // Function to calculate BMI
  double calculateBMI(double weight, double height) {
    double bmi = 0;
    if (height != 0 && weight != 0) {
      // Convert height from cm to m
      height = height / 100;
      bmi = weight / (height * height);
    }
    return bmi;
  }

  // Classify the BMI into different categories
  String classifyBMI(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi < 25) {
      return "Normal";
    } else if (bmi < 30) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  // Function to calculate the recommended daily calorie value based on biological sex
  // BMR
  int calculateRecommendedCalories(
      String biologicalSex, double weight, double height, int age) {
    // Use Mifflin-St Jeor equation to calculate BMR
    double bmr = (10 * weight) + (6.25 * height) - (5 * age);
    if (biologicalSex == "Male") {
      bmr += 5;
    } else {
      bmr -= 161;
    }
    return bmr.round();
  }

  // Function to calculate the daily calorie deficit based on target date
  int calculateCalorieChange(
      double weight, double targetWeight, String targetDate) {
    // Calculate the weight difference between the current weight and the target weight
    double weightDifference = targetWeight - weight;

    // Determine the number of days between today and the target date
    int daysDifference = calculateTimeToTarget(targetDate);

    if (daysDifference <= 0) {
      daysDifference =
          1; // Set a minimum of 1 day if the target date has passed
    }

    // Calculate the adjusted weight change without capping it
    double adjustedWeightChange = weightDifference.abs();

    // Determine the direction of weight change (loss or gain)
    bool isWeightLoss = weightDifference < 0;

    // Calculate the daily calorie change based on the adjusted weight change
    double totalCalorieChange =
        adjustedWeightChange * 7700; // 7700 kcal/kg (approx.)
    double dailyCalorieChange = totalCalorieChange / daysDifference;

    log("Debug: " +
        weightDifference.toString() +
        " " +
        isWeightLoss.toString() +
        " " +
        dailyCalorieChange.toString());

    // If it's a weight loss goal, return negative calorie change; else, return positive
    return isWeightLoss
        ? -dailyCalorieChange.round()
        : dailyCalorieChange.round();
  }

  // Function to calculate the time required to reach the target date from today
  int calculateTimeToTarget(String targetDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime target = DateFormat('dd/MM/yyyy').parse(targetDate);
    log("Debug date: " + today.toString() + " " + target.toString());
    return target.difference(today).inDays;
  }

  // Determine if the user can reach the target weight by the target date
  bool canReachTargetWeight(
    double targetWeight,
    double weight,
    String targetDate,
    String biologicalSex,
    double height,
    int age,
    int calBudget,
  ) {
    // Calculate the daily calorie change needed to reach the target weight
    int dailyCalorieChange =
        calculateCalorieChange(weight, targetWeight, targetDate);

    // Calculate the number of days between the current date and the target date
    int daysDifference = calculateTimeToTarget(targetDate);

    // Calculate the recommended daily calorie intake
    int recommendedCalorieIntake =
        calculateRecommendedCalories(biologicalSex, weight, height, age);

    // Calculate the maximum safe weight change within the given time frame
    double maxSafeWeightChange = 0.5 * (daysDifference / 7); // 0.5 kg per week

    // Calculate the maximum allowable deficit for weight loss
    double maxAllowableDeficit =
        maxSafeWeightChange * 7700; // 7700 kcal/kg (approx.)

    log("Debug: " +
        " " +
        daysDifference.toString() +
        " " +
        recommendedCalorieIntake.toString() +
        " " +
        maxAllowableDeficit.toString() +
        " cb " +
        calBudget.toString() +
        " " +
        recommendedCalorieIntake.toString() +
        " " +
        dailyCalorieChange.toString());

    // Check if the user has enough time to reach the target weight and calorie budget is non-negative
    if (daysDifference > 0 && calBudget >= 0) {
      // Check if the user has enough calories to achieve the weight change goal
      if (targetWeight < weight) {
        log("This is a weight loss goal");
        // Weight loss goal
        // Check if the user has enough calories to achieve the target weight
        if (calBudget >= recommendedCalorieIntake &&
            calBudget >= -dailyCalorieChange &&
            -dailyCalorieChange <= maxAllowableDeficit) {
          return true;
        }
      } else {
        log("This is a weight gain or maintenance goal");
        // Weight gain or maintenance goal
        bool enoughCaloriesForWeightGain = calBudget >= dailyCalorieChange &&
            recommendedCalorieIntake <= dailyCalorieChange;

        bool enoughCaloriesForMaintenance =
            calBudget >= recommendedCalorieIntake &&
                calBudget >= dailyCalorieChange &&
                dailyCalorieChange <= maxAllowableDeficit;

        log("Debug: " +
            enoughCaloriesForWeightGain.toString() +
            " " +
            enoughCaloriesForMaintenance.toString());

        return enoughCaloriesForWeightGain || enoughCaloriesForMaintenance;
      }
    }
    return false;
  }
}
