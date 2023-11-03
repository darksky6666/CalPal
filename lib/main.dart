import 'package:calpal/screens/analysis/analysis_view.dart';
import 'package:calpal/screens/food/food_view.dart';
import 'package:calpal/screens/goal/edit_goal.dart';
import 'package:calpal/screens/goal/goal_view.dart';
import 'package:calpal/screens/home/home_view.dart';
import 'package:calpal/controllers/login_state.dart';
import 'package:calpal/screens/profile/profile_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
        '/': (context) => LoginState(),
        '/home': (context) => HomeView(),
        '/analysis': (context) => AnalysisView(),
        '/food': (context) => FoodView(),
        '/goal': (context) => GoalView(),
        '/profile': (context) => ProfileView(),
        '/edit_goal': (context) => EditGoal(),
      },
      initialRoute: '/', // Set the initial route
    );
  }
}