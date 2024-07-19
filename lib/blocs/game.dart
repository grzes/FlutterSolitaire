import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card.dart';

class ColumnState {
  final List<PlayingCard> cards;

  ColumnState(this.cards);
}

// Define the Cubit
class ColumnCubit extends Cubit<ColumnState> {
  ColumnCubit(List<PlayingCard> initialCards)
      : super(ColumnState(initialCards));

  void flipCard(int index) {
    final cards = List<PlayingCard>.from(state.cards);
    final card = cards[index];
    cards[index] = PlayingCard(card.value, card.suit, faceUp: !card.faceUp);
    emit(ColumnState(cards));
  }
}