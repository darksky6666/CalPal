import 'package:calpal/controllers/registration_controller.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class RegistrationPage1 extends StatefulWidget {
  RegistrationPage1(
      {super.key, required this.pageController, required this.totalPages});

  final PageController pageController;
  final int totalPages;

  @override
  State<RegistrationPage1> createState() => _RegistrationPage1State();
}

class _RegistrationPage1State extends State<RegistrationPage1> {
  final registrationController = Get.put(RegistrationController());
  bool _obscureText = true;
  bool _obscureText1 = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final registrationController = Get.put(RegistrationController());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registration",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Please enter your personal details.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: registrationController.nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    } else if (value.length > 20) {
                      return 'Name must be less than 20 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelText: 'Name',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: registrationController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    } else {
                      // Regular expression for email validation
                      final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Simple email pattern, adjust as per your requirements
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                    }
                    return null;
                  },
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: registrationController.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6 || value.length > 20) {
                      return 'Password length must be between 6 and 20 characters';
                    } else if (!value.contains(RegExp(r'[A-Z]'))) {
                      return 'Password must contain at least one uppercase letter';
                    } else if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'Password must contain at least one lowercase letter';
                    } else if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Password must contain at least one digit';
                    } else if (!value
                        .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                      return 'Password must contain at least one special character';
                    }
                    return null;
                  },
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: registrationController.reenterPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please reenter your password';
                    } else if (value !=
                        registrationController.passwordController.text) {
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
                    labelText: 'Reenter Password',
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
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(50, 50),
                  ),
                  maximumSize: MaterialStateProperty.all<Size>(
                    const Size(50, 50),
                  ),
                ),
                icon: const Icon(HeroiconsSolid.chevronRight,
                    color: Colors.white),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
