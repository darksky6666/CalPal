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

  // Get target saturated fat that the user should consume
  double getTargetSaturatedFat(double targetCalories) {
    // Reference: https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/fat/art-20045550
    // Target saturated fat is 5% of total calories
    // 1g of saturated fat = 9 calories
    return (targetCalories * 0.05) / 9;
  }

  // Get target cholesterol that the user should consume
  double getTargetCholesterol() {
    // Reference: https://www.ahajournals.org/doi/10.1161/01.cir.102.18.2284
    // Target cholesterol is 300mg per day
    return 300;
  }

  // Get target sodium that the user should consume
  double getTargetSodium() {
    // Reference: https://www.fda.gov/food/nutrition-education-resources-materials/sodium-your-diet
    // Target sodium is 2300mg per day
    return 2300;
  }

  // Get target fiber that the user should consume
  double getTargetFiber(double targetCalories, int age, String gender) {
    // Reference: https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/fiber/art-20043983
    // 38 grams for Male aged 50 or younger or 30 grams for Male aged 51 or older
    // 25 grams for Female aged 50 or younger or 21 grams for Female aged 51 or older
    double targetFiber;
    if (gender.toLowerCase() == 'male') {
      if (age <= 50) {
        targetFiber = 38; // grams for males aged 50 or younger
      } else {
        targetFiber = 30; // grams for males aged 51 or older
      }
    } else if (gender.toLowerCase() == 'female') {
      if (age <= 50) {
        targetFiber = 25; // grams for females aged 50 or younger
      } else {
        targetFiber = 21; // grams for females aged 51 or older
      }
    } else {
      targetFiber =
          0; // Set default value to 0 if gender is not specified or recognized
    }
    return targetFiber;
  }

  // Get target sugar that the user should consume
  double getTargetSugar(String gender) {
    // Reference: https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/sugar/how-much-sugar-is-too-much
    double targetSugar;

    if (gender.toLowerCase() == 'male') {
      targetSugar = 36; // grams for men
    } else {
      targetSugar = 25; // grams for women
    }

    return targetSugar;
  }

  // Get target potassium that the user should consume
  double getTargetPotassium(String gender) {
    // Reference: https://www.heart.org/en/health-topics/high-blood-pressure/changes-you-can-make-to-manage-high-blood-pressure/how-potassium-can-help-control-high-blood-pressure
    // 3400mg for Male and 2600mg for Female
    double targetPotassium;
    if (gender.toLowerCase() == "male") {
      targetPotassium = 3400;
    } else {
      targetPotassium = 2600;
    }
    return targetPotassium;
  }
}
