import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../utils/constants.dart';

class GameTimerWidget extends StatelessWidget {
  const GameTimerWidget({required this.elapsed, super.key});

  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final seconds = (elapsed.inMilliseconds / 1000).toStringAsFixed(2);

    return Text(
      AppLocalizations.of(context).timerSeconds(seconds),
      style: AppTextStyles.timer,
    );
  }
}
