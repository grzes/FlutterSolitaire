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

class GameState {
  final List<ColumnCubit> columnCubits;
  GameState(this.columnCubits);
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState([])) {
    initializeGame();
  }

  void initializeGame() {
    // Create and shuffle the deck
    final deck = createDeck();
    deck.shuffle();

    // Distribute cards among columns
    final columns = distributeCards(deck, 7);

    // Create ColumnCubits for each column
    final columnCubits = columns.map((cards) => ColumnCubit(cards)).toList();

    // Update the state
    emit(GameState(columnCubits));
  }

  void flipCard(int columnIndex, int cardIndex) {
    state.columnCubits[columnIndex].flipCard(cardIndex);
    // Emit a new state to trigger rebuilds
    emit(GameState(List<ColumnCubit>.from(state.columnCubits)));
  }
}

// Helpers:

List<PlayingCard> createDeck() {
  // Create a standard deck of cards
  List<PlayingCard> deck = [];
  for (var suit in CardSuit.values) {
    for (var value in CardValue.values) {
      deck.add(PlayingCard(value, suit, faceUp: true));
    }
  }
  return deck;
}

List<List<PlayingCard>> distributeCards(List<PlayingCard> deck, int numberOfColumns) {
  List<List<PlayingCard>> columns = List.generate(numberOfColumns, (_) => []);
  for (int i = 0; i < deck.length; i++) {
    columns[i % numberOfColumns].add(deck[i]);
  }
  return columns;
}