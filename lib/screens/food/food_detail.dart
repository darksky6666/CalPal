import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/controllers/nutrition_api.dart';
import 'package:calpal/models/foods.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/food/food_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FoodDetail extends StatefulWidget {
  FoodDetail({super.key, required this.foodName});

  final String foodName;

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  final controller = Get.put(FoodController());
  final nutritionixController = NutritionixController();
  Map<String, dynamic>? foodData;
  String mealType = 'Breakfast';
  final servingSizeController = TextEditingController(text: "10");
  String servingUnit = 'g';
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Fetch data when the widget is initialized
    fetchFoodData();

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
            widget.foodName,
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
                final food = FoodItem(
                  name: widget.foodName,
                  mealType: mealType,
                  servingSize:
                      double.tryParse(servingSizeController.text.trim()) ?? 0.0,
                  servingUnit: servingUnit,
                  calories:
                      (foodData?['nf_calories'] as num?)?.toDouble() ?? 0.0,
                  protein: (foodData?['nf_protein'] as num?)?.toDouble() ?? 0.0,
                  fat: (foodData?['nf_total_fat'] as num?)?.toDouble() ?? 0.0,
                  carbs: (foodData?['nf_total_carbohydrate'] as num?)
                          ?.toDouble() ??
                      0.0,
                );
                controller.createFood(food);
                Navigator.pop(context); // Pop the current screen from the
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          FoodView(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    )); // Push the profile view with PageRouteBuilder
              } catch (e) {
                Fluttertoast.showToast(
                    msg: "Please fill in all the fields with valid data",
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    textColor: Colors.red,
                    fontSize: 16.0);
              }
            },
            child: Text(
              'Add',
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
                      offset: Offset(0, 3))
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
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleName("Meal Details"),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
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
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(value)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
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
                                child: Container(
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
                          Text(
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
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true, signed: false),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleName("Calories and Nutrients Info"),
                      SizedBox(height: 20),
                      NutrientInfoRow("Serving Size (in grams)",
                          "${foodData?['serving_weight_grams']}", "g"),
                      SizedBox(height: 20),
                      NutrientInfoRow(
                          "Calories", "${foodData?['nf_calories']}", "kcal"),
                      SizedBox(height: 20),
                      NutrientInfoRow("Carbohydrate",
                          "${foodData?['nf_total_carbohydrate']}", "g"),
                      SizedBox(height: 20),
                      NutrientInfoRow(
                          "Protein", "${foodData?['nf_protein']}", "g"),
                      SizedBox(height: 20),
                      NutrientInfoRow(
                          "Fat", "${foodData?['nf_total_fat']}", "g"),
                      SizedBox(height: 20),
                      NutrientInfoRow("Saturated Fat",
                          "${foodData?['nf_saturated_fat']}", "g"),
                      SizedBox(height: 20),
                      NutrientInfoRow("Cholesterol",
                          "${foodData?['nf_cholesterol']}", "mg"),
                      SizedBox(height: 20),
                      NutrientInfoRow(
                          "Sodium", "${foodData?['nf_sodium']}", "mg"),
                      SizedBox(height: 20),
                      NutrientInfoRow("Dietary Fiber",
                          "${foodData?['nf_dietary_fiber']}", "g"),
                      SizedBox(height: 20),
                      NutrientInfoRow(
                          "Sugars", "${foodData?['nf_sugars']}", "g"),
                      SizedBox(height: 20),
                      NutrientInfoRow(
                          "Potassium", "${foodData?['nf_potassium']}", "mg"),
                    ]),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 2),
    );
  }

  Row NutrientInfoRow(String title, String value, String unit) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Spacer(),
        Row(children: [
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(width: 5),
          Text(
            unit,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ]),
      ],
    );
  }

  Text TitleName(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
    );
  }
}
