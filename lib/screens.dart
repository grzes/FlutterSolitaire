import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/card_widgets.dart';
import 'blocs/game.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: BlocBuilder<GameCubit, GameState>(
          builder: (context, gameState) {
            return Column(
              children: [
                Container(
                  width: 7*80,
                  child: Row(
                    children: [
                      DeckWidget(deckCubit: gameState.deck),
                      BlocProvider.value(
                        value: gameState.founds,
                        child: FoundationWidget(),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var item in gameState.columnCubits.asMap().entries)
                      Padding(
                        padding: const EdgeInsets.all(1), // don't need that because the columns are staggered anyway
                        child: ColumnWidget(columnCubit: item.value, index: item.key),
                      )
                  ],
                ),
              ],
            );
          }
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