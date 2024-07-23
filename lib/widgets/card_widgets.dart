import 'dart:math';
import 'package:blocsolitaire/widgets/card_button.dart';
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
              context.read<ColumnCubit>().addCards(details.data);
            },
            onWillAcceptWithDetails: (details) {
              return context.read<ColumnCubit>().willAcceptCards(details.data);
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
                data: CardDragData.from(cards),
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
          // Render one card if there's more than one card in the list
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
                      child: const CardFrame(
                        child: Icon(Icons.refresh, color: Colors.white)
                      )
                    ) :
                    GestureDetector(
                      onTap: () { deckCubit.revealCard(); },
                      child: (deckCubit.state.deck.isEmpty)? const SizedBox.shrink() : CardWidget(deckCubit.state.deck.last)
                    ),
                ),
                WidgetOverCards(
                  cards: deckCubit.state.waste,
                  widget: (deckCubit.state.active == null)?
                    const SizedBox.shrink() :
                    Draggable<CardDragData>(
                      data: CardDragData.from([deckCubit.state.active!]),
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

class FoundationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DragTarget<CardDragData>(
      onAcceptWithDetails: (details) {
        context.read<FoundationCubit>().addCards(details.data);
      },
      onWillAcceptWithDetails: (details) {
        return context.read<FoundationCubit>().willAcceptCards(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return BlocBuilder<FoundationCubit, FoundationState>(
          builder: (context, piles){
            return Row(children: [
              for (var suit in CardSuit.values)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: piles.containsKey(suit)?
                    CardWidget(piles[suit]!.last) :
                    CardSuitFrame(suit: suit),
                )
            ]);
          }
        );
      },
    );
  }
}