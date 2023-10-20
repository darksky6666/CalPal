import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/screens/home/navigation_screen.dart';
import 'package:calpal/screens/profile/login_screen.dart';
import 'package:flutter/material.dart';

class LoginState extends StatefulWidget {
  const LoginState({super.key});

  @override
  State<LoginState> createState() => _LoginState();
}

class _LoginState extends State<LoginState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return NavigationScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
