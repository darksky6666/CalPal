import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/components/input_row.dart';
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
  String gender = 'Male';
  String medical = 'None';

  @override
  void initState() {
    super.initState();
    // Fetch the user data and populate the form fields
    controller.getUserData().then((UserModel userData) {
      controller.nameController.text = userData.name.toString();
      controller.heightController.text = userData.height.toString();
      controller.weightController.text = userData.weight.toString();
      controller.ageController.text = userData.age.toString();
      gender = userData.biologicalSex.toString();
      medical = userData.medicalCondition.toString();
      setState(() {});
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
              if (gender == '') {
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
                  height: int.parse(controller.heightController.text.trim()),
                  weight: double.parse(controller.weightController.text.trim()),
                  age: int.parse(controller.ageController.text.trim()),
                  biologicalSex: gender.trim(),
                  medicalCondition: medical.trim(),
                );
                UserController.instance.updateUserInfo(user);
                // Pop until the profile view
                Navigator.popUntil(context, ModalRoute.withName('/profile'));
                // Push the profile view with PageRouteBuilder
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ProfileView(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
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
                          decimal: false, signed: false)),
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
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false)),
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
                        value: gender,
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female']
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
                        value: medical,
                        onChanged: (String? newValue) {
                          setState(() {
                            medical = newValue!;
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
