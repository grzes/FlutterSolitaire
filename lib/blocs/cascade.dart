import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card.dart';
import '../widgets/card_widget.dart';

class CascadeCubit extends Cubit<List<Widget>> {
  CascadeCubit() : super([]);
  int i = 0;
  double x = 0;
  double y = 0;
  double xd = 0;
  double yd = 0;

  bool add() {
    i++;
    final stateCopy = List<Widget>.from(state);
    x += xd;
    yd += 0.4;
    y += yd;
    stateCopy.add(
      Transform.translate(
        offset: Offset(x, y),
        child: CardWidget(PlayingCard(CardValue.king, CardSuit.hearts, faceUp: true))
      )
    );
    emit(stateCopy);
    return false;
  }

  void reset() {
    i = 0;
    x = y = 0;
    xd = random(3,6);
    yd =  random(6,30);
    emit([]);
  }

  double random(double from, double to) {
    double r = Random().nextDouble();
    double s = (r>0.5)? 1 : -1;
    return (from + (to - from) * r) * s;
  }

}