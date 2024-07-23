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
  final PlayingCard? active;
  final List<PlayingCard> deck;
  final List<PlayingCard> waste;
  DeckState(this.deck, this.waste, this.active);
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

  void removeActive() {
    emit(DeckState(state.deck, state.waste, null));
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

class FoundationCubit extends Cubit<Map<CardSuit, List<PlayingCard>>> {
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
    final piles = Map<CardSuit, List<PlayingCard>>.from(state);
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
  GameState(this.columnCubits, this.deck, this.founds);
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState([], DeckCubit([]), FoundationCubit({}))) {
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
    emit(GameState(columnCubits, DeckCubit(deck.sublist(28)), FoundationCubit({})));
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

class CardDragData {
  final int from;
  final List<PlayingCard> cards;
  const CardDragData({required this.from, required this.cards});
}