import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  const ButtonText({required this.text, super.key}) : isFitted = false;

  const ButtonText.fitted({
    required this.text,
    super.key,
  }) : isFitted = true;

  final String text;
  final bool isFitted;

  Text get textWidget => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return isFitted
        ? FittedBox(fit: BoxFit.fitWidth, child: textWidget)
        : textWidget;
  }
}
