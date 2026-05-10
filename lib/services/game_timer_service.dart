import 'dart:async';

import 'package:flutter/foundation.dart';

class GameTimerService {
  final ValueNotifier<Duration> elapsed = ValueNotifier<Duration>(
    Duration.zero,
  );

  Stopwatch? _stopwatch;
  Timer? _ticker;

  void start() {
    // Stopwatch keeps accurate elapsed time. The ticker only updates the UI.
    _stopwatch = Stopwatch()..start();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) {
      elapsed.value = _stopwatch?.elapsed ?? Duration.zero;
    });
  }

  void stop() {
    _stopwatch?.stop();
    _ticker?.cancel();
    elapsed.value = _stopwatch?.elapsed ?? elapsed.value;
  }

  void reset() {
    _ticker?.cancel();
    _stopwatch = null;
    elapsed.value = Duration.zero;
  }

  void dispose() {
    _ticker?.cancel();
    elapsed.dispose();
  }
}
