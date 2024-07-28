import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/card_widgets.dart';
import 'widgets/card_button.dart';
import 'blocs/autoplay.dart';
import 'blocs/game.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OverlayEntry? overlayEntry;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: Column(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              children: [
                BlocBuilder<GameWon, bool>(
                  builder: (context, gameIsWon) {
                    overlayEntry?.remove();
                    overlayEntry = null;

                    if (gameIsWon) {
                      Future.delayed(Duration(microseconds: 1), () {
                        overlayEntry = WinScreen();
                        Overlay.of(context).insert(overlayEntry!);
                      });
                    }
                    return SizedBox.shrink();
                  }
                ),
                BlocBuilder<GameCubit, GameState>(
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
                                  autoplay.startAutoPlay(() {
                                    var stop = game.solveMove();
                                    if (stop) {
                                      context.read<GameWon>().setTrue();
                                    }
                                    return stop;
                                  });
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
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CascadeCards()
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                overlayEntry?.remove();
                overlayEntry = null;
                context.read<GameWon>().setFalse();
                context.read<GameCubit>().initializeGame();
              },
              tooltip: 'Restart',
              child: const Icon(Icons.refresh),
            ),
          ),
          /*
          Positioned(
            bottom: 20,
            right: 120,
            child: FloatingActionButton(
              onPressed: () {
                context.read<GameWon>().setTrue();
              },
              tooltip: 'Win',
              child: const Icon(Icons.sports_score),
            ),
          ),
          */
        ],
      ),
    );
  }
}

OverlayEntry WinScreen() {
  return OverlayEntry(
    builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.black.withOpacity(0.8),
          child: const Text(
            'Congratulations!',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    ),
  );
}