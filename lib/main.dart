import 'package:calpal/screens/home/navigation_screen.dart';
import 'package:calpal/controllers/login_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalPal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define your routes
      routes: {
        '/': (context) => const LoginState(),// Replace FirstScreen with your starting screen
        '/home': (context) => const NavigationScreen(), // Replace HomeScreen with your home screen
      },
      initialRoute: '/', // Set the initial route
    );
  }
}
