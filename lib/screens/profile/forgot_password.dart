import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Forgot Password?",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Please enter your email address and we'll send you a link to reset your password.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
          ),
          SizedBox(
            height: 30,
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                labelText: 'Email',
                hintText: 'example@gmail.com',
                prefixIcon: const Icon(
                  Icons.mail,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.0),
                ),
              ),
              onPressed: () {
                authService.resetPassword(emailController.text);
                Navigator.pop(context);
              },
              child: Text(
                "Send Reset Link",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
