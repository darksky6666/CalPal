import 'package:flutter/material.dart';

class WeekViewPage extends StatelessWidget {
  final DateTime startDate;

  WeekViewPage({required this.startDate});

  @override
  Widget build(BuildContext context) {
    final endDate = startDate.add(Duration(days: 6));

    return Scaffold(
      appBar: AppBar(
        title: Text('Week View - ${startDate.toLocal()} to ${endDate.toLocal()}'),
      ),
      body: Center(
        child: Text('Content for the week from ${startDate.toLocal()} to ${endDate.toLocal()}'),
      ),
    );
  }
}
