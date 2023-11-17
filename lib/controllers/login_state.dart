import 'dart:developer';

import 'package:calpal/controllers/auth_service.dart';
import 'package:calpal/screens/home/home_view.dart';
import 'package:calpal/screens/profile/login_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class LoginState extends StatefulWidget {
  const LoginState({super.key});

  @override
  State<LoginState> createState() => _LoginState();
}

class _LoginState extends State<LoginState> {
  final AuthService authService = AuthService();

  bool isConnected = true;

  // Check for internet connection
  void checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none &&
          connectivityResult != ConnectivityResult.other;
    });
  }

  void onRetry() {
    // Perform connectivity check again when "Retry" button is pressed
    checkConnection();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    log(isConnected.toString());
    if (!isConnected) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: AlertDialog(
            title: Text('No Internet Connection'),
            content:
                Text('Please check your internet connection and try again.'),
            actions: [
              TextButton(
                onPressed: onRetry,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else {
      return StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (authService.currentUser!.emailVerified) {
              return HomeView();
            } else {
              return const LoginScreen();
            }
          } else {
            return const LoginScreen();
          }
        },
      );
    }
  }
}
