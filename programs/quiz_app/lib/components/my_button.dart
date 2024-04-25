import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color? backgroundColor;
  // final ButtonStyle buttonStyle;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // elevation: ,
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
