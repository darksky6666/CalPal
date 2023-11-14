import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/foods.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/controllers/date_picker.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/text_styling.dart';
import 'package:calpal/screens/home/meals_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ionicons/ionicons.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final userController = Get.put(UserController());
  final controller = Get.put(FoodController());
  DateLogic dateLogic = DateLogic();
  List<bool> isSelected = [true, false];
  double totalCalories = 0.0;
  double totalCarbs = 0.0;
  double totalFat = 0.0;
  double totalProtein = 0.0;
  List<double> totalCaloriesWeek = List.filled(7, 0.0);
  List<double> totalCarbsWeek = List.filled(7, 0.0);
  List<double> totalFatWeek = List.filled(7, 0.0);
  List<double> totalProteinWeek = List.filled(7, 0.0);

  @override
  void initState() {
    super.initState();
    // Fetch the user data and populate the form fields
    userController.getUserData().then((UserModel userData) {
      setState(() {
        userController.calBudgetController.text = userData.calBudget.toString();
      });
    });
  }

  // Fetch the food info for the current date and total up the value for each nutrient
  void updateNutrientTotals() {
    totalCalories = 0.0;
    totalCarbs = 0.0;
    totalFat = 0.0;
    totalProtein = 0.0;

    controller.getFoodInfo(dateLogic.getFormattedDate()).then((value) {
      for (FoodItem food in value) {
        setState(() {
          totalCalories += food.calories ?? 0;
          totalCarbs += food.carbs ?? 0;
          totalFat += food.fat ?? 0;
          totalProtein += food.protein ?? 0;
        });
      }
    });
  }

  // Fetch food info for the selected week
  void updateNutrientTotalsForWeek() {
    // Reset the lists before calculating totals
    totalCaloriesWeek = List.filled(7, 0.0);
    totalCarbsWeek = List.filled(7, 0.0);
    totalFatWeek = List.filled(7, 0.0);
    totalProteinWeek = List.filled(7, 0.0);

    // Calculate totals for each day in the selected week
    for (int i = 0; i < 7; i++) {
      DateTime currentDate = dateLogic.getCurrentDate().add(Duration(days: i));

      controller
          .getFoodInfo(dateLogic.getFormattedDate(currentDate))
          .then((value) {
        double dailyCalories = 0.0;
        double dailyCarbs = 0.0;
        double dailyFat = 0.0;
        double dailyProtein = 0.0;

        for (FoodItem food in value) {
          dailyCalories += food.calories ?? 0;
          dailyCarbs += food.carbs ?? 0;
          dailyFat += food.fat ?? 0;
          dailyProtein += food.protein ?? 0;
        }

        // Update the lists with the totals for the current day
        setState(() {
          totalCaloriesWeek[i] = dailyCalories;
          totalCarbsWeek[i] = dailyCarbs;
          totalFatWeek[i] = dailyFat;
          totalProteinWeek[i] = dailyProtein;
        });
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
            'Home',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String choice) {
              // Handle menu item selection here
              if (choice == 'Log Out') {
                AuthService().signOut();
                Navigator.popAndPushNamed(context, '/');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Log Out',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.none,
          child: Column(
            children: <Widget>[
              ToggleButtons(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Center(
                        child: Text(
                      'Day',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Center(
                        child: Text(
                      'Week',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                  ),
                ],
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    // Toggle the selection
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      isSelected[buttonIndex] = buttonIndex == index;
                    }
                    if (isSelected[0]) {
                      dateLogic.currentDate = DateTime.now();
                      updateNutrientTotals();
                    } else {
                      dateLogic.currentDate =
                          dateLogic.getStartOfWeek(dateLogic.getCurrentDate());
                      updateNutrientTotalsForWeek();
                    }
                  });
                },
                selectedColor: Colors.white,
                fillColor: Color.fromRGBO(64, 78, 108, 1),
                borderRadius: BorderRadius.circular(10),
                disabledColor: Color.fromRGBO(241, 246, 249, 1),
              ),
              // Your content for the selected view goes here
              if (isSelected[0]) // Day view
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // Change Picker View
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(HeroiconsSolid.chevronLeft),
                              onPressed: () {
                                setState(() {
                                  dateLogic.navigateToPreviousDay();
                                  updateNutrientTotals();
                                });
                              },
                            ),
                            Spacer(),
                            Text(
                              intl.DateFormat('dd MMM')
                                  .format(dateLogic.getCurrentDate())
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(HeroiconsSolid.chevronRight),
                              onPressed: () {
                                setState(() {
                                  dateLogic.navigateToNextDay();
                                  updateNutrientTotals();
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Overview Container
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: purpleColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, bottom: 5, top: 5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: titleText(
                                      text: 'Overview',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                // Calorie in Overview
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 20,
                                        child: Icon(HeroiconsSolid.fire,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                          width: 60,
                                          child: textNoBold(
                                            text: 'Calories',
                                          )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          textDirection: TextDirection.ltr,
                                          children: [
                                            textBold(
                                                text: double.parse(totalCalories
                                                        .toStringAsFixed(2))
                                                    .toString()),
                                            textNoBold(
                                                text: ' / ' +
                                                    userController
                                                        .calBudgetController
                                                        .text +
                                                    ' kcal')
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Nutrient in Overview
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                          width: 20,
                                          child: Icon(Ionicons.pizza_outline,
                                              color: Colors.white)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                          width: 60,
                                          child: textNoBold(text: 'Nutrients')),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          textDirection: TextDirection.ltr,
                                          children: [
                                            textBold(
                                                text: double.parse(totalCarbs
                                                        .toStringAsFixed(2))
                                                    .toString()),
                                            textNoBold(text: ' g Carbs, '),
                                            textBold(
                                                text: double.parse(totalFat
                                                        .toStringAsFixed(2))
                                                    .toString()),
                                            textNoBold(text: ' g Fat, '),
                                            textBold(
                                                text: double.parse(totalProtein
                                                        .toStringAsFixed(2))
                                                    .toString()),
                                            textNoBold(text: ' g Protein'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        MealsViewPage(
                          mealType: "Breakfast",
                          dTime: dateLogic.getFormattedDate(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MealsViewPage(
                          mealType: "Lunch",
                          dTime: dateLogic.getFormattedDate(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MealsViewPage(
                          mealType: "Dinner",
                          dTime: dateLogic.getFormattedDate(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              if (isSelected[1]) // Week view
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // Change Picker View
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(HeroiconsSolid.chevronLeft),
                              onPressed: () {
                                setState(() {
                                  dateLogic.navigateToPreviousWeek();
                                  updateNutrientTotalsForWeek();
                                });
                              },
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                  "Week ${dateLogic.getWeekNumber(dateLogic.getCurrentDate())}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "${intl.DateFormat('dd MMM').format(dateLogic.getCurrentDate())} - "
                                  "${intl.DateFormat('dd MMM').format(dateLogic.getCurrentDate().add(Duration(days: 6)))}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(HeroiconsSolid.chevronRight),
                              onPressed: () {
                                setState(() {
                                  dateLogic.navigateToNextWeek();
                                  updateNutrientTotalsForWeek();
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        // Meals for the week
                        Column(
                          children: List.generate(
                              7, (index) => buildDayWidget(index)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 0),
    );
  }

  Widget buildDayWidget(int index) {
    // Use the totals for the week view
    double dailyCalories = totalCaloriesWeek[index];
    double dailyCarbs = totalCarbsWeek[index];
    double dailyFat = totalFatWeek[index];
    double dailyProtein = totalProteinWeek[index];

    return Column(
      children: [
        // Overview Container
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: purpleColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: titleText(
                      text: intl.DateFormat('EEEE, dd MMM')
                          .format(dateLogic
                              .getCurrentDate()
                              .add(Duration(days: index)))
                          .toString(),
                      color: Colors.white,
                    ),
                  ),
                ),
                // Calorie in Overview
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Container(
                        width: 20,
                        child: Icon(HeroiconsSolid.fire, color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      Container(width: 60, child: textNoBold(text: 'Calories')),
                      SizedBox(width: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: Wrap(
                          direction: Axis.horizontal,
                          textDirection: TextDirection.ltr,
                          children: [
                            // Update the value for the current date
                            textBold(
                                text: double.parse(
                                        dailyCalories.toStringAsFixed(2))
                                    .toString()),
                            textNoBold(
                                text: ' / ' +
                                    userController.calBudgetController.text +
                                    ' kcal')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Nutrient in Overview
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Container(
                          width: 20,
                          child: Icon(Ionicons.pizza_outline,
                              color: Colors.white)),
                      SizedBox(width: 20),
                      Container(
                          width: 60, child: textNoBold(text: 'Nutrients')),
                      SizedBox(width: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: Wrap(
                          direction: Axis.horizontal,
                          textDirection: TextDirection.ltr,
                          children: [
                            // Update the value for the current date
                            textBold(
                                text:
                                    double.parse(dailyCarbs.toStringAsFixed(2))
                                        .toString()),
                            textNoBold(text: ' g Carbs, '),
                            textBold(
                                text: double.parse(dailyFat.toStringAsFixed(2))
                                    .toString()),
                            textNoBold(text: ' g Fat, '),
                            textBold(
                                text: double.parse(
                                        dailyProtein.toStringAsFixed(2))
                                    .toString()),
                            textNoBold(text: ' g Protein'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        MealsViewPage(
          mealType: "Breakfast",
          dTime: intl.DateFormat('yyyyMMdd')
              .format(dateLogic.getCurrentDate().add(Duration(days: index))),
        ),
        SizedBox(height: 20),
        MealsViewPage(
          mealType: "Lunch",
          dTime: intl.DateFormat('yyyyMMdd')
              .format(dateLogic.getCurrentDate().add(Duration(days: index))),
        ),
        SizedBox(height: 20),
        MealsViewPage(
          mealType: "Dinner",
          dTime: intl.DateFormat('yyyyMMdd')
              .format(dateLogic.getCurrentDate().add(Duration(days: index))),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
