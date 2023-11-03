import 'package:intl/intl.dart';

class HealthCalculatorController {
  static HealthCalculatorController get instance =>
      HealthCalculatorController();

  // Function to calculate the recommended daily calorie value based on biological sex
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
  int calculateCalorieDeficit(
      double targetWeight, double weight, String targetDate) {
    // Calculate the total calorie deficit
    double totalCalorieDeficit = (targetWeight - weight) * 7700;

    // Calculate the number of days between the current date and the target date
    int daysDifference = calculateTimeToTarget(targetDate);

    if (daysDifference <= 0) {
      daysDifference = 1;
    }

    // Calculate the daily calorie deficit
    double dailyCalorieDeficit = totalCalorieDeficit / daysDifference;

    return dailyCalorieDeficit.round();
  }

  // Function to calculate the time required to reach the target date from today
  int calculateTimeToTarget(String targetDate) {
    DateTime today = DateTime.now();
    DateTime target = DateFormat('dd/MM/yyyy').parse(targetDate);
    return target.difference(today).inDays;
  }

  // Determine if the user can reach the target weight by the target date
  // Calculate by using the recommended calorie deficit / time to target > reccommended calorie
  // Function to determine if the user can reach the target weight by the target date
  bool canReachTargetWeight(
    double targetWeight,
    double weight,
    String targetDate,
    String biologicalSex,
    double height,
    int age,
    int calBudget,
  ) {
    // Calculate the total calorie deficit needed to reach the target weight
    int dailyCalorieDeficit = calculateCalorieDeficit(targetWeight, weight, targetDate);

    // Calculate the number of days between the current date and the target date
    int daysDifference = calculateTimeToTarget(targetDate);

    // Calculate the recommended daily calorie intake
    int recommendedCalorieIntake = calculateRecommendedCalories(biologicalSex, weight, height, age);

    // First, check if the user has enough time to reach the target weight
    // Then, check if the user has enough calories to reach the target weight
    // Finally, check if the user has enough calories to maintain their weight
    if (daysDifference > 0 && calBudget >= dailyCalorieDeficit && recommendedCalorieIntake >= dailyCalorieDeficit) {
      return true;
    } else {
      return false;
    }
  }
}
