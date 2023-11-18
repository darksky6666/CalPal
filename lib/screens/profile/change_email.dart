import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/profile/account_status.dart';
import 'package:calpal/screens/profile/change_email_status.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  AuthService authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText1 = true;

  // Fetch current user's email
  String? getCurrentUserEmail() {
    final user = authService.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change Email?",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Please enter your email address and password. We need to verify that it's you before we change your email address.",
                    textAlign: TextAlign.justify,
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
              ),
              SizedBox(
                height: 30,
              ),

              // Current email address
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
                      if (value != getCurrentUserEmail()) {
                        return 'Email address does not match current user';
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
                    labelText: 'Current Email',
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
              // New email address
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
                      if (value == getCurrentUserEmail()) {
                        return 'New email address cannot be the same';
                      }
                    }
                    return null;
                  },
                  controller: newEmailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelText: 'New Email',
                    hintText: 'example@gmail.com',
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Password
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Current Password',
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
              const SizedBox(
                height: 30,
              ),
              // Confirm password
              TextFormField(
                controller: confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please reenter your password';
                  } else if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Reenter Current Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                    icon: Icon(
                      _obscureText1 ? Icons.visibility_off : Icons.visibility,
                      color: _obscureText1 ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                obscureText: _obscureText1,
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
                      // Show alert dialog to confirm account deletion
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Changing Email?"),
                            content: Text(
                              "Your new email is ${newEmailController.text}",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the alert dialog
                                },
                                child: Text("Cancel",
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              TextButton(
                                onPressed: () {
                                  try {
                                    authService.verifyAndUpdateUserNewEmail(
                                        emailController.text,
                                        newEmailController.text,
                                        passwordController.text,
                                        (bool success, String message) {
                                      if (success) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EmailStatus(
                                                        success: success,
                                                        message: message,
                                                        email:
                                                            newEmailController
                                                                .text)));
                                      } else {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return AccountStatus(
                                                success: success,
                                                message: message);
                                          },
                                        ));
                                      }
                                    });
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: e.toString(),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.1),
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Text("Confirm",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    "Change Email",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
