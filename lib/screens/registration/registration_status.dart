import 'package:calpal/controllers/login_state.dart';
import 'package:calpal/controllers/registration_controller.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:calpal/screens/registration/registration_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class RegistrationStatus extends StatefulWidget {
  const RegistrationStatus({super.key, required this.success, this.error});

  final bool success;
  final String? error;

  @override
  State<RegistrationStatus> createState() => _RegistrationStatusState();
}

class _RegistrationStatusState extends State<RegistrationStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: widget.success
              // If successful
              ? successView()
              // If not successful
              : notSuccessView(
                  error: widget.error ??
                      "There's some unexpected error. Please try again.",
                ),
        ));
  }
}

class successView extends StatelessWidget {
  const successView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final registrationController = Get.put(RegistrationController());
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(HeroiconsSolid.checkCircle, size: 100, color: Colors.green),
      SizedBox(height: 20),
      Text(
        'Account Created Successfully!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      SizedBox(height: 15),
      Text(
        'Welcome to CalPal, ${registrationController.nameController.text}!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      SizedBox(height: 15),
      Column(
        children: [
          Text(
            'Please check your email at',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            registrationController.emailController.text,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: purpleColor),
          ),
          Text(
            'to verify your account.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      SizedBox(height: 40),
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
            registrationController.resetData();
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return LoginState();
            }));
          },
          child: Text(
            "Back to Login",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ]);
  }
}

class notSuccessView extends StatelessWidget {
  const notSuccessView({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(HeroiconsSolid.xCircle, size: 100, color: Colors.red),
        SizedBox(height: 20),
        Text(
          'Account Creation Failed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 15),
        Text(
          'Error encountered: $error',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 40),
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
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RegistrationPage();
              }));
            },
            child: Text(
              "Back to Registration",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
