import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/screens/profile/forgot_password.dart';
import 'package:calpal/screens/registration/registration_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables
  bool _obscureText = true;
  String? errorMessage = '';
  // bool _isSigningIn = false;
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await authService.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.toString();
        Fluttertoast.showToast(
            msg: errorMessage!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: loginForm(),
      )),
    );
  }

  Column loginForm() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Spacer(),
      Center(
        child: Column(
          children: [
            Image.asset(
              'assets/icons/calpal_icon.png',
              width: 150,
              height: 50,
            ),
            const SizedBox(height: 10),
            const Text(
              'CalPal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Welcome back!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
      const Text(
        'sign in to access your account',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
      ),
      const SizedBox(height: 40),
      FractionallySizedBox(
        widthFactor: 0.8,
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
      const SizedBox(
        height: 20,
      ),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: TextField(
          controller: passwordController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            labelText: 'Password',
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: _obscureText ? Colors.grey : Colors.black,
              ),
            ),
          ),
          obscureText: _obscureText,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                // Implement the logic for 'Forgot Password' action here.
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ForgotPassword();
                }));
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      const Spacer(),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: ElevatedButton(
          onPressed: () {
            // Implement the login logic here.
            signInWithEmailAndPassword();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shadowColor: Colors.grey,
            elevation: 5,
            // Text color
          ),
          child: const Text('Login'),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            const TextSpan(
              text: "Don't have an account yet? ",
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: "Sign Up",
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Implement the Sign Up action here.
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RegistrationPage();
                  }));
                },
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
    ]);
  }
}
