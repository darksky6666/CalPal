import 'package:calpal/controllers/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class DateRow extends StatefulWidget {
  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  DateLogic dateLogic = DateLogic(); // Create an instance of DateLogic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker Row'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(HeroiconsSolid.chevronLeft),
              onPressed: () {
                setState(() {
                  dateLogic.navigateToPreviousDay();
                });
              },
            ),
            Spacer(),
            Text(
              "${dateLogic.currentDate.day}/${dateLogic.currentDate.month}/${dateLogic.currentDate.year}",
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            IconButton(
              icon: Icon(HeroiconsSolid.chevronRight),
              onPressed: () {
                setState(() {
                  dateLogic.navigateToNextDay();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
