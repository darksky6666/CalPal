import 'package:calpal/screens/components/bottom_navigation.dart';
import 'package:flutter/material.dart';

class FoodView extends StatefulWidget {
  const FoodView({super.key});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food'),
      ),
      body: Center(
        child: Text('Food'),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 2),
    );
  }
}