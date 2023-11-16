import 'package:calpal/controllers/analysis_controller.dart';
import 'package:calpal/models/date.dart';
import 'package:calpal/models/foods.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
      } else {
        queryLabel = "none";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.date.day.toString().padLeft(2, '0')} ${dateModel.monthAbbreviation[widget.date.month]} - ${widget.nutrientName}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              // Total Consumed
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
                          "Total ${widget.nutrientName} Consumed",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child:
                                  // If the percentage is more than 100, make it red
                                  percentage > 100
                                      ? Text(
                                          "${percentage.toString()}%",
                                          style: TextStyle(
                                              fontSize: 36,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.end,
                                        )
                                      : Text(
                                          "${percentage.toString()}%",
                                          style: TextStyle(
                                              fontSize: 36,
                                              color: Colors.lightGreen,
                                              fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.end,
                                        ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                    decoration: BoxDecoration(
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: purpleColor,
                                                  fontSize: 20)),
                                          Text(
                                            " g / ${widget.target.toStringAsFixed(1)} g",
                                            style: TextStyle(
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
                        SizedBox(height: 20),
                        // If widget.nutrientName is protein, show Your body uses protein to build and repair muscles and bones and to make hormones and enzymes.
                        // Else if widget.nutrientName is fat, show Your body relies on fat as a crucial energy source and uses it to absorb fat-soluble vitamins (A, D, E, and K). Additionally, fat plays a vital role in cell structure, insulation, and the production of hormones.
                        // Else if widget.nutrientName is carbs, show Your body uses carbs as its main fuel source. Complex carbs are broken down into glucose, which is used to fuel cells like those of your brain and muscles. Additionally, carbs are stored in your muscles and liver as glycogen, which is used for energy.
                        // Else show widget.nutrientName is not protein, fat or carbs
                        widget.nutrientName == "Proteins"
                            ? Text(
                                "Your body uses protein to build and repair muscles and bones and to make hormones and enzymes.",
                                textAlign: TextAlign.justify,
                              )
                            : widget.nutrientName == "Fat"
                                ? Text(
                                    "Your body relies on fat as a crucial energy source and uses it to absorb fat-soluble vitamins (A, D, E, and K). Additionally, fat plays a vital role in cell structure, insulation, and the production of hormones.",
                                    textAlign: TextAlign.justify,
                                  )
                                : widget.nutrientName == "Carbs"
                                    ? Text(
                                        "Your body uses carbs as its main fuel source. Complex carbs are broken down into glucose, which is used to fuel cells like those of your brain and muscles. Additionally, carbs are stored in your muscles and liver as glycogen, which is used for energy.",
                                        textAlign: TextAlign.justify,
                                      )
                                    : Text(
                                        "${widget.nutrientName} is not proteins, fat or carbs",
                                        textAlign: TextAlign.justify,
                                      ),
                      ]),
                ),
              ),
              SizedBox(height: 20),
              // Top 3 Contributors
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
                          "Top 3 Contributors",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        FutureBuilder<List<FoodItem>>(
                          future: controller.getTopFoodItems(queryLabel,
                              DateFormat('yyyyMMdd').format(widget.date)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  width:
                                      MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Text("No data available",
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
                                                    : "N/A",
                                      ),
                                      SizedBox(height: 8),
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

  Row contributorRow(String foodName, String value) {
    return Row(
      children: [
        Text(foodName,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: purpleColor,
              fontSize: 15,
            )),
        Spacer(),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              " g",
              style: TextStyle(fontSize: 15),
            )
          ],
        )
      ],
    );
  }
}
