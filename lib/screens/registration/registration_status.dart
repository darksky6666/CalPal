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
              ? const SuccessView()
              // If not successful
              : NotSuccessView(
                  error: widget.error ??
                      "There's some unexpected error. Please try again.",
                ),
        ));
  }
}

class SuccessView extends StatelessWidget {
  const SuccessView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final registrationController = Get.put(RegistrationController());
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Icon(HeroiconsSolid.checkCircle, size: 100, color: Colors.green),
      const SizedBox(height: 20),
      const Text(
        'Account Created Successfully!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 15),
      Text(
        'Welcome to CalPal, ${registrationController.nameController.text}!',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      const SizedBox(height: 15),
      Column(
        children: [
          const Text(
            'Please check your email at',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            registrationController.emailController.text,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: purpleColor),
          ),
          const Text(
            'to verify your account.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      const SizedBox(height: 40),
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
              return const LoginState();
            }));
          },
          child: const Text(
            "Back to Login",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ]);
  }
}

class NotSuccessView extends StatelessWidget {
  const NotSuccessView({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(HeroiconsSolid.xCircle, size: 100, color: Colors.red),
        const SizedBox(height: 20),
        const Text(
          'Account Creation Failed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 15),
        Text(
          'Error encountered: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 40),
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
                return const RegistrationPage();
              }));
            },
            child: const Text(
              "Back to Registration",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
