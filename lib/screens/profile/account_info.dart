import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/components/input_row.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final fakeController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: const Text(
            'Account Info',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {},
        //     child: Text(
        //       'Save',
        //       style: TextStyle(
        //           color: primaryColor,
        //           fontSize: 20,
        //           fontWeight: FontWeight.w800),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: Column(children: [
            // InputRow(
            //     controller: fakeController,
            //     label: "Name",
            //     suffixText: "",
            //     keyboardType: TextInputType.name),
            // SizedBox(height: 20),
            // InputRow(
            //     controller: fakeController,
            //     label: "Email",
            //     suffixText: "",
            //     keyboardType: TextInputType.emailAddress),
            // SizedBox(height: 20),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Text(
            //       "Current Password",
            //       textAlign: TextAlign.left,
            //       style: TextStyle(
            //         fontWeight: FontWeight.w800,
            //         fontSize: 16,
            //       ),
            //     ),
            //     const Spacer(),
            //     SizedBox(
            //       width: MediaQuery.of(context).size.width * 0.4,
            //       child: TextFormField(
            //         controller: fakeController,
            //         decoration: InputDecoration(
            //           suffixIcon: IconButton(
            //             onPressed: () {
            //               setState(() {
            //                 _obscureText = !_obscureText;
            //               });
            //             },
            //             icon: Icon(
            //               _obscureText
            //                   ? Icons.visibility_off
            //                   : Icons.visibility,
            //               color: _obscureText ? Colors.grey : Colors.black,
            //               size: 20,
            //             ),
            //           ),
            //         ),
            //         obscureText: _obscureText,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 50),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    "Change Email",
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    "Change Password",
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    "Delete Account",
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            SizedBox(height: 30),
          ]),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 4),
    );
  }
}
