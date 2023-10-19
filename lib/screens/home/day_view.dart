import 'package:flutter/material.dart';

class DayViewPage extends StatelessWidget {
  final DateTime date;

  DayViewPage({required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day View - ${date.toLocal()}'),
      ),
      body: Center(
        child: Text('Content for ${date.toLocal()}'),
      ),
    );
  }
}
