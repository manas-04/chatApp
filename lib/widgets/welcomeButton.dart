// ignore_for_file: file_names

import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const WelcomeButton({
    required this.size,
    required this.text,
    required this.color,
    required this.pushFunction,
  });

  final Size size;
  final String text;
  final Color color;
  final VoidCallback pushFunction;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: size.width * 0.8,
      height: 45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
          ),
          onPressed: pushFunction,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
