import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:ionicons/ionicons.dart';

class GoalView extends StatefulWidget {
  const GoalView({super.key});

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
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
                          Icon(
                            HeroiconsSolid.faceSmile,
                            color: Colors.green,
                            size: 65,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "On track",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              Text(
                                "You can reach your goal at",
                              ),
                              Text(
                                "22/11/2023",
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
                      Text(
                          "I plan to lose 1 kg in 14 days by eating less than 1832 calories.")
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
                          onTap: () {},
                          child: weightGoalRow(Ionicons.scale_outline,
                              "Current Weight", 70, "kg")),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {},
                        child: weightGoalRow(Ionicons.trail_sign_outline,
                            "Goal Weight", 60, "kg"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {},
                        child: weightGoalRow(Ionicons.calendar_outline,
                            "Target Date", "22/11/2023", ""),
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
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Daily Calories Budget"),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "1900",
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
                        InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Daily Calories Deficit"),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "68",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    HeroiconsSolid.chevronRight,
                                    color: Colors.transparent,
                                    size: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Recommended Daily Calories"),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "1832",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    HeroiconsSolid.chevronRight,
                                    color: Colors.transparent,
                                    size: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
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
