import 'package:flutter/material.dart';

class CircularScore extends StatelessWidget {
  final int score;
  final int maxScore;
  final double size;

  const CircularScore({
    Key? key,
    required this.score,
    required this.maxScore,
    this.size = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: score / maxScore,
              strokeWidth: 12,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                score / maxScore > 0.7
                    ? Colors.green
                    : score / maxScore > 0.4
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  score.toString(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Points',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
