import 'package:calpal/constants.dart';
import 'package:calpal/controllers/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variables
  bool _obscureText = true;
  String? errorMessage = '';
  bool _isSigningIn = false;
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
      });
    }
  }

  // Future<void> createUserWithEmailAndPassword() async {
  //   setState(() {
  //     _isSigningIn = true;
  //   });
  //   try {
  //     await authService.createUserWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       errorMessage = e.toString();
  //     });
  //   } finally {
  //     setState(() {
  //       _isSigningIn = false;
  //     });
  //   }
  // }

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
              'assets/calpal_icon.png',
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
                Fluttertoast.showToast(
                    msg: "Forgot Password Clicked",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
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
            Fluttertoast.showToast(
                    msg: ("Login Clicked ") + (emailController.text) + (" ") + (passwordController.text) + (" ") + (errorMessage!),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
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
                  Fluttertoast.showToast(
                    msg: "Sign Up Clicked",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
                },
            ),
          ],
        ),
      ),
    ]);
  }
}
