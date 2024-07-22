import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/game.dart';
import '../models/card.dart';
import 'card_widget.dart';

class ColumnWidget extends StatelessWidget {
  final ColumnCubit columnCubit;
  const ColumnWidget({required this.columnCubit, super.key});

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
              return SizedBox(
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
                          childWhenDragging: SizedBox.shrink(),
                          child: GestureDetector(
                            onTap: () => context.read<ColumnCubit>().flipCard(i),
                            child: CardWidget(state.cards[i]),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}