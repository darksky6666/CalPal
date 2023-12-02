import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/controllers/login_state.dart';
import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
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
              ? SuccessView(
                  message: widget.message ?? " ",
                )
              // If not successful
              : NotSuccessView(
                  error: widget.message ??
                      "There's some unexpected error. Please try again.",
                ),
        ));
  }
}

class SuccessView extends StatelessWidget {
  const SuccessView({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Icon(HeroiconsSolid.checkCircle, size: 100, color: Colors.green),
      const SizedBox(height: 20),
      const Text(
        'Operation Successful!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 15),
      Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      const SizedBox(height: 15),
      const Text(
        'Please login again to continue using CalPal.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
          'Operation Failed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 15),
        Text(
          'Error encountered: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 15),
        const Text(
          'Please try again.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
              Navigator.pop(context);
            },
            child: const Text(
              "Go Back",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
