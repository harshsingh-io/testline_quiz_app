import 'package:flutter/material.dart';
import 'dart:math' as math;

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onTimerComplete;
  final bool isPaused;

  const CountdownTimer({
    Key? key,
    required this.seconds,
    required this.onTimerComplete,
    this.isPaused = false,
  }) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isWarning = false;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    _controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        if (_animation.value >= 0.75 && !_isWarning) {
          setState(() => _isWarning = true);
        }
      });

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTimerComplete();
      }
    });
  }

  void _resetTimer() {
    _isWarning = false;
    _controller.reset();
    _controller.forward();
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isPaused && oldWidget.isPaused) {
      _resetTimer();
    }
    if (widget.isPaused) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get timeLeft {
    final duration = _controller.duration! * (1 - _controller.value);
    final totalSeconds = duration.inSeconds;
    final seconds = totalSeconds.toString();
    return seconds;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final remainingTime = _controller.duration! * (1 - _controller.value);
        final totalSeconds = remainingTime.inSeconds;
        final displayTime = totalSeconds.toString();

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isWarning ? Colors.red : Colors.blue,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayTime,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isWarning ? Colors.red : Colors.blue,
                  ),
                ),
                Text(
                  'seconds',
                  style: TextStyle(
                    fontSize: 10,
                    color: _isWarning ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
