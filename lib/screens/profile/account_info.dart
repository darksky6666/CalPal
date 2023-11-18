import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:calpal/screens/profile/change_email.dart';
import 'package:calpal/screens/profile/change_password.dart';
import 'package:calpal/screens/profile/delete_account.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final fakeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: const Text(
            'Account Settings',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: Column(children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangeEmail();
                }));
              },
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangePassword();
                }));
              },
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DeleteAccount();
                }));
              },
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
