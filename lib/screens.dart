import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/card_widgets.dart';
import 'widgets/card_button.dart';
import 'blocs/autoplay.dart';
import 'blocs/game.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: BlocProvider.value(
          value: AutoPlayCubit(),
          child: BlocBuilder<GameCubit, GameState>(
            builder: (context, gameState) {
              return Column(
                children: [
                  Container(
                    width: 7*80,
                    child: Row(
                      children: [
                        (gameState.canAutoPlay) ?
                        GestureDetector(
                          onTap: () {
                            final autoplay = context.read<AutoPlayCubit>();
                            final game = context.read<GameCubit>();
                            autoplay.startAutoPlay(() => game.solveMove());
                          },
                          child: const CardFrame(
                            child: Icon(Icons.play_arrow_rounded, color: Colors.white)
                          )
                        ) :
                        BlocProvider.value(
                          value: gameState.deck,
                          child: DeckWidget(),
                        ),
                        Spacer(),
                        BlocProvider.value(
                          value: gameState.founds,
                          child: FoundationWidget(),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var column in gameState.columnCubits.reversed)
                        Padding(
                          padding: const EdgeInsets.all(1), // don't need that because the columns are staggered anyway
                          child: BlocProvider.value(
                            value: column,
                            child: ColumnWidget()
                          ),
                        )
                    ],
                  ),
                ],
              );
            }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GameCubit>().initializeGame();
        },
        tooltip: 'Restart',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}