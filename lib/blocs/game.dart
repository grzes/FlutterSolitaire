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

  void flipTopCard() {
    if (state.cards.lastOrNull?.faceUp == false) {
      flipCard(state.cards.length-1);
    }
  }

  void removeCards(int num) {
    emit(ColumnState(state.cards.sublist(0, state.cards.length - num)));
  }

  bool willAcceptCards(List<PlayingCard> cards) {
    if (state.cards.isEmpty) {
      return cards[0].value == CardValue.king;
    }
    var last = state.cards.last;
    var first = cards[0];
    return last.faceUp && last.cardColor != first.cardColor
      && last.value.index == first.value.index + 1;
  }

  void addCards(List<PlayingCard> cards) {
    emit(ColumnState(state.cards + cards));
  }
}


class DeckState {
  final List<PlayingCard> deck;
  final List<PlayingCard> waste;
  DeckState(this.deck, this.waste);
}

class DeckCubit extends Cubit<DeckState> {
  DeckCubit(List<PlayingCard> deck)
      : super(DeckState(deck, List<PlayingCard>.empty()));

}

class GameState {
  final List<ColumnCubit> columnCubits;
  final DeckCubit deck;
  GameState(this.columnCubits, this.deck);
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState([], DeckCubit([]))) {
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
    emit(GameState(columnCubits, DeckCubit(deck.sublist(28))));
  }
}

// Helpers:

List<PlayingCard> createDeck() {
  // Create a standard deck of cards
  List<PlayingCard> deck = [];
  for (var suit in CardSuit.values) {
    for (var value in CardValue.values) {
      deck.add(PlayingCard(value, suit));
    }
  }
  return deck;
}

List<List<PlayingCard>> distributeCards(List<PlayingCard> deck, int numberOfColumns) {
  List<List<PlayingCard>> columns = List.generate(numberOfColumns, (_) => []);

  PlayingCard faceUp(PlayingCard card) => PlayingCard(card.value, card.suit, faceUp: true);
  PlayingCard faceDown(PlayingCard card) => card;

  int deckindex = 0;
  for (int c=0; c<numberOfColumns; c++) {
    for (int down=0; down < c; down++) {
      columns[c].add(faceDown(deck[deckindex]));
      deckindex++;
    }
    columns[c].add(faceUp(deck[deckindex]));
    deckindex++;
  }
  return columns;
}

class CardDragData {
  final int from;
  final List<PlayingCard> cards;
  const CardDragData({required this.from, required this.cards});
}