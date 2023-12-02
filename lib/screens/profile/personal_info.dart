import 'package:calpal/controllers/health_controller.dart';
import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:ionicons/ionicons.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final controller = Get.put(UserController());
  final healthController = Get.put(HealthCalculatorController());
  String sex = "";
  int age = 0;
  int height = 0;
  double weight = 0;
  int bmr = 0;
  double bmi = 0;

  @override
  void initState() {
    super.initState();
    // Fetch the user data and populate the variables
    controller.getUserData().then((UserModel userData) {
      setState(() {
        sex = userData.biologicalSex.toString();
        age = userData.age?.toInt() ?? 0;
        height = userData.height?.toInt() ?? 0;
        weight = userData.weight?.toDouble() ?? 0;

        // Calculate the BMR and BMI
        bmi = healthController.calculateBMI(weight, height.toDouble());
        bmr = healthController.calculateRecommendedCalories(
            sex, weight, height.toDouble(), age);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Personal Info',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              personalRow(Ionicons.male_female_outline, "Sex", sex),
              const SizedBox(height: 20),
              personalRow(HeroiconsOutline.cake, "Age", age.toString()),
              const SizedBox(height: 20),
              personalRow(
                  Ionicons.accessibility_outline, "Height", "$height cm"),
              const SizedBox(height: 20),
              personalRow(Ionicons.scale_outline, "Weight", "$weight kg"),
              const SizedBox(height: 60),
              // calorieRow("Weight Maintenance Calories", "2000",
              //     "This value is the daily food calories needed to maintain your body weight."),
              // SizedBox(height: 20),
              // Use BMR
              calorieRow("BMR Calories", bmr.toString(),
                  "This value is the daily calories your body burns at rest to maintain normal body function."),
              const SizedBox(height: 20),
              // Use BMI
              calorieRow("Body Mass Index - BMI", bmi.toStringAsFixed(2),
                  "BMI is an estimate of your body fat and a good measure of risk for diseases that can occur with overweight."),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text("Your BMI "),
                  Text(
                    bmi.toStringAsFixed(2),
                    style: const TextStyle(
                        color: purpleColor, fontWeight: FontWeight.w600),
                  ),
                  const Text(" is considered "),
                  Text(
                    healthController
                        .classifyBMI(double.parse(bmi.toStringAsFixed(2))),
                    style: const TextStyle(
                        color: purpleColor, fontWeight: FontWeight.w600),
                  ),
                  const Text("."),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
    );
  }

  Column calorieRow(String title, String value, String description) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    color: purpleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          description,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
        )
      ],
    );
  }

  Row personalRow(IconData icon, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey, size: 30),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ],
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
              color: purpleColor, fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ],
    );
  }
}
