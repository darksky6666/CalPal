import 'package:calpal/screens/components/about_app_content.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'About App',
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
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            Image.asset(
              'assets/icons/calpal_icon_hd.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 10),
            const Text(
              'CalPal',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 30),
            const AboutAppContent(title: "About CalPal", content: aboutAppText),
            const SizedBox(height: 30),
            const AboutAppContent(
                title: "App Permissions", content: appPermissionsText),
            const SizedBox(height: 30),
            const AboutAppContent(
                title: "Privacy Policy", content: privacyPolicyText),
            const SizedBox(height: 30),
            const Text(
              '© 2023 CalPal. All rights reserved.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}
