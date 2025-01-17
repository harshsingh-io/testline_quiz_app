import 'package:flutter/material.dart';

class PerformanceBadge extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isAchieved;

  const PerformanceBadge({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isAchieved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isAchieved ? 1.0 : 0.4,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
