import 'package:calpal/controllers/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = AuthService().currentUser;

  Future<void> signOut() async {
    await AuthService().signOut();
  }

  Widget _title() {
    return const Text('Home Page');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () async {
        await signOut();
      },
      child: const Text('Sign Out'),
    );
  }

  Widget _userId() {
    return Text(user?.uid ?? 'No user ID');
  }

  Widget _navigateToHome() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/home');
      },
      child: const Text('Home'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userId(),
            _signOutButton(),
            _navigateToHome(),
          ],
        ),
      ),
    );
  }
}
