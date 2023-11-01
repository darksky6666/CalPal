import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    // Fetch the user data and populate the form fields
    controller.getUserData().then((UserModel userData) {
      controller.nameController.text = userData.name.toString();
      controller.heightController.text = userData.height.toString();
      controller.weightController.text = userData.weight.toString();
      controller.ageController.text = userData.age.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: const Text(
            'Your Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.gender == '') {
                Fluttertoast.showToast(
                    msg: "Gender cannot be null",
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    textColor: Colors.red,
                    fontSize: 16.0);
              } else {
                final user = UserModel(
                  name: controller.nameController.text.trim(),
                  height: double.parse(controller.heightController.text.trim()),
                  weight: double.parse(controller.weightController.text.trim()),
                  age: int.parse(controller.ageController.text.trim()),
                  biologicalSex: controller.gender.trim(),
                  medicalCondition: controller.medical.trim(),
                );
                UserController.instance.createOrUpdateUserInfo(user);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileView()));
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Wrap(
                children: [
                  Text(
                    "This data will be used to estimate your calorie budget, which uses height, weight, biological sex, and age as inputs.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  // Name
                  InputRow(
                    controller: controller.nameController,
                    label: 'Name',
                    suffixText: "",
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 20),
                  // Height
                  InputRow(
                      controller: controller.heightController,
                      label: 'Height',
                      suffixText: 'cm',
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false)),
                  SizedBox(height: 20),
                  InputRow(
                      controller: controller.weightController,
                      label: 'Weight',
                      suffixText: 'kg',
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false)),
                  SizedBox(height: 20),
                  InputRow(
                      controller: controller.ageController,
                      label: 'Age',
                      suffixText: 'years',
                      keyboardType: TextInputType.number),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Text(
                        "Biological Sex",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: controller.gender,
                        onChanged: (String? newValue) {
                          setState(() {
                            controller.gender = newValue!;
                          });
                        },
                        items: <String>['', 'Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(value)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Text(
                        "Medical Condition",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: controller.medical,
                        onChanged: (String? newValue) {
                          setState(() {
                            controller.medical = newValue!;
                          });
                        },
                        items: <String>['None', 'Heart', 'Diabetes']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(value)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 4),
    );
  }
}

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
    required this.controller,
    required this.label,
    required this.suffixText,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String suffixText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              suffixText: suffixText,
              suffixStyle: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
