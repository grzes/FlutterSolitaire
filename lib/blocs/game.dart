import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card.dart';


typedef CardDragData = List<PlayingCard>;

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

  bool flipTopCard() {
    if (state.cards.lastOrNull?.faceUp == false) {
      flipCard(state.cards.length-1);
    }
    return allFaceUp;
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

  bool get allFaceUp {
    for (var c in state.cards) {
      if (!c.faceUp) return false;
    }
    return true;
  }
}

class DeckState {
  final PlayingCard? active;
  final List<PlayingCard> deck;
  final List<PlayingCard> waste;
  DeckState(this.deck, this.waste, this.active);

  bool get isEmpty =>
    deck.isEmpty && waste.isEmpty && active == null;

}

class DeckCubit extends Cubit<DeckState> {
  DeckCubit(List<PlayingCard> deck)
      : super(DeckState(deck, <PlayingCard>[], null));

  List<PlayingCard> get belowDeck {
    if (state.deck.length > 1) {
      int l = state.deck.length;
      return state.deck.sublist(l-1, l);
    }
    return <PlayingCard>[];
  }

  void revealCard() {
    final deck = List<PlayingCard>.from(state.deck);
    final waste = List<PlayingCard>.from(state.waste);
    if (deck.isEmpty) return;

    if (state.active != null) {
      waste.add(state.active!.getFaceUp());
    }
    var active = deck.removeLast().getFaceUp();
    emit(DeckState(deck, waste, active));
  }

  bool removeActive() {
    emit(DeckState(state.deck, state.waste, null));
    return state.isEmpty;
  }

  void reverse() {
    final deck = List<PlayingCard>.from(state.deck);
    final waste = List<PlayingCard>.from(state.waste);
    assert(deck.isEmpty);
    // deck.add(state.active?.getFaceDown())
    if (state.active != null) {
      deck.add(state.active!.getFaceDown());
    }
    for (var card in waste.reversed) {
      deck.add(card.getFaceDown());
    }
    emit(DeckState(deck, [], null));
  }
}

typedef FoundationState = Map<CardSuit, List<PlayingCard>>;

class FoundationCubit extends Cubit<FoundationState> {
  FoundationCubit(super.map);

  bool willAcceptCards(List<PlayingCard> cards) {
    if (cards.length != 1) return false;

    if (!state.containsKey(cards[0].suit)) {
      return cards[0].value == CardValue.ace;
    }
    return state[cards[0].suit]!.last.value.index + 1 == cards[0].value.index;
  }

  void addCards(List<PlayingCard> cards) {
    assert(cards.length == 1);
    final card = cards[0].getFaceUp();
    final piles = FoundationState.from(state);
    if (!piles.containsKey(card.suit)) {
      piles[card.suit] = [];
    }
    piles[card.suit]!.add(card);
    emit(piles);
  }
}

class GameState {
  final List<ColumnCubit> columnCubits;
  final DeckCubit deck;
  final FoundationCubit founds;
  final bool canAutoPlay;
  GameState(this.columnCubits, this.deck, this.founds, {this.canAutoPlay = false});
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState([], DeckCubit([]), FoundationCubit({}))) {
    initializeGame();
  }

  void initializeGame() {
    // Create and shuffle the deck
    List<PlayingCard> allcards = [];
    for (var value in CardValue.values.reversed) {
      for (var suit in CardSuit.values) {
        allcards.add(PlayingCard(value, suit));
      }
    }
    List<List<PlayingCard>> columns = List.generate(7, (_) => []);

    final FoundationState piles = FoundationState();
    List<PlayingCard> remaining = [];

    for (int i=0; i < 12; i++) {
      for(int s=0; s<4; s++) {
        int offset = (i%2==0)?2:0;
        columns[(s + offset) % 4].add(allcards.removeAt(0).getFaceUp());
      }
    }
    var c = columns[0].removeLast();
    columns[4].add(c.getFaceDown());
    final columnCubits = columns.map((cards) => ColumnCubit(cards)).toList();

    emit(GameState(columnCubits, DeckCubit(allcards), FoundationCubit({})));
    /*
    final deck = createDeck();
    deck.shuffle();

    // Distribute cards among columns
    final columns = distributeCards(deck, 7);

    // Create ColumnCubits for each column
    final columnCubits = columns.map((cards) => ColumnCubit(cards)).toList();


    // Update the state
    emit(GameState(columnCubits, DeckCubit(deck.sublist(28)), FoundationCubit({})));
    */
  }

  void checkAutoPlay() {
    if (!state.deck.state.isEmpty) return;
    for (var c in state.columnCubits) {
      if (!c.allFaceUp) return;
    }
    emit(GameState(state.columnCubits, state.deck, state.founds, canAutoPlay: true));
  }

  void solveMove() {
    for (int c=0; c<7; c++) {
      if (!state.columnCubits[c].state.cards.isEmpty){
        state.columnCubits[c].removeCards(1);
        return;
      }
    }
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

  int deckindex = 0;
  for (int c=0; c<numberOfColumns; c++) {
    for (int down=0; down < c; down++) {
      columns[c].add(deck[deckindex].getFaceDown());
      deckindex++;
    }
    columns[c].add(deck[deckindex].getFaceUp());
    deckindex++;
  }
  return columns;
}
