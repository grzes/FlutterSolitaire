import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/game.dart';
import '../models/card.dart';
import 'card_widget.dart';

class ColumnWidget extends StatelessWidget {
  final ColumnCubit columnCubit;
  final int index;
  const ColumnWidget({required this.columnCubit, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: columnCubit,
      child: BlocBuilder<ColumnCubit, ColumnState>(
        builder: (context, state) {
          return DragTarget<PlayingCard>(
            onAcceptWithDetails: (details) {
              // Handle card drop logic
              print("drop: ${details}");
              //context.read<ColumnCubit>().onCardDropped(draggedCard);
            },
            builder: (context, candidateData, rejectedData) {
              var cards = context.read<ColumnCubit>().state.cards;
              return CardStack(cards: cards);
              /*return SizedBox(
                width: 80,
                height: 250,
                child: Stack(
                  children: [
                    for (var i = 0; i < state.cards.length; i++)
                      Positioned(
                        top: i * 18,
                        left: i * 3,
                        child: Draggable<PlayingCard>(
                          data: state.cards[i],
                          feedback: CardWidget(state.cards[i]),
                          childWhenDragging: const SizedBox.shrink(),
                          child: GestureDetector(
                            onTap: () => context.read<ColumnCubit>().flipCard(i),
                            child: CardWidget(state.cards[i]),
                          ),
                        ),
                      ),
                  ],
                ),
              );
              */
            },
          );
        },
      ),
    );
  }
}

class CardStack extends StatelessWidget {
  final List<PlayingCard> cards;
  const CardStack({required this.cards, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 250,
      child: Stack(
        children: [
          for (var i = 0; i < cards.length; i++)
            Positioned(
              top: i * 18,
              left: i * 3,
              child: Draggable<PlayingCard>(
                data: cards[i],
                feedback: CardStack(cards: cards.sublist(i)),
                childWhenDragging: SizedBox.shrink(),
                child: GestureDetector(
                  onTap: () => context.read<ColumnCubit>().flipCard(i),
                  child: CardWidget(cards[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
