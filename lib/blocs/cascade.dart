import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card.dart';
import '../widgets/card_widget.dart';
import '../widgets/constants.dart';

class CascadeCubit extends Cubit<List<Widget>> {
  CascadeCubit(PlayingCard card, {required double x, required double y}) :
    widget = CardWidget(card),
    startX = x,
    startY = y,
    super([]);

  int i = 0;
  Widget widget;
  double startX;
  double startY;
  double x = 0;
  double y = 0;
  double xd = 0;
  double yd = 0;

  bool add({double width=0, double height=0}) {
    i++;
    final stateCopy = List<Widget>.from(state);
    stateCopy.add(
      Transform.translate(
        offset: Offset(x, y),
        child: CardWidget(PlayingCard(CardValue.king, CardSuit.hearts, faceUp: true))
      )
    );
    emit(stateCopy);
    x += xd;
    yd += 0.4;
    y += yd;
    if ((y > height - PlayingCardHeight) && (yd > 0)) {
      y = height - PlayingCardHeight;
      yd = -yd * 0.8;
    }

    double border = width/2 + PlayingCardWidth/2;
    if ((x < -border) || (x > border)) {
      print("done... ${DateTime.now()}");
      return true;
    }
    return false;
  }

  void reset() {
    x = startX;
    y = startY;
    i = 0;
    xd = random(2,5);
    yd =  random(6,18);
    emit([]);
  }

  double random(double from, double to) {
    double r = Random().nextDouble();
    double s = (r>0.5)? 1 : -1;
    return (from + (to - from) * r) * s;
  }

}