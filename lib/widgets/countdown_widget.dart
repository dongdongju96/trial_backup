import 'dart:async';

import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  int _count = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Show 3, then 2, then 1. After the last number, the game can start.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count <= 1) {
        timer.cancel();
        widget.onFinished();
        return;
      }

      setState(() {
        _count--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.48),
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 128,
        height: 128,
        child: Center(
          child: Text(
            '$_count',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
