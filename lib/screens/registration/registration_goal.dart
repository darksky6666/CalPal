import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/controllers/registration_controller.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/components/input_row.dart';
import 'package:calpal/screens/registration/registration_status.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class RegistrationPage3 extends StatefulWidget {
  const RegistrationPage3(
      {super.key, required this.pageController, required this.totalPages});

  final PageController pageController;
  final int totalPages;

  @override
  State<RegistrationPage3> createState() => _RegistrationPage3State();
}

class _RegistrationPage3State extends State<RegistrationPage3> {
  final AuthService authService = AuthService();
  final registrationController = Get.put(RegistrationController());
  final _formKey = GlobalKey<FormState>();
  double weightDifference = 0;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Set Your Goal",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Setting a goal helps to track your progress.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                ),
                SizedBox(
                  height: 30,
                ),
                InputRow(
                    onChanged: (value) {
                      try {
                        if (value.isNotEmpty ||
                            double.parse(value) > 0 ||
                            double.parse(value) <= 500) {
                          setState(() {
                            weightDifference = double.parse(
                                    registrationController
                                        .targetWeightController.text) -
                                double.parse(registrationController
                                    .weightController.text);
                          });
                        }
                      } catch (e) {
                        setState(() {
                          weightDifference = 0;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      } else {
                        final weight = double.tryParse(value);
                        if (weight == null || weight <= 0 || weight > 500) {
                          return 'Please enter a valid weight';
                        }
                      }
                      return null;
                    },
                    controller: registrationController.targetWeightController,
                    label: "Weight Goal",
                    suffixText: "kg",
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false)),
                SizedBox(
                  height: 15,
                ),
                Text(
                  weightDifference >= 0
                      ? "After 1 month, you will gain $weightDifference kg."
                      : "After 1 month, you will lose ${weightDifference.abs()} kg.",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                InputRow(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter calorie value';
                      } else {
                        final numericRegex = RegExp(r'^[0-9]+$');
                        if (!numericRegex.hasMatch(value)) {
                          return 'Please enter a valid integer calorie value';
                        }
                        int calorieValue = int.tryParse(value) ?? 0;
                        if (calorieValue < 1000 || calorieValue > 3000) {
                          return 'Value must be 1001-2999';
                        }
                      }
                      return null;
                    },
                    controller: registrationController.calBudgetController,
                    label: "Calorie Goal",
                    suffixText: "kcal",
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false)),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      "Suggested: ",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      registrationController.getCalorieBudget().toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      " kcal/day",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "This is an estimated value calculated from your weight, height, biological sex, and age inputs.",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(50, 50),
                  ),
                  maximumSize: MaterialStateProperty.all<Size>(
                    const Size(50, 50),
                  ),
                ),
                icon:
                    const Icon(HeroiconsSolid.chevronLeft, color: Colors.white),
                onPressed: () {
                  widget.pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
              ),
              IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(50, 50),
                  ),
                  maximumSize: MaterialStateProperty.all<Size>(
                    const Size(50, 50),
                  ),
                ),
                icon: const Icon(HeroiconsSolid.check, color: Colors.white),
                onPressed: () async {
                  // After the user has filled the form
                  if (_formKey.currentState!.validate()) {
                    try {
                      authService.registerUserWithEmailAndPassword(
                        registrationController.emailController.text,
                        registrationController.passwordController.text,
                        (bool success, String errorMessage) {
                          if (success) {
                            authService.sendEmailVerify();
                            Fluttertoast.showToast(
                                msg:
                                    "Please check your email to verify your account.",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return RegistrationStatus(success: true);
                              }),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return RegistrationStatus(
                                    success: false, error: errorMessage);
                              }),
                            );
                          }
                        },
                      );
                    } catch (e) {
                      print("Error encountered on view: $e");
                      Fluttertoast.showToast(
                          msg: "Error encountered: $e",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: primaryColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
