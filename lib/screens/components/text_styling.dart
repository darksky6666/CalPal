import 'package:flutter/material.dart';

class TextBold extends StatelessWidget {
  final String text;
  const TextBold({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
    );
  }
}

class TextNoBold extends StatelessWidget {
  final String text;
  const TextNoBold({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final Color color;
  const TitleText({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 16),
    );
  }
}
