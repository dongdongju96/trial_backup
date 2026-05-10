import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

class GameTimerWidget extends StatelessWidget {
  const GameTimerWidget({required this.elapsed, super.key});

  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final seconds = (elapsed.inMilliseconds / 1000).toStringAsFixed(2);

    return Text(
      AppLocalizations.of(context).timerSeconds(seconds),
      style: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }
}
