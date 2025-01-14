import 'dart:developer';

import 'package:calpal/controllers/health_controller.dart';
import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/components/input_row.dart';
import 'package:calpal/screens/goal/goal_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:intl/intl.dart';

class EditGoal extends StatefulWidget {
  const EditGoal({super.key});

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  final controller = Get.put(UserController());
  final healthController = Get.put(HealthCalculatorController());
  DateTime selectedDate = DateTime.now(); // Initialize with today's date
  String dateAsString = "";
  int recommendedCalories = 0;

  @override
  void initState() {
    super.initState();
    // Fetch the user data and populate the form fields
    controller.getUserData().then((UserModel userData) {
      if (mounted) {
        setState(() {
          controller.ageController.text = userData.age.toString();
          controller.heightController.text = userData.height.toString();
          controller.weightController.text = userData.weight.toString();
          controller.targetWeightController.text =
              userData.targetWeight.toString();
          controller.calBudgetController.text = userData.calBudget.toString();
          if (userData.targetDate != null) {
            selectedDate =
                DateFormat('dd/MM/yyyy').parse(userData.targetDate.toString());
          }
          // Calculate the recommended daily calorie value
          recommendedCalories = healthController.calculateRecommendedCalories(
            userData.biologicalSex.toString(),
            double.parse(controller.weightController.text),
            double.parse(controller.heightController.text),
            int.parse(controller.ageController.text),
          );
        });
      }
    });
  }

  // Function to display the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime calendar = selectedDate;
    // If initialDate is set before the current date, set the initialDate to the current date
    if (selectedDate.isBefore(DateTime.now())) {
      calendar = DateTime.now();
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: calendar,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Edit Goal',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              try {
                final weight = controller.weightController.text.trim();
                final targetWeight =
                    controller.targetWeightController.text.trim();
                final calBudget = controller.calBudgetController.text.trim();
                // Validate weight, targetWeight, and calBudget
                if (weight.isEmpty ||
                    targetWeight.isEmpty ||
                    calBudget.isEmpty ||
                    double.tryParse(weight) == null ||
                    double.tryParse(targetWeight) == null ||
                    int.tryParse(calBudget) == null) {
                  throw const FormatException('Invalid input');
                }
                // Validate calBudget
                if (int.parse(calBudget) < 1000 ||
                    int.parse(calBudget) > 4000) {
                  throw RangeError('Invalid calorie budget');
                }
                final user = UserModel(
                    weight: double.parse(weight),
                    targetWeight: double.parse(targetWeight),
                    targetDate: DateFormat('dd/MM/yyyy').format(selectedDate),
                    calBudget: int.parse(calBudget));
                UserController.instance.updateGoalInfo(user);
                Navigator.popUntil(context, ModalRoute.withName('/profile'));
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const GoalView(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ));
              } catch (e) {
                log(e.toString());
                if (e is RangeError) {
                  Fluttertoast.showToast(
                      msg:
                          "Calorie budget must be between 1000 and 4000 kcal/day",
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      textColor: Colors.red,
                      fontSize: 16.0);
                } else {
                  Fluttertoast.showToast(
                      msg: "Please fill in all the fields with valid data",
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      textColor: Colors.red,
                      fontSize: 16.0);
                }
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 40, right: 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.none,
          child: Column(children: [
            const Text(
              "This data will be used to estimate your calorie budget, which uses height, weight, biological sex, and age as inputs.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            InputRow(
                controller: controller.weightController,
                label: "Current Weight",
                suffixText: "kg",
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false)),
            const SizedBox(height: 20),
            InputRow(
                controller: controller.targetWeightController,
                label: "Target Weight",
                suffixText: "kg",
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false)),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Target Date",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          HeroiconsSolid.calendar,
                          size: 20,
                        ),
                      ),
                      controller: TextEditingController(
                        text: '${selectedDate.toLocal()}'.split(' ')[
                            0], // Display selected date in 'YYYY-MM-DD' format
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 20),
            InputRow(
                controller: controller.calBudgetController,
                label: "Daily Calorie Budget",
                suffixText: "",
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "Suggest: $recommendedCalories kcal/day",
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}
