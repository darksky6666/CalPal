import 'package:flutter/material.dart';

class InputRow extends StatelessWidget {
  InputRow({
    super.key,
    required this.controller,
    required this.label,
    required this.suffixText,
    required this.keyboardType,
    this.validator,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String suffixText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: TextFormField(
            onChanged: onChanged,
            validator: validator,
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              suffixText: suffixText,
              suffixStyle: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
