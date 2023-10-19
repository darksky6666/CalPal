import 'package:calpal/constants.dart';
import 'package:calpal/controllers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<bool> isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: const Text(
            'Home',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String choice) {
              // Handle menu item selection here
              if (choice == 'Log Out') {
                AuthService().signOut();
                Navigator.pushNamed(context, '/');
              } else if (choice == 'Settings') {
                Fluttertoast.showToast(
                    msg: ("Settings Clicked"),
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                PopupMenuItem<String>(
                  value: 'Log Out',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
        ],
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //
      //     },
      //     icon: const Icon(Icons.more_vert),
      //   ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ToggleButtons(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: Center(
                      child: Text(
                    'Day',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: Center(
                      child: Text(
                    'Week',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                ),
              ],
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  // Toggle the selection
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    isSelected[buttonIndex] = buttonIndex == index;
                  }
                  // Handle view change based on the selected index
                  if (index == 0) {
                    // Day view selected, update your UI accordingly
                  } else {
                    // Week view selected, update your UI accordingly
                  }
                });
              },
              selectedColor: Colors.white,
              fillColor: Color.fromRGBO(64, 78, 108, 1),
              borderRadius: BorderRadius.circular(10),
              disabledColor: Color.fromRGBO(241, 246, 249, 1),
            ),
            // Your content for the selected view goes here
            if (isSelected[0]) // Day view
              SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // Change Picker View
                        Text("day"),
                        SizedBox(
                          height: 20,
                        ),
                        // Overview Container
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: purpleColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Overview',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                // Calorie in Overview
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 20,
                                        child: Icon(HeroiconsSolid.fire,
                                            color: Colors.white),
                                      ),
                                      Container(
                                          width: 55,
                                          child: textNoBold(
                                            text: 'Calorie',
                                          )),
                                      Container(
                                        width: 200,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          crossAxisAlignment: WrapCrossAlignment
                                              .center, // WrapAlignment.center,
                                          textDirection: TextDirection.ltr,
                                          children: [
                                            textBold(text: '1200'),
                                            textNoBold(
                                                text: ' / ' + '1900 ' + 'Cal')
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // Nutrient in Overview
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 20,
                                        child: ImageIcon(
                                          AssetImage(
                                              'assets/icons/watermelon_icon.png'),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                          width: 55,
                                          child: textNoBold(text: 'Nutrient')),
                                      Container(
                                        width: 200,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          crossAxisAlignment: WrapCrossAlignment
                                              .center, // WrapAlignment.center,
                                          textDirection: TextDirection.ltr,
                                          children: [
                                            textBold(text: '1200'),
                                            textNoBold(text: ' g Carbs,'),
                                            textBold(text: '100'),
                                            textNoBold(text: ' g Fat,'),
                                            textBold(text: '1600'),
                                            textNoBold(text: ' g Protein'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (isSelected[1]) // Week view
              Center(
                child: Text('Week View Content'),
              ),
          ],
        ),
      ),
    );
  }
}

class textBold extends StatelessWidget {
  final String text;
  const textBold({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
    );
  }
}

class textNoBold extends StatelessWidget {
  final String text;
  const textNoBold({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
    );
  }
}
