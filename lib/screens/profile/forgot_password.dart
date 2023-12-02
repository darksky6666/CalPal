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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Please enter your email address and we'll send you a link to reset your password.",
                    textAlign: TextAlign.justify,
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
              ),
              const SizedBox(
                height: 30,
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    } else {
                      // Regular expression for email validation
                      final emailRegex = RegExp(
                          r'^[\w-\.]+@(?!.*\d)[a-zA-Z0-9][a-zA-Z0-9-]+(\.[a-zA-Z]{2,4})+$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                    }
                    return null;
                  },
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
              const SizedBox(
                height: 40,
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
                    if (_formKey.currentState!.validate()) {
                      authService.resetPassword(emailController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Send Reset Link",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
