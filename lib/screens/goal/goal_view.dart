import 'package:calpal/controllers/health_controller.dart';
import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:ionicons/ionicons.dart';

class GoalView extends StatefulWidget {
  const GoalView({super.key});

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
  final controller = Get.put(UserController());
  final healthController = Get.put(HealthCalculatorController());
  String targetDate = "";
  int calDeficit = 0;
  int daysToTarget = 0;
  int recommendedCalories = 0;
  double weightDifference = 0;
  bool canReachTargetWeight = false;
  String track = "You can do it!";

  void navigateToEditGoal() {
    Navigator.pushNamed(context, '/edit_goal');
  }

  @override
  void initState() {
    super.initState();
    // Fetch the user data and populate the form fields
    controller.getUserData().then((UserModel userData) {
      setState(() {
        controller.ageController.text = userData.age.toString();
        controller.heightController.text = userData.height.toString();
        controller.weightController.text = userData.weight.toString();
        controller.targetWeightController.text =
            userData.targetWeight.toString();
        controller.calBudgetController.text = userData.calBudget.toString();
        targetDate = userData.targetDate.toString();

        // Calculate the weight difference
        weightDifference = double.parse(controller.weightController.text) -
            double.parse(controller.targetWeightController.text);

        // Calculate calorie deficit with the retrieved data.
        calDeficit = healthController.calculateCalorieDeficit(
          double.parse(controller.weightController.text),
          double.parse(controller.targetWeightController.text),
          targetDate,
        );

        // Calculate the number of days to reach the target date
        daysToTarget = healthController.calculateTimeToTarget(targetDate);

        // Calculate the recommended daily calorie value
        recommendedCalories = healthController.calculateRecommendedCalories(
          userData.biologicalSex.toString(),
          double.parse(controller.weightController.text),
          double.parse(controller.heightController.text),
          int.parse(controller.ageController.text),
        );

        // Determine if the user can reach the target weight by the target date
        canReachTargetWeight = healthController.canReachTargetWeight(
          double.parse(controller.targetWeightController.text),
          double.parse(controller.weightController.text),
          targetDate,
          userData.biologicalSex.toString(),
          double.parse(controller.heightController.text),
          int.parse(controller.ageController.text),
          int.parse(controller.calBudgetController.text),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 5),
          child: Text(
            'Goal',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.none,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 3))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Summary",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (canReachTargetWeight)
                            Icon(
                              HeroiconsSolid.faceSmile,
                              color: Colors.green,
                              size: 65,
                            )
                          else
                            Icon(
                              HeroiconsSolid.faceFrown,
                              color: Colors.red,
                              size: 65,
                            ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (canReachTargetWeight)
                                Text(
                                  "You're on track!",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )
                              else
                                Text(
                                  "Keep going! You can do it!",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              if (canReachTargetWeight)
                                Text(
                                  "You can reach your goal at",
                                )
                              else
                                Text(
                                  "You can't reach your goal at",
                                ),
                              Text(
                                targetDate,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("I plan to keep healthy and lose " +
                          weightDifference.toString() +
                          " kg in " +
                          daysToTarget.toString() +
                          " days by eating less than " +
                          recommendedCalories.toString() +
                          " calories.")
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 3))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Weight Goal",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          onTap: () {
                            navigateToEditGoal();
                          },
                          child: weightGoalRow(
                              Ionicons.scale_outline,
                              "Current Weight",
                              controller.weightController.text,
                              "kg")),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          navigateToEditGoal();
                        },
                        child: weightGoalRow(
                            Ionicons.trail_sign_outline,
                            "Goal Weight",
                            controller.targetWeightController.text,
                            "kg"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          navigateToEditGoal();
                        },
                        child: weightGoalRow(Ionicons.calendar_outline,
                            "Target Date", targetDate, ""),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 3))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Calories Goal",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () {
                              navigateToEditGoal();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Daily Calories Budget"),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.calBudgetController.text,
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      HeroiconsSolid.chevronRight,
                                      size: 20,
                                    ),
                                  ],
                                )
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Recommended Calories Deficit"),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  calDeficit.toString(),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "kcal",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Recommended Daily Calories"),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  recommendedCalories.toString(),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "kcal",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 3),
    );
  }

  Row weightGoalRow(var icon1, String title, var value, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon1,
              color: primaryColor,
            ),
            SizedBox(
              width: 15,
            ),
            Text(title),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(unit),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Icon(
              HeroiconsSolid.chevronRight,
              size: 20,
            ),
          ],
        ),
      ],
    );
  }
}
