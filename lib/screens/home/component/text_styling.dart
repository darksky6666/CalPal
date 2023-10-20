import 'package:flutter/material.dart';

class textBold extends StatelessWidget {
  final String text;
  const textBold({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
    );
  }
}

class textNoBold extends StatelessWidget {
  final String text;
  const textNoBold({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
    );
  }
}

class titleText extends StatelessWidget {
  final String text;
  final Color color;
  const titleText({
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
