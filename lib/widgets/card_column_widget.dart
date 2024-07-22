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
    if (cards.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      width: 90,
      height: 430,
      child: Draggable<PlayingCard>(
        data: cards[0],
        feedback: NestedStack(columnCubit: columnCubit, index: index, cards: cards),
        childWhenDragging: const SizedBox.shrink(),
        child: GestureDetector(
          onTap: () => {},//context.read<ColumnCubit>().flipCard(i),
          child: Stack(children: [
            CardWidget(cards[0]),
            Positioned(
              top: 18,
              left: 3,
              child: NestedStack(columnCubit: columnCubit, index: index, cards: cards.sublist(1))
            )
          ])
        ),
      ),
    );
  }
}
