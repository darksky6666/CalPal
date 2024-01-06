import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart';

class FoodDetectorController extends GetxController {
  var detectionResult = ''.obs;
  var detectionConfidence = ''.obs;

  var _disposed = false;

  // Method to prevent updates after disposal
  void guardedUpdate() {
    if (!_disposed) {
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  late CameraImage cameraImage;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
          }
          guardedUpdate();
        });
      });
      isCameraInitialized.value = true;
      guardedUpdate();
    } else {
      log("Permission denied");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: "assets/models/model.tflite",
      labels: "assets/models/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  // Method to capture an image from the camera
  Future<XFile?> captureImage() async {
    try {
      if (!cameraController.value.isTakingPicture) {
        XFile? imageFile = await cameraController.takePicture();
        return imageFile;
      }
    } catch (e) {
      log("Capture Image Exception: $e");
    }
    return null;
  }

  Future<void> processCapturedImage() async {
    XFile? capturedImage = await captureImage();
    if (capturedImage != null) {
      File imageFile = File(capturedImage.path);
      await objectDetectorFromFile(imageFile);
    } else {
      log("Image capture failed.");
    }
  }

  // Method to pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        File imageFile = File(pickedImage.path);
        await objectDetectorFromFile(imageFile);
      } else {
        log("No image selected.");
      }
    } catch (e) {
      log("Image picking failed: $e");
    }
  }

  // Method to perform object detection on the captured image
  objectDetectorFromFile(File imageFile) async {
    try {
      var detector = await Tflite.runModelOnImage(
        asynch: true,
        path: imageFile.path,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        threshold: 0.4,
      );
      if (detector != null) {
        log("Result is $detector");
        for (var i = 0; i < detector.length; i++) {
          double confidenceValue = detector[i]['confidence'];

          // if (confidenceValue >= 0.6) {
            detectionResult.value = "${detector[i]['label']}";
            detectionConfidence.value = confidenceValue.toStringAsFixed(2);
          //}
        }
      }
    } on Exception catch (e) {
      log("Detector Exception: $e");
    }
  }
}
