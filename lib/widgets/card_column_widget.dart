import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/game.dart';
import 'card_widget.dart';

class ColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColumnCubit, ColumnState>(
      builder: (context, state) {
        return SizedBox(
          width: 70,
          height: 150,
          child: Stack(
            children: [
              for (var i=0; i<state.cards.length; i++)
                Positioned(
                  top: i * 18,
                  left: i * 6,
                  child: GestureDetector(
                    onTap: () => context.read<ColumnCubit>().flipCard(i),
                    child: CardWidget(state.cards[i]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}