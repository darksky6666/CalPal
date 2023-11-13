import 'package:calpal/repositories/food_repository.dart';
import 'package:get/get.dart';

class AnalysisController extends GetxController {
  static AnalysisController get instance => Get.find();
  final foodRepo = Get.put(FoodRepository());

  // Get calorie value for last 7 days
  getCalorieData(DateTime date) {
    return foodRepo.getCalorieData(date);
  }

  double getNearestThousands(var data) {
    // Convert the list to a list of doubles
    List numbers = data.map((e) => e.toDouble()).toList();

    // Find the maximum number in the list
    double maxNumber =
        numbers.reduce((value, element) => value > element ? value : element);

    // Round the max number up to the nearest thousand
    double roundedMax = 0;
    if (maxNumber > 1000) {
      roundedMax = (maxNumber / 1000).ceil() * 1000;
    } else {
      roundedMax = 1000;
    }
    return roundedMax;
  }

  // Percentage of nutrient consumed
  int getPercentage(double total, double target) {
    double percentage = (total / target) * 100;

    // Round the percentage to an integer
    int roundedPercentage = percentage.round();
    return roundedPercentage;
  }

  // Get top 3 food items for a particular day
  getTopFoodItems(String nutrient, String date) {
    return foodRepo.getTopFoodItems(nutrient, date);
  }

  // Reference: https://health.gov/sites/default/files/2019-09/2015-2020_Dietary_Guidelines.pdf
  // Get target protein that the user should consume
  double getTargetProtein(double weight) {
    // Target protein is 0.8g per kg of body weight based on the Recommended Dietary Allowance (RDA)
    // Reference: https://www.mayoclinichealthsystem.org/hometown-health/speaking-of-health/are-you-getting-too-much-protein
    return weight * 0.8;
  }

  // Get target fat that the user should consume
  double getTargetFat(double targetCalories) {
    // Target fat is 30% of total calories
    // 1g of fat = 9 calories
    // Reference: https://nutrition.ucdavis.edu/outreach/nutr-health-info-sheets/pro-fat
    return (targetCalories * 0.30) / 9;
  }

  // Get target carbs that the user should consume
  double getTargetCarbs(double targetCalories) {
    // Reference: https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/carbohydrates/art-20045705
    // Target carbs is 50% of total calories
    // 1g of carbs = 4 calories
    return (targetCalories * 0.50) / 4;
  }
}
