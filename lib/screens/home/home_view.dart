import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/models/foods.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/controllers/date_picker.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/text_styling.dart';
import 'package:calpal/screens/home/meals_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:ionicons/ionicons.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(FoodController());
  DateLogic dateLogic = DateLogic();
  List<bool> isSelected = [true, false];
  double totalCalories = 0.0;
  double totalCarbs = 0.0;
  double totalFat = 0.0;
  double totalProtein = 0.0;

  @override
  void initState() {
    super.initState();
    updateNutrientTotals();
  }

  // Fetch the food info for the current date and total up the value for each nutrient
  void updateNutrientTotals() {
    totalCalories = 0.0;
    totalCarbs = 0.0;
    totalFat = 0.0;
    totalProtein = 0.0;

    controller.getFoodInfo(dateLogic.getCurrentDate()).then((value) {
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
              } else if (choice == 'Settings') {
                Fluttertoast.showToast(
                    msg: ("Settings Clicked"),
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pushNamed(context, '/test');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                PopupMenuItem<String>(
                  value: 'Log Out',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
        ],
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //
      //     },
      //     icon: const Icon(Icons.more_vert),
      //   ),
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
                    // Handle view change based on the selected index
                    if (index == 0) {
                      // Day view selected, update your UI accordingly
                    } else {
                      // Week view selected, update your UI accordingly
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
                              "${dateLogic.currentDate.day}/${dateLogic.currentDate.month}",
                              style: TextStyle(fontSize: 18),
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
                                                text: totalCalories.toString()),
                                            textNoBold(
                                                text: ' / ' + '1900 ' + 'Cal')
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
                                                text: totalCarbs.toString()),
                                            textNoBold(text: ' g Carbs,'),
                                            textBold(text: totalFat.toString()),
                                            textNoBold(text: ' g Fat,'),
                                            textBold(
                                                text: totalProtein.toString()),
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
                          dTime: dateLogic.getCurrentDate(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MealsViewPage(
                          mealType: "Lunch",
                          dTime: dateLogic.getCurrentDate(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MealsViewPage(
                          mealType: "Dinner",
                          dTime: dateLogic.getCurrentDate(),
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
                  child: Text('Week View Content'),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 0),
    );
  }
}
