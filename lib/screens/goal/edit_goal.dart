import 'package:calpal/controllers/health_controller.dart';
import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/components/input_row.dart';
import 'package:calpal/screens/goal/goal_view.dart';
import 'package:flutter/material.dart';
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
    });
  }

  // Function to display the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: const Text(
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
              final user = UserModel(
                  weight: double.parse(controller.weightController.text),
                  targetWeight:
                      double.parse(controller.targetWeightController.text),
                  targetDate: DateFormat('dd/MM/yyyy').format(selectedDate),
                  calBudget: int.parse(controller.calBudgetController.text));
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
            },
            child: Text(
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
            Text(
              "This data will be used to estimate your calorie budget, which uses height, weight, biological sex, and age as inputs.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 20),
            InputRow(
                controller: controller.weightController,
                label: "Current Weight",
                suffixText: "kg",
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false)),
            SizedBox(height: 20),
            InputRow(
                controller: controller.targetWeightController,
                label: "Target Weight",
                suffixText: "kg",
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false)),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
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
                      decoration: InputDecoration(
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
            SizedBox(height: 20),
            InputRow(
                controller: controller.calBudgetController,
                label: "Daily Calorie Budget",
                suffixText: "",
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "Suggest: " + recommendedCalories.toString() + " kcal/day",
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
