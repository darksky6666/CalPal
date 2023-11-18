import 'package:calpal/controllers/login_state.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:ionicons/ionicons.dart';

class EmailStatus extends StatefulWidget {
  const EmailStatus(
      {super.key, required this.success, this.message, required this.email});

  final bool success;
  final String? message;
  final String email;

  @override
  State<EmailStatus> createState() => _EmailStatusState();
}

class _EmailStatusState extends State<EmailStatus> {
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
                  email: widget.email,
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
    required this.email,
  });

  final String message;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(Ionicons.hourglass_outline, size: 100, color: primaryColor),
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
        'Please verify your new email to change your email!',
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
