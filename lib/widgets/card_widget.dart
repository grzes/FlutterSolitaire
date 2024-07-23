
import 'package:flutter/material.dart';
import '../models/card.dart';
import 'card_back.dart';
import 'card_face.dart';

class CardWidget extends StatelessWidget {
  final PlayingCard card;
  final Color color;
  const CardWidget(this.card, {super.key, this.color=Colors.white});

  @override
  Widget build(BuildContext context) {
    return card.faceUp ? CardFace(card, color:color) : CardBack();
  }
}


