import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:flutter/material.dart';

class GoalView extends StatefulWidget {
  const GoalView({super.key});

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
      ),
      body: Center(
        child: Text('Goals'),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 3),
    );
  }
}