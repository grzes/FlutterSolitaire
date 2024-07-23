import 'package:flutter/material.dart';
import '../models/card.dart';
import 'constants.dart';


class CardFrame extends StatelessWidget {
  final Widget child;
  const CardFrame({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PlayingCardWidth,
      height: PlayingCardHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: child
      ),
    );
  }
}

class CardSuitFrame extends StatelessWidget {
  final CardSuit suit;
  const CardSuitFrame({required this.suit, super.key});

  @override
  Widget build(BuildContext context) {
    return CardFrame(
      child: Text(
        suit.asCharacter,
        style: TextStyle(
          fontSize: 50, // Adjust size as needed
          color: Colors.grey.withOpacity(0.2), // Optional style
        ),
      ),
    );
  }
}