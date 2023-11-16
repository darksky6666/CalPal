import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/controllers/login_state.dart';
import 'package:calpal/controllers/registration_controller.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class AccountStatus extends StatefulWidget {
  const AccountStatus({super.key, required this.success, this.message});

  final bool success;
  final String? message;

  @override
  State<AccountStatus> createState() => _AccountStatusState();
}

class _AccountStatusState extends State<AccountStatus> {
  AuthService auth = AuthService();
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
              ? successView(
                  message: widget.message ?? " ",
                )
              // If not successful
              : notSuccessView(
                  error: widget.message ??
                      "There's some unexpected error. Please try again.",
                ),
        ));
  }
}

class successView extends StatelessWidget {
  const successView({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(HeroiconsSolid.checkCircle, size: 100, color: Colors.green),
      SizedBox(height: 20),
      Text(
        'Operation Successful!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      SizedBox(height: 15),
      Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      SizedBox(height: 15),
      Text(
        'Please login again to continue using CalPal.',
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
          'Operation Failed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 15),
        Text(
          'Error encountered: $error',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 15),
        Text(
          'Please try again.',
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
              Navigator.pop(context);
            },
            child: Text(
              "Go Back",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
