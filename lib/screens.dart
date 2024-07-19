import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/card_widget.dart';
import 'widgets/card_column_widget.dart';
import 'models/card.dart';
import 'blocs/game.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ColumnCubit([
        PlayingCard(CardValue.ten, CardSuit.clubs),
        PlayingCard(CardValue.jack, CardSuit.clubs, faceUp: true),
        PlayingCard(CardValue.queen, CardSuit.clubs),
      ]),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColumnWidget(),
              SizedBox(width: 20),
              ColumnWidget(),
              //ColumnWidget()
            ],
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Restart',
          child: const Icon(Icons.refresh),
        ),*/
      ),
    );
  }
}