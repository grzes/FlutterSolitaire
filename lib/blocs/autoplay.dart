import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoPlayCubit extends Cubit<void> {
  Timer? _timer;

  AutoPlayCubit() : super(null);

  void startAutoPlay(bool Function() shouldStop, {int milliseconds=50}) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
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