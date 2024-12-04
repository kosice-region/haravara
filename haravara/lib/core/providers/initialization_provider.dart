import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitializationProgressNotifier extends StateNotifier<double> {
  InitializationProgressNotifier() : super(0.0);

  void updateProgress(double progress) {
    state = progress.clamp(0.0, 1.0);
  }
}

final initializationProgressProvider =
    StateNotifierProvider<InitializationProgressNotifier, double>(
  (ref) => InitializationProgressNotifier(),
);
