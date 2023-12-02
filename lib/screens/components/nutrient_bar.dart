import 'package:calpal/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class NutrientProgressBar extends StatefulWidget {
  final String nutrientName;
  final double consumed;
  final double dailyGoal;

  const NutrientProgressBar({
    super.key,
    required this.nutrientName,
    required this.consumed,
    required this.dailyGoal,
  });

  @override
  State<NutrientProgressBar> createState() => _NutrientProgressBarState();
}

class _NutrientProgressBarState extends State<NutrientProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.nutrientName,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              widget.consumed.toStringAsFixed(1),
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            if (widget.nutrientName == 'Cholesterol' ||
                widget.nutrientName == 'Sodium' ||
                widget.nutrientName == 'Potassium')
              Text(' mg / ${widget.dailyGoal.toStringAsFixed(1)} mg',
                  style: const TextStyle(fontSize: 16))
            else
              Text(' g / ${widget.dailyGoal.toStringAsFixed(1)} g',
                  style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.13
                  : MediaQuery.of(context).size.width * 0.5,
              child: LinearProgressIndicator(
                value: double.parse(widget.consumed.toStringAsFixed(1)) ==
                        double.parse(widget.dailyGoal.toStringAsFixed(1))
                    ? 0.99
                    : widget.consumed / widget.dailyGoal,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  double.parse(widget.consumed.toStringAsFixed(1)) >
                          double.parse(widget.dailyGoal.toStringAsFixed(1))
                      ? Colors.red
                      : Colors.lightGreen,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(HeroiconsSolid.chevronRight),
          ],
        ),
      ],
    );
  }
}
