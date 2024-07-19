import 'package:blocsolitaire/models/card.dart';
import 'package:flutter/material.dart';
import 'widgets/card_widget.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardWidget(PlayingCard(CardValue.ten, CardSuit.clubs)),
            SizedBox(width: 20),
            CardWidget(PlayingCard(CardValue.jack, CardSuit.clubs, faceUp: true)),
            SizedBox(width: 20),
            CardWidget(PlayingCard(CardValue.queen, CardSuit.clubs)),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Restart',
        child: const Icon(Icons.refresh),
      ),*/
    );
  }
}