import 'package:calpal/controllers/analysis_controller.dart';
import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/date.dart';
import 'package:calpal/models/foods.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/analysis/nutrient_view.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/components/nutrient_bar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:intl/intl.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  ObjectKey calorieDataKey = const ObjectKey([]);
  bool isExpanded = false;
  final DatePickerController dateController = DatePickerController();
  DateTime selectedDate = DateTime.now();
  final controller = Get.put(AnalysisController());
  final userController = Get.put(UserController());
  final foodController = Get.put(FoodController());
  DateModel dateModel = DateModel();
  double totalCalories = 0.0;
  int percentageCalorie = 0;
  double totalCarbs = 0.0;
  double totalFat = 0.0;
  double totalProtein = 0.0;
  double targetCarbs = 0.0;
  double targetFat = 0.0;
  double targetProtein = 0.0;
  double targetSaturatedFat = 0.0;
  double totalSaturatedFat = 0.0;
  double targetCholesterol = 0.0;
  double totalCholesterol = 0.0;
  double targetSodium = 0.0;
  double totalSodium = 0.0;
  double targetFiber = 0.0;
  double totalFiber = 0.0;
  double targetSugar = 0.0;
  double totalSugar = 0.0;
  double targetPotassium = 0.0;
  double totalPotassium = 0.0;
  String gender = "Male";

  @override
  void initState() {
    super.initState();
    // Fetch the user data and populate the form fields
    userController.getUserData().then((UserModel userData) {
      setState(() {
        userController.calBudgetController.text = userData.calBudget.toString();
        userController.weightController.text = userData.weight.toString();
        userController.ageController.text = userData.age.toString();
        gender = userData.biologicalSex.toString();

        // Update the target values for each nutrient
        targetCarbs = controller.getTargetCarbs(
            double.parse(userController.calBudgetController.text));
        targetFat = controller.getTargetFat(
            double.parse(userController.calBudgetController.text));
        targetProtein = controller.getTargetProtein(
            double.parse(userController.weightController.text));
        targetSaturatedFat = controller.getTargetSaturatedFat(
            double.parse(userController.calBudgetController.text));
        targetCholesterol = controller.getTargetCholesterol();
        targetSodium = controller.getTargetSodium();
        targetFiber = controller.getTargetFiber(
            double.parse(userController.calBudgetController.text),
            int.parse(userController.ageController.text),
            gender);
        targetSugar = controller.getTargetSugar(gender);
        targetPotassium = controller.getTargetPotassium(gender);
      });
    });
    // Update the nutrient totals
    updateNutrientTotals();
  }

  // Fetch the food info for the current date and total up the value for each nutrient
  void updateNutrientTotals() {
    totalCalories = 0.0;
    percentageCalorie = 0;
    totalCarbs = 0.0;
    totalFat = 0.0;
    totalProtein = 0.0;
    totalSaturatedFat = 0.0;
    totalCholesterol = 0.0;
    totalSodium = 0.0;
    totalFiber = 0.0;
    totalSugar = 0.0;
    totalPotassium = 0.0;

    foodController
        .getFoodInfo(DateFormat('yyyyMMdd').format(selectedDate))
        .then((value) {
      for (FoodItem food in value) {
        setState(() {
          totalCalories += food.calories ?? 0;
          totalCarbs += food.carbs ?? 0;
          totalFat += food.fat ?? 0;
          totalProtein += food.protein ?? 0;
          totalSaturatedFat += food.saturatedFat ?? 0;
          totalCholesterol += food.cholesterol ?? 0;
          totalSodium += food.sodium ?? 0;
          totalFiber += food.fiber ?? 0;
          totalSugar += food.sugar ?? 0;
          totalPotassium += food.potassium ?? 0;

          // If this is the last item in the list
          if (value.indexOf(food) == value.length - 1) {
            // Calculate the percentage of the calorie budget
            percentageCalorie = controller.getPercentage(totalCalories,
                double.parse(userController.calBudgetController.text));
          }
        });
      }
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
            '${(selectedDate.subtract(const Duration(days: 6))).day.toString().padLeft(2, '0')}/${(selectedDate.subtract(const Duration(days: 6))).month.toString().padLeft(2, '0')}',
            style: style);
        break;
      case 6:
        text = Text(
            "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}",
            style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 20, left: 5),
            child: GestureDetector(
              onTap: () {
                toggleExpand();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${selectedDate.day.toString().padLeft(2, '0')} ${dateModel.monthAbbreviation[selectedDate.month]} Analysis',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 25),
                  ),
                  const SizedBox(width: 15),
                  isExpanded
                      ? const Icon(
                          HeroiconsSolid.chevronUp,
                          color: Colors.black,
                          size: 22,
                        )
                      : const Icon(HeroiconsSolid.chevronDown,
                          color: Colors.black, size: 22),
                ],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            // Content of Analysis page
            Column(
              children: [
                // Tab Bar
                const TabBar(
                  tabs: [
                    Tab(text: 'Calorie Analysis'),
                    Tab(text: 'Nutrient Analysis'),
                  ],
                  // Customize the indicator color (bottom line)
                  indicatorColor: purpleColor,
                  // Customize the indicator size and shape
                  indicatorSize: TabBarIndicatorSize.label,
                ),

                // Tab Bar View
                Expanded(
                  child: TabBarView(
                    children: [
                      // Calorie Analysis
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
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
                                          offset: const Offset(0, 3))
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Statistics (Last 7 days)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 40),
                                        // Line chart to show calorie intake for the last 7 days
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0),
                                            child: FutureBuilder<List<double>>(
                                              key: calorieDataKey,
                                              future: controller
                                                  .getCalorieData(selectedDate),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          const CircularProgressIndicator());
                                                }

                                                final lineBarsData = [
                                                  LineChartBarData(
                                                    spots: List.generate(
                                                      snapshot.data!.length,
                                                      (index) => FlSpot(
                                                        index.toDouble(),
                                                        double.parse(snapshot
                                                            .data![index]
                                                            .toStringAsFixed(
                                                                2)),
                                                      ),
                                                    ),
                                                    isCurved: true,
                                                    color: purpleColor,
                                                    barWidth: 3,
                                                    isStrokeCapRound: true,
                                                    shadow: Shadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      blurRadius: 8,
                                                    ),
                                                    dotData: const FlDotData(
                                                      show: false,
                                                    ),
                                                    belowBarData: BarAreaData(
                                                      show: false,
                                                    ),
                                                  ),
                                                ];

                                                final tooltipsOnBar =
                                                    lineBarsData[0];
                                                List<int>
                                                    showingTooltipOnSpots = [
                                                  0,
                                                  1,
                                                  2,
                                                  3,
                                                  4,
                                                  5,
                                                  6
                                                ];

                                                return LineChart(
                                                  LineChartData(
                                                    showingTooltipIndicators:
                                                        showingTooltipOnSpots
                                                            .map((index) {
                                                      return ShowingTooltipIndicators([
                                                        LineBarSpot(
                                                          tooltipsOnBar,
                                                          lineBarsData.indexOf(
                                                              tooltipsOnBar),
                                                          tooltipsOnBar
                                                              .spots[index],
                                                        ),
                                                      ]);
                                                    }).toList(),
                                                    titlesData: FlTitlesData(
                                                      show: true,
                                                      rightTitles:
                                                          const AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false),
                                                      ),
                                                      topTitles:
                                                          const AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false),
                                                      ),
                                                      bottomTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          showTitles: true,
                                                          reservedSize: 30,
                                                          interval: 1,
                                                          getTitlesWidget:
                                                              bottomTitleWidgets,
                                                        ),
                                                      ),
                                                      leftTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          showTitles: true,
                                                          interval: 1,
                                                          getTitlesWidget:
                                                              leftTitleWidgets,
                                                          reservedSize: 42,
                                                        ),
                                                      ),
                                                    ),
                                                    borderData: FlBorderData(
                                                      show: false,
                                                    ),
                                                    gridData: const FlGridData(
                                                      show: true,
                                                      drawHorizontalLine: false,
                                                    ),

                                                    // Adjust x and y axis range
                                                    minX: 0,
                                                    maxX: 6,
                                                    minY: 0,
                                                    maxY: controller
                                                        .getNearestThousands(
                                                            snapshot.data),

                                                    extraLinesData:
                                                        ExtraLinesData(
                                                      verticalLines: [
                                                        VerticalLine(
                                                          x: 0,
                                                          strokeWidth: 1,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              171, 186, 194),
                                                          dashArray: [6, 6],
                                                        ),
                                                        VerticalLine(
                                                          x: 6,
                                                          strokeWidth: 1,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              171, 186, 194),
                                                          dashArray: [6, 6],
                                                        ),
                                                      ],
                                                    ),

                                                    lineTouchData:
                                                        LineTouchData(
                                                      enabled: true,
                                                      handleBuiltInTouches:
                                                          false,
                                                      touchTooltipData:
                                                          LineTouchTooltipData(
                                                        tooltipBgColor: Colors
                                                            .white
                                                            .withOpacity(0.1),
                                                        tooltipRoundedRadius:
                                                            100,
                                                        getTooltipItems:
                                                            (List<LineBarSpot>
                                                                lineBarsSpot) {
                                                          return lineBarsSpot
                                                              .map(
                                                                  (lineBarSpot) {
                                                            return LineTooltipItem(
                                                              lineBarSpot.y
                                                                  .toString(),
                                                              const TextStyle(
                                                                color:
                                                                    purpleColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            );
                                                          }).toList();
                                                        },
                                                      ),
                                                    ),

                                                    lineBarsData: lineBarsData,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
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
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Your Calorie Budget",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                child:
                                                    // If the percentage is more than 100, make it red
                                                    percentageCalorie > 100
                                                        ? Text(
                                                            "${percentageCalorie.toString()}%",
                                                            style: const TextStyle(
                                                                fontSize: 36,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                            textAlign:
                                                                TextAlign.end,
                                                          )
                                                        : Text(
                                                            "${percentageCalorie.toString()}%",
                                                            style: const TextStyle(
                                                                fontSize: 36,
                                                                color: Colors
                                                                    .lightGreen,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12),
                                                  child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                double.parse(totalCalories
                                                                        .toStringAsFixed(
                                                                            2))
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color:
                                                                        purpleColor,
                                                                    fontSize:
                                                                        20)),
                                                            Text(
                                                              " / ${userController.calBudgetController.text} kcal",
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          // If the percentage is more than 100, show 'You’ve went over your budget, but that’s okay. Let’s do better tomorrow.'
                                          // Else if the percentage = 0, show 'You haven’t started tracking your calories yet. Let’s start today!'
                                          // Else, show 'You are on track of your budget. Good job!'
                                          percentageCalorie > 100
                                              ? const Text(
                                                  "You’ve went over your budget, but that’s okay. Let’s do better tomorrow.",
                                                  textAlign: TextAlign.justify,
                                                )
                                              : percentageCalorie == 0
                                                  ? const Text(
                                                      "You haven’t started tracking your calories yet. Let’s start today!",
                                                      textAlign:
                                                          TextAlign.justify,
                                                    )
                                                  : const Text(
                                                      "You are on track of your budget. Good job!",
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                        ]),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
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
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Top 3 Contributors to Calories",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 20),
                                        FutureBuilder<List<FoodItem>>(
                                          future: controller.getTopFoodItems(
                                              "calories",
                                              DateFormat('yyyyMMdd')
                                                  .format(selectedDate)),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment: Alignment.center,
                                                  child:
                                                      const CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      "Error: ${snapshot.error}",
                                                      style: const TextStyle(
                                                          color: primaryColor,
                                                          fontSize: 20)));
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                      "No data available",
                                                      style: TextStyle(
                                                          color: primaryColor,
                                                          fontSize: 20)));
                                            } else {
                                              // Display the top 3 contributors based on the fetched data
                                              return Column(
                                                children: snapshot.data!
                                                    .map((foodItem) {
                                                  return Column(
                                                    children: [
                                                      contributorRow(
                                                        foodItem.name ?? "",
                                                        foodItem.calories
                                                            .toString(),
                                                      ),
                                                      const SizedBox(height: 8),
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Nutrient Analysis
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 15, bottom: 15, top: 30),
                            child: Column(
                              children: [
                                const Text(
                                  "Nutrient Breakdown",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Proteins',
                                                  date: selectedDate,
                                                  total: totalProtein,
                                                  target: targetProtein,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Proteins',
                                    consumed: totalProtein,
                                    dailyGoal: targetProtein,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Fat',
                                                  date: selectedDate,
                                                  total: totalFat,
                                                  target: targetFat,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Fat',
                                    consumed: totalFat,
                                    dailyGoal: targetFat,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Carbs',
                                                  date: selectedDate,
                                                  total: totalCarbs,
                                                  target: targetCarbs,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Carbs',
                                    consumed: totalCarbs,
                                    dailyGoal: targetCarbs,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Saturated Fat',
                                                  date: selectedDate,
                                                  total: totalSaturatedFat,
                                                  target: targetSaturatedFat,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Saturated Fat',
                                    consumed: totalSaturatedFat,
                                    dailyGoal: targetSaturatedFat,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Cholesterol',
                                                  date: selectedDate,
                                                  total: totalCholesterol,
                                                  target: targetCholesterol,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Cholesterol',
                                    consumed: totalCholesterol,
                                    dailyGoal: targetCholesterol,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Sodium',
                                                  date: selectedDate,
                                                  total: totalSodium,
                                                  target: targetSodium,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Sodium',
                                    consumed: totalSodium,
                                    dailyGoal: targetSodium,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Dietary Fiber',
                                                  date: selectedDate,
                                                  total: totalFiber,
                                                  target: targetFiber,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Dietary Fiber',
                                    consumed: totalFiber,
                                    dailyGoal: targetFiber,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Sugars',
                                                  date: selectedDate,
                                                  total: totalSugar,
                                                  target: targetSugar,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Sugars',
                                    consumed: totalSugar,
                                    dailyGoal: targetSugar,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NutrientView(
                                                  nutrientName: 'Potassium',
                                                  date: selectedDate,
                                                  total: totalPotassium,
                                                  target: targetPotassium,
                                                )));
                                  },
                                  child: NutrientProgressBar(
                                    nutrientName: 'Potassium',
                                    consumed: totalPotassium,
                                    dailyGoal: targetPotassium,
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Date Picker
            if (isExpanded)
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: DatePicker(
                      selectedDate.subtract(const Duration(days: 5)),
                      dayTextStyle: const TextStyle(
                          color: Colors.transparent, fontSize: 0),
                      controller: dateController,
                      initialSelectedDate: selectedDate,
                      daysCount: 11,
                      selectionColor: purpleColor,
                      selectedTextColor: Colors.white,
                      deactivatedColor: Colors.grey,
                      onDateChange: (date) {
                        setState(() {
                          isExpanded = false;
                          selectedDate = date;
                          calorieDataKey = const ObjectKey([]);
                          updateNutrientTotals();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                    ),
                  )
                ],
              ),
          ],
        ),
        bottomNavigationBar: const BottomNav(currentIndex: 1),
      ),
    );
  }

  Row contributorRow(String foodName, String calorie) {
    return Row(
      children: [
        Text(foodName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: purpleColor,
              fontSize: 15,
            )),
        const Spacer(),
        Row(
          children: [
            Text(
              calorie,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const Text(
              " kcal",
              style: TextStyle(fontSize: 15),
            )
          ],
        )
      ],
    );
  }
}
