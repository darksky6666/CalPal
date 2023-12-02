import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/screens/profile/forgot_password.dart';
import 'package:calpal/screens/registration/registration_view.dart';
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
  bool status = false;
  bool isLoading = false;
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Method to show the resend email verification dialog
  Future<bool> showResendEmailDialog(BuildContext context) async {
    bool shouldResend = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Email Verification'),
              content: Text(
                  'Your email is not verified. Resend verification email?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false when cancelled
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true when confirmed
                  },
                  child: Text('Resend'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if showDialog returned null
    return shouldResend;
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text,
          (bool success, String errorMessage) async {
        if (!success) {
          if (errorMessage == "failed-email-verification") {
            bool resendEmail = await showResendEmailDialog(context);
            if (resendEmail) {
              await authService.sendEmailVerify();
              // Show a confirmation message that the email has been resent
              Fluttertoast.showToast(
                  msg: "Verification email has been resent.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            // Prevent login if the user has not verified their email
            if (authService.currentUser != null) {
              authService.signOut();
            }
            status = false;
          }
        } else {
          status = true;
        }
      });
    } catch (e) {
      if (authService.currentUser != null) {
        authService.signOut();
      }
      errorMessage = e.toString();
      Fluttertoast.showToast(
          msg: errorMessage!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      status = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: [
            loginForm(),
            if (isLoading)
              Container(
                color: Colors.white.withOpacity(0.8),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: purpleColor,
                    ),
                    SizedBox(height: 30),
                    Text("Logging in...",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ],
                ),
              ) // Display the loading indicator
          ],
        ),
      )),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          height: 20,
        ),
        FractionallySizedBox(
          widthFactor: 0.8,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading =
                      true; // Set isLoading to true to show the loading indicator
                });
                try {
                  // Implement the login logic here.
                  await signInWithEmailAndPassword();
                  if (authService.currentUser != null && status) {
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  }
                } finally {
                  setState(() {
                    isLoading =
                        false; // Set isLoading back to false to hide the loading indicator
                  });
                }
              }
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
          height: 20,
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegistrationPage();
                    }));
                  },
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ]),
    );
  }
}
