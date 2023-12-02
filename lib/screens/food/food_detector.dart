import 'dart:developer';

import 'package:calpal/controllers/food_controller.dart';
import 'package:calpal/controllers/image_detector_controller.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/food/food_detail.dart';
import 'package:calpal/screens/food/food_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class FoodDetector extends StatefulWidget {
  const FoodDetector({super.key});

  @override
  State<FoodDetector> createState() => _FoodDetectorState();
}

class _FoodDetectorState extends State<FoodDetector> {
  final FoodDetectorController fdController = FoodDetectorController();
  final searchController = Get.put(FoodController());
  String foodName = '';

  void navigationPage(bool isFoodDetected) {
    if (isFoodDetected) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FoodDetail(foodName: foodName),
        ),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const FoodView(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        ModalRoute.withName('/'),
      );
    }
  }

  @override
  void dispose() {
    fdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FoodDetectorController>(
        init: fdController,
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? OrientationBuilder(
                  builder: (context, orientation) {
                    return Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 0.8
                              : MediaQuery.of(context).size.height * 0.7,
                          child: CameraPreview(controller.cameraController),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 0.2
                              : MediaQuery.of(context).size.height * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 40,
                                child: IconButton(
                                  iconSize: 45,
                                  onPressed: () async {
                                    // Call the method to pick an image from the gallery
                                    await controller.pickImageFromGallery();
                                    log("Food name from detection: ${controller.detectionResult.value}");
                                    if (controller.detectionResult.value !=
                                        '') {
                                      log("Food detected!");
                                      foodName =
                                          searchController.foodDetectionSearch(
                                              controller.detectionResult.value);
                                      log("Food name from food controller: $foodName");
                                      navigationPage(true);
                                    } else {
                                      log("No food detected.");
                                      Fluttertoast.showToast(
                                          msg:
                                              "No food detected. Please try again.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      navigationPage(false);
                                    }
                                  },
                                  icon: const Icon(HeroiconsOutline.photo),
                                  color: purpleColor,
                                ),
                              ),
                              orientation == Orientation.portrait
                                  ? const SizedBox(width: 40)
                                  : const SizedBox(width: 80),
                              CircleAvatar(
                                backgroundColor: purpleColor,
                                radius: 40,
                                child: IconButton(
                                  iconSize: 45,
                                  onPressed: () async {
                                    // Call the method to capture an image from the camera
                                    await controller.processCapturedImage();
                                    log("Food name from detection: ${controller.detectionResult.value}");
                                    if (controller.detectionResult.value !=
                                        '') {
                                      log("Food detected!");
                                      foodName =
                                          searchController.foodDetectionSearch(
                                              controller.detectionResult.value);
                                      log("Food name from food controller: $foodName");
                                      navigationPage(true);
                                    } else {
                                      log("No food detected.");
                                      Fluttertoast.showToast(
                                          msg:
                                              "No food detected. Please try again.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      navigationPage(false);
                                    }
                                  },
                                  icon: const Icon(HeroiconsOutline.camera),
                                  color: Colors.white,
                                ),
                              ),
                              orientation == Orientation.portrait
                                  ? const SizedBox(width: 40)
                                  : const SizedBox(width: 80),
                              const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 40,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 30),
                      Text('Loading Camera...',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
