import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int flex;

  const AnimatedProgressBar({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.flex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.centerLeft,
          widthFactor: currentQuestion / totalQuestions,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue[300]!],
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
