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
  const WidgetOverCards({required this.cards, required this.widget, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 100,
      child: (cards.isEmpty)?const SizedBox.shrink() : Stack(children: [
        // 1 card if any
        for (int i=0; i<min(1, cards.length - 1); i++) CardWidget(cards[i]),
        (cards.length == 1)? widget :
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
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                WidgetOverCards(
                  cards: deckCubit.state.deck,
                  widget: GestureDetector(
                    onTap: () { deckCubit.popCard(); },
                    child: (deckCubit.state.deck.isEmpty)? SizedBox.shrink() : CardWidget(deckCubit.state.deck.last)
                  )
                ),
                WidgetOverCards(
                  cards: deckCubit.state.waste,
                  widget: GestureDetector(
                    onTap: () { deckCubit.popCard(); },
                    child: (deckCubit.state.waste.isEmpty)? SizedBox.shrink() : CardWidget(deckCubit.state.waste.last)
                  )
                ),

            ]),
          );
        }
      ),
    );
  }
}