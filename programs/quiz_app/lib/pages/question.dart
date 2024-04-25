import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String question;

  const Question({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.multiply,
          color: Colors.deepPurple[200],
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        question,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
