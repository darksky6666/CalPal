import 'dart:io';
import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/controllers/image_classification_helper.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/food/food_detail.dart';
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
  bool isLoading = true;

  final controller = Get.put(FoodController());

  @override
  void initState() {
    initializeHelper();
    super.initState();
  }

  // Function to simulate loading and initialize helper
  void initializeHelper() {
    Future.delayed(Duration.zero, () async {
      // Initialize your helper here
      imageClassificationHelper = ImageClassificationHelper();
      try {
        // Update the state to stop showing the loading indicator
        await imageClassificationHelper!.initHelper();
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        // Do nothing
      }
      controller.filterSuggestions("");
    });
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Column(
              children: [
                buildSearchBar(),
                SizedBox(height: 15),
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            buildListItem(
                                context,
                                controller.filteredSuggestions[index].name
                                    .toString()),
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

          // Loading indicator
          if (isLoading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white.withOpacity(0.9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: purpleColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Loading data...",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
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
            if (imagePath == null) {
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
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FoodDetail(foodName: text);
        }));
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
                        color: text == "Create food"
                            ? Colors.grey.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: text == "Create food"
                          ? Icon(
                              HeroiconsSolid.plus,
                              color: primaryColor,
                            )
                          : Image.asset(
                              controller.getFoodImagePath(text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 20),
                    if (text == "Create food")
                      Container(
                        width: 100,
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
