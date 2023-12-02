import 'dart:developer';

import 'package:calpal/controllers/food_alert_controller.dart';
import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/controllers/nutrition_api.dart';
import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/foods.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/home/home_view.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class EditMeal extends StatefulWidget {
  const EditMeal(
      {super.key,
      required this.docId,
      required this.date,
      required this.foodName});

  final String docId;
  final String date;
  final String foodName;

  @override
  State<EditMeal> createState() => _EditMealState();
}

class _EditMealState extends State<EditMeal> {
  final controller = Get.put(FoodController());
  final userController = Get.put(UserController());
  final nutritionixController = NutritionixController();
  Map<String, dynamic>? foodData;
  String mealType = 'Breakfast';
  final servingSizeController = TextEditingController(text: "10");
  String servingUnit = 'g';
  String foodNameDB = '';
  final FocusNode _focusNode = FocusNode();
  FoodAlertController alertController = FoodAlertController();
  Map<String, String>? foodInfo = {};
  String reason = '';
  bool isSuitable = true;

  @override
  void initState() {
    super.initState();

    // Fetch user medical condition
    userController.getUserMedicalCondition().then((String? condition) {
      if (condition != null) {
        log("Debug medical: $condition");
        log("Debug food name: ${widget.foodName}");
        setState(() {
          foodInfo =
              alertController.getFoodInformation(widget.foodName, condition);
          if (foodInfo != null) {
            isSuitable = false;
            reason = foodInfo?['reason'] ?? '';
          } else {
            isSuitable = true;
          }
        });
        log(foodInfo.toString());
        log(isSuitable.toString());
      } else {
        // Handle the case when medical condition is null
        log("User's medical condition is null");
        setState(() {
          isSuitable = true;
        });
      }
    }).catchError((e) {
      // Handle any potential errors that occur during fetching user's medical condition
      log("Error: $e");
      setState(() {
        isSuitable = true;
      });
    });

    // Fetch food data from database with date and docId
    controller.getFoodFromID(widget.date, widget.docId).then((FoodItem food) {
      setState(() {
        foodNameDB = food.name.toString();
        servingSizeController.text = food.servingSize.toString();
        servingUnit = food.servingUnit.toString();
        mealType = food.mealType.toString();
        // Fetch data from Nutritionix API
        fetchFoodData();
      });
    }).catchError((e) {
      log(e);
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        servingSizeController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: servingSizeController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    servingSizeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void fetchFoodData() async {
    // Construct the query based on user selections
    String servingSize = servingSizeController.text;
    String foodName = controller.setPredefinedFood(widget.foodName);

    final data = await nutritionixController.fetchCalorieInfo(
        servingSize, servingUnit, foodName);

    if (data != null && mounted) {
      setState(() {
        foodData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            foodNameDB,
            style: const TextStyle(
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
                final servingSize = servingSizeController.text.trim();
                // Validate serving size before parsing it into double
                if (servingSize.isEmpty ||
                    double.tryParse(servingSize) == null) {
                  throw const FormatException('Invalid serving size');
                }
                if (foodData == null) {
                  throw const FormatException(
                      'Please wait for food data to load');
                }
                // Update the food data
                final food = FoodItem(
                  docId: widget.docId,
                  servingSize: double.parse(servingSize),
                  servingUnit: servingUnit,
                  mealType: mealType,
                  calories: double.parse(foodData!['nf_calories'].toString()),
                  carbs: double.parse(
                      foodData!['nf_total_carbohydrate'].toString()),
                  fat: double.parse(foodData!['nf_total_fat'].toString()),
                  protein: double.parse(foodData!['nf_protein'].toString()),
                  saturatedFat: double.parse(
                      foodData!['nf_saturated_fat']?.toString() ?? '0.0'),
                  cholesterol: double.parse(
                      foodData!['nf_cholesterol']?.toString() ?? '0.0'),
                  sodium:
                      double.parse(foodData!['nf_sodium']?.toString() ?? '0.0'),
                  fiber: double.parse(
                      foodData!['nf_dietary_fiber']?.toString() ?? '0.0'),
                  sugar:
                      double.parse(foodData!['nf_sugars']?.toString() ?? '0.0'),
                  potassium: double.parse(
                      foodData!['nf_potassium']?.toString() ?? '0.0'),
                );
                controller.updateFood(food, widget.date);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const HomeView(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ));
              } on FormatException catch (e) {
                Fluttertoast.showToast(
                    msg: e.message,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    textColor: Colors.red,
                    fontSize: 16.0);
              } catch (e) {
                log(e.toString());
                Fluttertoast.showToast(
                    msg: "Please fill in all the fields with valid data",
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    textColor: Colors.red,
                    fontSize: 16.0);
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.none,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ],
              ),
              height: 250,
              width: MediaQuery.of(context).size.width,
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                controller.getFoodImagePath(widget.foodName.trim()),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            if (isSuitable == false)
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, right: 20, left: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleName("Alert"),
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.center,
                          child: Icon(HeroiconsSolid.faceFrown,
                              color: Colors.red, size: 60)),
                      const SizedBox(height: 10),
                      const Text(
                        "This food is not suitable for your health condition.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Reason:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      ExpandableText(
                        reason,
                        expandText: "show more",
                        collapseText: "show less",
                        animation: true,
                        linkColor: primaryColor,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isSuitable = true;
                              });
                            },
                            child: const Text(
                              "Dismiss",
                              style: TextStyle(
                                  color: purpleColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            if (isSuitable == false) const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleName("Meal Details"),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            "Meal Type",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: mealType,
                            onChanged: (String? newValue) {
                              setState(() {
                                mealType = newValue!;
                              });
                            },
                            items: <String>['Breakfast', 'Lunch', 'Dinner']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(value)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            "Serving Unit",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: servingUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                servingUnit = newValue!;
                              });
                              fetchFoodData();
                            },
                            items: <String>[
                              'g',
                              'piece',
                              'slice',
                              'cup',
                              'tbsp',
                              'ml',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(value)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Serving Size",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: TextFormField(
                              onChanged: (value) {
                                fetchFoodData();
                              },
                              focusNode: _focusNode,
                              controller: servingSizeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleName("Calories and Nutrients Info"),
                      const SizedBox(height: 20),
                      nutrientInfoRow("Serving Size (in grams)",
                          "${foodData?['serving_weight_grams']}", "g"),
                      const SizedBox(height: 20),
                      nutrientInfoRow(
                          "Calories", "${foodData?['nf_calories']}", "kcal"),
                      const SizedBox(height: 20),
                      nutrientInfoRow("Carbohydrate",
                          "${foodData?['nf_total_carbohydrate']}", "g"),
                      const SizedBox(height: 20),
                      nutrientInfoRow(
                          "Protein", "${foodData?['nf_protein']}", "g"),
                      const SizedBox(height: 20),
                      nutrientInfoRow(
                          "Fat", "${foodData?['nf_total_fat']}", "g"),
                      const SizedBox(height: 20),
                      nutrientInfoRow("Saturated Fat",
                          "${foodData?['nf_saturated_fat']}", "g"),
                      const SizedBox(height: 20),
                      nutrientInfoRow("Cholesterol",
                          "${foodData?['nf_cholesterol']}", "mg"),
                      const SizedBox(height: 20),
                      nutrientInfoRow(
                          "Sodium", "${foodData?['nf_sodium']}", "mg"),
                      const SizedBox(height: 20),
                      nutrientInfoRow("Dietary Fiber",
                          "${foodData?['nf_dietary_fiber']}", "g"),
                      const SizedBox(height: 20),
                      nutrientInfoRow(
                          "Sugars", "${foodData?['nf_sugars']}", "g"),
                      const SizedBox(height: 20),
                      nutrientInfoRow(
                          "Potassium", "${foodData?['nf_potassium']}", "mg"),
                    ]),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                minimumSize: MaterialStateProperty.all<Size>(Size(
                    MediaQuery.of(context).size.width * 0.9,
                    40)), // Set the width and height
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Set the border radius
                  ),
                ),
              ),
              onPressed: () {
                // Delete the food data
                controller.deleteFood(widget.docId, widget.date);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const HomeView(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ));
              },
              child: const Text(
                'Delete food',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Row nutrientInfoRow(String title, String value, String unit) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const Spacer(),
        Row(children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(width: 5),
          Text(
            unit,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ]),
      ],
    );
  }

  Text titleName(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
    );
  }
}
