import 'dart:math';
import 'package:blocsolitaire/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/game.dart';
import '../models/card.dart';
import 'card_widget.dart';

class ColumnWidget extends StatelessWidget {
  const ColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DragTarget<CardDragData>(
      onAcceptWithDetails: (details) {
        context.read<ColumnCubit>().addCards(details.data);
      },
      onWillAcceptWithDetails: (details) {
        return context.read<ColumnCubit>().willAcceptCards(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        var column = context.read<ColumnCubit>();
        return BlocBuilder<ColumnCubit, ColumnState>(
          builder: (context, state) {
            return NestedColumnStack(cards: column.state.cards);
          }
        );
      },
    );
  }
}

class NestedColumnStack extends StatelessWidget {
  final List<PlayingCard> cards;
  const NestedColumnStack({required this.cards, super.key});

  @override
  Widget build(BuildContext context) {

    Widget subStack() => Stack(children: [
      CardWidget(cards[0]),
      Positioned(
        top: 18,
        left: 2,
        child: NestedColumnStack(cards: cards.sublist(1))
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
                feedback: NestedColumnStack(cards: cards),
                childWhenDragging: const SizedBox.shrink(),
                onDragCompleted: () {
                  context.read<ColumnCubit>().removeCards(cards.length);
                },
                child: subStack(),
              ) :
              GestureDetector(
                onTap: () {
                  context.read<ColumnCubit>().flipTopCard();
                },
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
            top: 5,
            left: 5,
            child: widget
          )
      ]),
    );
  }
}

class DeckWidget extends StatelessWidget {
  const DeckWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckCubit, DeckState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, left:0),
          child: Row(
            children: [
              WidgetOverCards(
                cards: context.read<DeckCubit>().belowDeck,
                widget: (state.deck.isEmpty) ?
                  GestureDetector(
                    onTap: () {
                      context.read<DeckCubit>().reverse();
                    },
                    child: const CardFrame(
                      child: Icon(Icons.refresh, color: Colors.white)
                    )
                  ) :
                  GestureDetector(
                    onTap: () {
                      context.read<DeckCubit>().revealCard();
                    },
                    child: (state.deck.isEmpty)? const SizedBox.shrink() : CardWidget(state.deck.last)
                  ),
              ),
              WidgetOverCards(
                cards: state.waste,
                widget: (state.active == null)?
                  const SizedBox.shrink() :
                  Draggable<CardDragData>(
                    data: CardDragData.from([state.active!]),
                    feedback: CardWidget(state.active!),
                    childWhenDragging: const SizedBox.shrink(),
                    child: CardWidget(state.active!),
                    onDragCompleted: () {
                      context.read<DeckCubit>().removeActive();
                    },
                ),
              ),

          ]),
        );
      }
    );
  }
}

class FoundationWidget extends StatelessWidget {
  const FoundationWidget({super.key});

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