import 'package:calpal/controllers/registration_controller.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/components/input_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class RegistrationPage2 extends StatefulWidget {
  const RegistrationPage2(
      {super.key, required this.pageController, required this.totalPages});

  final PageController pageController;
  final int totalPages;

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
  final registrationController = Get.put(RegistrationController());
  final _formKey = GlobalKey<FormState>();
  String gender = 'Male';
  String medical = 'None';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "Physical Profile",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "This data will be used to estimate your calorie budget, which uses height, weight, biological sex, and age as inputs.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
              ),
              const SizedBox(
                height: 30,
              ),
              InputRow(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    } else {
                      final height = int.tryParse(value);
                      if (height == null || height <= 0 || height > 300) {
                        return 'Please enter a valid height';
                      }
                    }
                    return null;
                  },
                  controller: registrationController.heightController,
                  label: 'Height',
                  suffixText: 'cm',
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: false, signed: false)),
              const SizedBox(height: 20),
              InputRow(
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
                  controller: registrationController.weightController,
                  label: 'Weight',
                  suffixText: 'kg',
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false)),
              const SizedBox(height: 20),
              InputRow(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    } else {
                      final age = int.tryParse(value);
                      if (age == null || age <= 0 || age > 150) {
                        return 'Please enter a valid age';
                      }
                    }
                    return null;
                  },
                  controller: registrationController.ageController,
                  label: 'Age',
                  suffixText: 'years',
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: false, signed: false)),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  const Text(
                    "Biological Sex",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: registrationController.biologicalSex.value,
                    onChanged: (String? newValue) {
                      setState(() {});
                      registrationController.updateBiologicalSex(newValue!);
                    },
                    items: <String>['Male', 'Female']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(value)),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  const Text(
                    "Medical Condition",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: registrationController.medicalCondition.value,
                    onChanged: (String? newValue) {
                      setState(() {});
                      registrationController.updateMedicalCondition(newValue!);
                    },
                    items: <String>['None', 'Heart', 'Diabetes']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(value)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ]),
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
                    duration: const Duration(milliseconds: 500),
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
                icon: const Icon(HeroiconsSolid.chevronRight,
                    color: Colors.white),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
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
