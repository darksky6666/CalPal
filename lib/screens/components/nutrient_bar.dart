import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class NutrientProgressBar extends StatelessWidget {
  final String nutrientName;
  final double consumed;
  final double dailyGoal;

  NutrientProgressBar({
    required this.nutrientName,
    required this.consumed,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          nutrientName,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Spacer(),
        Row(
          children: [
            Text(
              '${consumed.toStringAsFixed(1)}',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            Text(' g / ${dailyGoal.toStringAsFixed(1)} g',
                style: TextStyle(fontSize: 16)),
            SizedBox(width: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: LinearProgressIndicator(
                value: consumed / dailyGoal,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  consumed > dailyGoal ? Colors.red : Colors.lightGreen,
                ),
              ),
            ),
            SizedBox(width: 10),
            Icon(HeroiconsSolid.chevronRight),
          ],
        ),
      ],
    );
  }
}
