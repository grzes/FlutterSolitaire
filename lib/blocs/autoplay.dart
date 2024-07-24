import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoPlayCubit extends Cubit<void> {
  Timer? _timer;

  AutoPlayCubit() : super(null);

  void startAutoPlay(bool Function() shouldStop) {
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (shouldStop()) {
        stopAutoPlay();
      }
    });
  }

  void stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    stopAutoPlay();
    return super.close();
  }
}