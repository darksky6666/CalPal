import 'package:flutter/material.dart';

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
    required this.controller,
    required this.label,
    required this.suffixText,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String suffixText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              suffixText: suffixText,
              suffixStyle: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}