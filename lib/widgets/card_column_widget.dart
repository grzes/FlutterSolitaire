import 'package:blocsolitaire/widgets/constants.dart';
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
              return NestedStack(columnCubit: column, index: index, cards: column.state.cards);
            },
          );
        },
      ),
    );
  }
}

class NestedStack extends StatelessWidget {
  final ColumnCubit columnCubit;
  final int index;
  final List<PlayingCard> cards;
  const NestedStack({required this.columnCubit, required this.index, required this.cards, super.key});

  @override
  Widget build(BuildContext context) {

    Widget subStack() => Stack(children: [
      CardWidget(cards[0]),
      Positioned(
        top: 18,
        left: 2,
        child: NestedStack(columnCubit: columnCubit, index: index, cards: cards.sublist(1))
      )
    ]);


    return SizedBox(
      width: 90,
      height: 430,
      child:
        (cards.isEmpty) ?
          SizedBox.shrink() :
            (cards[0].faceUp) ?
              Draggable<CardDragData>(
                data: CardDragData(from: index, cards: cards),
                feedback: NestedStack(columnCubit: columnCubit, index: index, cards: cards),
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
