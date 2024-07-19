import 'package:flutter/material.dart';
import '../models/card.dart';
import 'constants.dart';


class CardFace extends StatelessWidget {
  final PlayingCard card;
  const CardFace(this.card, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.apply(color: (card.cardColor == CardColor.red)? Colors.red: Colors.black),
      child: Container(
        width: PlayingCardWidth,
        height: PlayingCardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
        children: [
          Positioned(
            top: 1,
            left: 3,
            child: Text(
              '${card.value.asCharacter}',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 1,
            right: 3,
            child: Text(
              '${card.suit.asCharacter}',
              style: TextStyle(fontSize: 10),
            ),
          ),
          Positioned(
              bottom: 1,
              right: 3,
              child: Transform.rotate(
                angle: 3.14159,
                child: Text(
                  '${card.value.asCharacter}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Positioned(
            bottom: 1,
            left: 3,
            child: Transform.rotate(
              angle: 3.14159,
              child: Text(
                '${card.suit.asCharacter}',
                style: TextStyle(fontSize: 10),
                ),
            ),
            ),
          Center(
            child: Text(
              '${card.suit.asCharacter}',
              style: TextStyle(
                fontSize: 50, // Adjust size as needed
                color: Colors.grey.withOpacity(0.2), // Optional style
              ),
            ),
          ),
        ],
      ),
    )
    );
  }

}