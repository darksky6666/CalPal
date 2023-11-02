import 'dart:io';

import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/controllers/image_classification_helper.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class FoodView extends StatefulWidget {
  const FoodView({Key? key}) : super(key: key);

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  ImageClassificationHelper? imageClassificationHelper;
  Map<String, double>? classification;
  String? imagePath;
  final imagePicker = ImagePicker();
  img.Image? image;

  final controller = Get.put(FoodController());

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
  }

  // Clean old results when press some take picture button
  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

  // Process picked image
  Future<void> processImage() async {
    MapEntry<String, double> eresult = MapEntry('', 0.0);
    if (imagePath != null) {
      // Read image bytes from file
      final imageData = File(imagePath!).readAsBytesSync();

      // Decode image using package:image/image.dart (https://pub.dev/image)
      image = img.decodeImage(imageData);
      setState(() {});
      classification = await imageClassificationHelper?.inferenceImage(image!);
      setState(() {});
    }
    if (classification != null) {
      (classification!.entries.toList()
            ..sort(
              (a, b) => a.value.compareTo(b.value),
            ))
          .reversed
          .take(1)
          .forEach(
            (e) => eresult = e,
          );

      if (eresult.value > 0.5) {
        controller.searchController.text = eresult.key.trim();
        controller.filterSuggestions(eresult.key.trim());
      } else {
        controller.searchController.text = "";
        controller.filterSuggestions("");
        Fluttertoast.showToast(
          msg: "No food detected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          textColor: Colors.red,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  void dispose() {
    controller.searchController.dispose();
    imageClassificationHelper?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 5),
          child: Text(
            'Meals',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: Column(
          children: [
            buildSearchBar(),
            SizedBox(height: 15),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.filteredSuggestions.length + 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        index == 0
                            ? buildListItem(context, "Create food")
                            : buildListItem(context,
                                controller.filteredSuggestions[index - 1].name),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 2),
    );
  }

  Widget buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
              hintText: "Search...",
              hintStyle: TextStyle(
                color: Color.fromRGBO(60, 60, 67, 0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              controller.filterSuggestions(query);
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            cleanResult();
            final result = await imagePicker.pickImage(
              source: ImageSource.camera,
            );

            imagePath = result?.path;
            setState(() {});
            processImage();
            if (imagePath != null) {
              Fluttertoast.showToast(
                msg: "Image selected: $imagePath",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.greenAccent.withOpacity(0.1),
                textColor: Colors.green,
                fontSize: 16.0,
              );
            } else {
              Fluttertoast.showToast(
                msg: "Camera Error",
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                textColor: Colors.red,
                fontSize: 16.0,
              );
            }
          },
          child: Container(
            width: 40,
            height: 40,
            child: Icon(
              HeroiconsSolid.camera,
              color: primaryColor,
            ),
          ),
        )
      ],
    );
  }

  Widget buildListItem(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        Fluttertoast.showToast(
          msg: text == "Create food"
              ? "Create food clicked"
              : "Food $text clicked",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          textColor: Colors.green,
          fontSize: 16.0,
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                clipBehavior: Clip.none,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Icon(
                        text == "Create food"
                            ? HeroiconsSolid.plus
                            : HeroiconsSolid.plus,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(width: 20),
                    if (text == "Create food")
                      Container(
                        width: 100, // Adjust the width as needed
                        child: Text(
                          text,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Spacer(),
              Icon(HeroiconsSolid.chevronRight),
            ],
          ),
        ],
      ),
    );
  }
}
