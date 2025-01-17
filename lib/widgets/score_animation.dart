import 'package:flutter/material.dart';

class ScoreAnimation extends StatefulWidget {
  final int score;
  final bool isCorrect;

  const ScoreAnimation({
    Key? key,
    required this.score,
    required this.isCorrect,
  }) : super(key: key);

  @override
  State<ScoreAnimation> createState() => _ScoreAnimationState();
}

class _ScoreAnimationState extends State<ScoreAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Text(
              widget.isCorrect ? '+${widget.score}' : '-${widget.score}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.isCorrect ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}
