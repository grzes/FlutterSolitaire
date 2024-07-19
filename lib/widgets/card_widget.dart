
import 'package:flutter/material.dart';
import '../models/card.dart';
import 'card_back.dart';
import 'card_face.dart';

class CardWidget extends StatelessWidget {
  static const double width = 57.1;
  static const double height = 88.9;

  final PlayingCard card;
  const CardWidget(this.card, {super.key});

  @override
  Widget build(BuildContext context) {
    return card.faceUp ? CardFace(card) : CardBack();
  }
}



/*
    final palette = context.watch<Palette>();
    final textColor =
        card.suit.color == CardSuitColor.red ? palette.redPen : palette.ink;

    final cardWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.apply(color: textColor),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: palette.trueWhite,
          border: Border.all(color: palette.ink),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
        children: [
          Positioned(
            top: 1,
            left: 3,
            child: Text(
              '${card.value}',
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
                  '${card.valueAsCharacter}',
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

    /// Cards that aren't in a player's hand are not draggable.
    if (player == null) return cardWidget;

/*    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: cardWidget,
       ),
      data: PlayingCardDragData(card, player!),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: cardWidget,
      ),
      onDragStarted: () {
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.huhsh);
      },
      onDragEnd: (details) {
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.wssh);
      },
      child: cardWidget,
      );
*/
  }
}
*/

