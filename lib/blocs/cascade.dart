import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card.dart';
import '../widgets/card_widget.dart';
import '../widgets/constants.dart';


class DeckCascadeCubit extends Cubit<List<CascadeCubit>> {
  int suit = 0;
  DeckCascadeCubit() : super([]);


  bool addNextCard() {
    final stateCopy = List<CascadeCubit>.from(state);
    int drawnCards = stateCopy.length;
    if (drawnCards == 52) return true;

    int value = (drawnCards / 4).floor();

    var card = PlayingCard(
      CardValue.values[CardValue.values.length - value -1],
      CardSuit.values[suit],
      faceUp: true,
    );
    double offset = -4 -PlayingCardWidth + suit * 80;
    var newCard = CascadeCubit(card, x: offset, y: 14);
    suit = (suit+1) % 4;
    stateCopy.add(newCard);
    emit(stateCopy);
    return false;
  }

  void reset() {
    for (var c in state) {
      c.reset();
    }
    emit([]);
  }

}


class CascadeCubit extends Cubit<List<Widget>> {
  Widget widget;
  double x = 0;
  double y = 0;
  double xd = 0;
  double yd = 0;

  CascadeCubit(PlayingCard card, {required double this.x, required double this.y}) :
    widget = CardWidget(card),
    super([]) {
      xd = random(2,5);
      yd = random(6,18);
    }


  bool add({double width=0, double height=0}) {
    final stateCopy = List<Widget>.from(state);
    stateCopy.add(
      Transform.translate(
        offset: Offset(x, y),
        child: widget,
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
      return true;
    }
    return false;
  }

  void reset() {
    emit([]);
  }

  double random(double from, double to) {
    double r = Random().nextDouble();
    double s = (r>0.5)? 1 : -1;
    return (from + (to - from) * r) * s;
  }

}