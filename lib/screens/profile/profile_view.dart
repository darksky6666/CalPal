import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/controllers/user_controller.dart';
import 'package:calpal/models/users.dart';
import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/profile/about_app.dart';
import 'package:calpal/screens/profile/account_info.dart';
import 'package:calpal/screens/profile/edit_user.dart';
import 'package:calpal/screens/profile/personal_info.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(UserController());
  String name = " ";
  @override
  void initState() {
    super.initState();
    // Fetch the user data and populate the name
    controller.getUserData().then((UserModel userData) {
      setState(() {
        name = userData.name.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20, left: 5),
          child: Text(
            'User Profile',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const UserProfile()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            CircularProfileAvatar(
                              '', // Change image here
                              radius: 25,
                              backgroundColor: Colors.white,
                              showInitialTextAbovePicture: true,
                              imageFit: BoxFit.cover,
                              initialsText: Text(
                                name[0],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          HeroiconsSolid.chevronRight,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // Information
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, left: 13, right: 10, bottom: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Information',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PersonalInfo()));
                          },
                          child: const Row(
                            children: [
                              Text('Personal Info',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300)),
                              Spacer(),
                              Icon(
                                HeroiconsSolid.chevronRight,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // Account
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, left: 13, right: 10, bottom: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AccountInfo()));
                          },
                          child: const Row(
                            children: [
                              Text('Account Settings',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300)),
                              Spacer(),
                              Icon(
                                HeroiconsSolid.chevronRight,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AboutApp()));
                          },
                          child: const Row(
                            children: [
                              Text('About App',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300)),
                              Spacer(),
                              Icon(
                                HeroiconsOutline.informationCircle,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            // Show alert dialog to confirm account deletion
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm log out?"),
                                  content:
                                      const Text("Are you sure you want to log out?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the alert dialog
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the alert dialog
                                        AuthService().signOut();
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
                                        Navigator.pushReplacementNamed(
                                            context, '/');
                                      },
                                      child: const Text(
                                        "Logout",
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Row(
                            children: [
                              Text('Log out',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300)),
                              Spacer(),
                              Icon(
                                Icons.logout,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
    );
  }
}
