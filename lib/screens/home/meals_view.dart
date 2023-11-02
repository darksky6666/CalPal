import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/models/foods.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/components/text_styling.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MealsViewPage extends StatefulWidget {
  MealsViewPage({Key? key, required this.mealType, required this.dTime}) : super(key: key);

  final String mealType;
  final String dTime;

  @override
  State<MealsViewPage> createState() => _MealsViewPageState();
}

class _MealsViewPageState extends State<MealsViewPage> {
  final controller = Get.put(FoodController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          // Text('Content for ${date.toLocal()}'),
          Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.black, width: 1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
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
                    text: widget.mealType,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),

                // Food item
                child: FutureBuilder<List<FoodItem>>(
                  future: FoodController.instance.getMealDetails(
                      widget.dTime, widget.mealType),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Container(
                            child: Text('No data',
                                style: TextStyle(
                                    fontSize: 20, color: primaryColor)));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg: "This is Center Short Toast",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                              child: Row(children: [
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Colors.black,
                                    ),
                                    child: Image(
                                        height: 60,
                                        width: 60,
                                        image: AssetImage(
                                            'assets/icons/calpal_icon.png'))), // Food image
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        children: [
                                          Text(
                                            snapshot.data![index]
                                                .name, // Food name from Firebase
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                        children: [
                                          Text(
                                            "${snapshot.data![index].servingSize} ${snapshot.data![index].servingUnit} - ${snapshot.data![index].calories} Cal", // Food weight, serving unit, and calories
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            );
                          },
                        );
                      }
                    } else {
                      return Container(
                        child: Text('Error',
                            style: TextStyle(fontSize: 20, color: Colors.red)),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
