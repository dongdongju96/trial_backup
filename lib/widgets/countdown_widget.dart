import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({
    required this.onFinished,
    required this.lockText,
    super.key,
  });

  final VoidCallback onFinished;
  final String lockText;

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  static const int _lockStep = 0;

  int _count = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Show 3, 2, 1, then LOCK. The game starts after LOCK is visible briefly.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count <= _lockStep) {
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
    final text = _count == _lockStep ? widget.lockText : '$_count';

    return Center(
      child: TweenAnimationBuilder<double>(
        key: ValueKey(text),
        tween: Tween<double>(begin: 0.78, end: 1),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 220),
          builder: (context, opacity, child) {
            return Opacity(opacity: opacity, child: child);
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.pinkAccent, width: 2),
              boxShadow: AppShadows.neonGlow(AppColors.pinkAccent),
            ),
            child: SizedBox(
              width: 148,
              height: 148,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(text, style: AppTextStyles.countdown),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
