import 'dart:math';
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
          return DragTarget<CardDragData>(
            onAcceptWithDetails: (details) {
              context.read<ColumnCubit>().addCards(details.data.cards);
            },
            onWillAcceptWithDetails: (details) {
              return context.read<ColumnCubit>().willAcceptCards(details.data.cards);
            },
            builder: (context, candidateData, rejectedData) {
              var column = context.read<ColumnCubit>();
              return NestedColumnStack(columnCubit: column, index: index, cards: column.state.cards);
            },
          );
        },
      ),
    );
  }
}

class NestedColumnStack extends StatelessWidget {
  final ColumnCubit columnCubit;
  final int index;
  final List<PlayingCard> cards;
  const NestedColumnStack({required this.columnCubit, required this.index, required this.cards, super.key});

  @override
  Widget build(BuildContext context) {

    Widget subStack() => Stack(children: [
      CardWidget(cards[0]),
      Positioned(
        top: 18,
        left: 2,
        child: NestedColumnStack(columnCubit: columnCubit, index: index, cards: cards.sublist(1))
      )
    ]);


    return SizedBox(
      width: 80,
      height: 430,
      child:
        (cards.isEmpty) ?
          Container():
            (cards[0].faceUp) ?
              Draggable<CardDragData>(
                data: CardDragData(from: index, cards: cards),
                feedback: NestedColumnStack(columnCubit: columnCubit, index: index, cards: cards),
                childWhenDragging: const SizedBox.shrink(),
                onDragCompleted: () {
                  columnCubit.removeCards(cards.length);
                },
                child: subStack(),
              ) :
              GestureDetector(
                onTap: () {
                  columnCubit.flipTopCard();
                },//context.read<ColumnCubit>().flipCard(i),
                child: subStack(),
              ),
    );
  }
}

// Draw the second to last card if it exists
class WidgetOverCards extends StatelessWidget {
  final List<PlayingCard> cards;
  final Widget widget;
  final Color color;
  const WidgetOverCards({required this.cards, required this.widget, this.color = Colors.white, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 100,
      child: Stack(
        children: [
          for (int i=0; i<min(1, cards.length); i++)
            CardWidget(cards[cards.length-1], color:Colors.grey),
          (cards.isEmpty) ? widget :
          Positioned(
            top: 6,
            left: 6,
            child: widget
          )
      ]),
    );
  }
}

class DeckWidget extends StatelessWidget {
  final DeckCubit deckCubit;
  const DeckWidget({required this.deckCubit, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: deckCubit,
      child: BlocBuilder<DeckCubit, DeckState>(
        builder: (context, state) {

          return Padding(
            padding: const EdgeInsets.only(top: 8, left:0),
            child: Row(
              children: [
                WidgetOverCards(
                  cards: deckCubit.belowDeck,
                  widget: (deckCubit.state.deck.isEmpty) ?
                    GestureDetector(
                      onTap: () { deckCubit.reverse(); },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Icon(Icons.refresh, color: Colors.white,))
                    ) :
                    GestureDetector(
                      onTap: () { deckCubit.revealCard(); },
                      child: (deckCubit.state.deck.isEmpty)? SizedBox.shrink() : CardWidget(deckCubit.state.deck.last)
                    ),
                ),
                WidgetOverCards(
                  cards: deckCubit.state.waste,
                  widget: (deckCubit.state.active == null)?
                    SizedBox.shrink() :
                    Draggable<CardDragData>(
                      data: CardDragData(from: 0, cards: [deckCubit.state.active!]),
                      feedback: CardWidget(deckCubit.state.active!),
                      childWhenDragging: const SizedBox.shrink(),
                      child: CardWidget(deckCubit.state.active!),
                      onDragCompleted: () {
                        deckCubit.removeActive();
                      },
                  ),
                ),

            ]),
          );
        }
      ),
    );
  }
}