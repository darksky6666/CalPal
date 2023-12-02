import 'package:calpal/controllers/analysis_controller.dart';
import 'package:calpal/models/date.dart';
import 'package:calpal/models/foods.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class NutrientView extends StatefulWidget {
  const NutrientView({
    Key? key,
    required this.nutrientName,
    required this.date,
    required this.total,
    required this.target,
  }) : super(key: key);

  final String nutrientName;
  final DateTime date;
  final double total;
  final double target;

  @override
  State<NutrientView> createState() => _NutrientViewState();
}

class _NutrientViewState extends State<NutrientView> {
  int percentage = 0;
  final controller = Get.put(AnalysisController());
  DateModel dateModel = DateModel();
  String queryLabel = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      // Get percentage of nutrient consumed
      percentage = controller.getPercentage(widget.total, widget.target);

      if (widget.nutrientName == "Proteins") {
        queryLabel = "protein";
      } else if (widget.nutrientName == "Fat") {
        queryLabel = "fat";
      } else if (widget.nutrientName == "Carbs") {
        queryLabel = "carbs";
      } else if (widget.nutrientName == "Saturated Fat") {
        queryLabel = "saturatedFat";
      } else if (widget.nutrientName == "Cholesterol") {
        queryLabel = "cholesterol";
      } else if (widget.nutrientName == "Sodium") {
        queryLabel = "sodium";
      } else if (widget.nutrientName == "Dietary Fiber") {
        queryLabel = "fiber";
      } else if (widget.nutrientName == "Sugars") {
        queryLabel = "sugar";
      } else if (widget.nutrientName == "Potassium") {
        queryLabel = "potassium";
      } else {
        queryLabel = "none";
      }
    });
  }

  static Path buildHeartPath(double width, double height) {
    Path path = Path()
      ..moveTo(55, 15)
      ..cubicTo(55, 12, 50, 0, 30, 0)
      ..cubicTo(0, 0, 0, 37.5, 0, 37.5)
      ..cubicTo(0, 55, 20, 77, 55, 95)
      ..cubicTo(90, 77, 110, 55, 110, 37.5)
      ..cubicTo(110, 37.5, 110, 0, 80, 0)
      ..cubicTo(65, 0, 55, 12, 55, 15)
      ..close();

    Rect bounds = path.getBounds();
    double pathWidth = bounds.width;
    double pathHeight = bounds.height;

    double scaleX = width / pathWidth;
    double scaleY = height / pathHeight;

    final scaledPath = path.transform(
      Matrix4.diagonal3Values(scaleX, scaleY, 1.0).storage,
    );

    return scaledPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.date.day.toString().padLeft(2, '0')} ${dateModel.monthAbbreviation[widget.date.month]} - ${widget.nutrientName}',
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              // Nutrient Summary
              Container(
                width: MediaQuery.of(context).size.width,
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
                      top: 15, left: 15, right: 15, bottom: 25),
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Nutrient Summary",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        LiquidCustomProgressIndicator(
                          value: percentage / 100,
                          direction: Axis.vertical,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                              percentage > 100 ? Colors.red : primaryColor),
                          shapePath: buildHeartPath(50, 50),
                        ),
                        // If landscape mode, add more spacing
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            // Landscape mode
                            ? const SizedBox(width: 40)
                            // Portrait mode
                            : percentage > 100
                                ? const SizedBox(width: 15)
                                : const SizedBox(width: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            percentage > 100
                                ? const Text(
                                    "You've exceeded your goal!",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 17),
                                  )
                                : const Text(
                                    "You're on track!",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 17),
                                  ),
                            const SizedBox(height: 5),
                            percentage > 100
                                ? const Text(
                                    "Try to reduce your intake.",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                : const Text(
                                    "Keep it up!",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                          ],
                        )
                      ],
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              // Total Consumed
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total ${widget.nutrientName} Consumed",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child:
                                  // If the percentage is more than 100, make it red
                                  percentage > 100
                                      ? Text(
                                          "${percentage.toString()}%",
                                          style: const TextStyle(
                                              fontSize: 36,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.end,
                                        )
                                      : Text(
                                          "${percentage.toString()}%",
                                          style: const TextStyle(
                                              fontSize: 36,
                                              color: Colors.lightGreen,
                                              fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.end,
                                        ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(widget.total.toStringAsFixed(1),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: purpleColor,
                                                  fontSize: 20)),
                                          if (widget.nutrientName ==
                                                  'Cholesterol' ||
                                              widget.nutrientName == 'Sodium' ||
                                              widget.nutrientName ==
                                                  'Potassium')
                                            Text(
                                              " mg / ${widget.target.toStringAsFixed(1)} mg",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          else
                                            Text(
                                              " g / ${widget.target.toStringAsFixed(1)} g",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        widget.nutrientName == "Proteins"
                            ? const Text(
                                proteinDescription,
                                textAlign: TextAlign.justify,
                              )
                            : widget.nutrientName == "Fat"
                                ? const Text(
                                    fatDescription,
                                    textAlign: TextAlign.justify,
                                  )
                                : widget.nutrientName == "Carbs"
                                    ? const Text(
                                        carbsDescription,
                                        textAlign: TextAlign.justify,
                                      )
                                    : widget.nutrientName == "Saturated Fat"
                                        ? const Text(
                                            saturatedFatDescription,
                                            textAlign: TextAlign.justify,
                                          )
                                        : widget.nutrientName == "Cholesterol"
                                            ? const Text(
                                                cholesterolDescription,
                                                textAlign: TextAlign.justify,
                                              )
                                            : widget.nutrientName == "Sodium"
                                                ? const Text(
                                                    sodiumDescription,
                                                    textAlign:
                                                        TextAlign.justify,
                                                  )
                                                : widget.nutrientName ==
                                                        "Dietary Fiber"
                                                    ? const Text(
                                                        fiberDescription,
                                                        textAlign:
                                                            TextAlign.justify,
                                                      )
                                                    : widget.nutrientName ==
                                                            "Sugars"
                                                        ? const Text(
                                                            sugarDescription,
                                                            textAlign: TextAlign
                                                                .justify,
                                                          )
                                                        : widget.nutrientName ==
                                                                "Potassium"
                                                            ? const Text(
                                                                potassiumDescription,
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              )
                                                            : const Text(
                                                                "Sorry information about this nutrient is not available.",
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
                      ]),
                ),
              ),
              const SizedBox(height: 20),
              // Top 3 Contributors
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Top 3 Contributors",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<FoodItem>>(
                          future: controller.getTopFoodItems(queryLabel,
                              DateFormat('yyyyMMdd').format(widget.date)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: const Text("No data available",
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 20)));
                            } else {
                              // Display the top 3 contributors based on the fetched data
                              return Column(
                                children: snapshot.data!.map((foodItem) {
                                  return Column(
                                    children: [
                                      contributorRow(
                                        foodItem.name ?? "N/A",
                                        // If the nutrient is protein, show the protein value
                                        // Else if the nutrient is fat, show the fat value
                                        // Else if the nutrient is carbs, show the carbs value
                                        // Else show N/A
                                        queryLabel == "protein"
                                            ? foodItem.protein.toString()
                                            : queryLabel == "fat"
                                                ? foodItem.fat.toString()
                                                : queryLabel == "carbs"
                                                    ? foodItem.carbs.toString()
                                                    : queryLabel ==
                                                            "saturatedFat"
                                                        ? foodItem.saturatedFat
                                                            .toString()
                                                        : queryLabel ==
                                                                "cholesterol"
                                                            ? foodItem
                                                                .cholesterol
                                                                .toString()
                                                            : queryLabel ==
                                                                    "sodium"
                                                                ? foodItem
                                                                    .sodium
                                                                    .toString()
                                                                : queryLabel ==
                                                                        "fiber"
                                                                    ? foodItem
                                                                        .fiber
                                                                        .toString()
                                                                    : queryLabel ==
                                                                            "sugar"
                                                                        ? foodItem
                                                                            .sugar
                                                                            .toString()
                                                                        : queryLabel ==
                                                                                "potassium"
                                                                            ? foodItem.potassium.toString()
                                                                            : "N/A",
                                        widget.nutrientName,
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  Row contributorRow(String foodName, String value, String nutrient) {
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
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            if (nutrient == 'Cholesterol' ||
                nutrient == 'Sodium' ||
                nutrient == 'Potassium')
              const Text(
                " mg",
                style: TextStyle(fontSize: 15),
              )
            else
              const Text(
                " g",
                style: TextStyle(fontSize: 15),
              )
          ],
        )
      ],
    );
  }
}
