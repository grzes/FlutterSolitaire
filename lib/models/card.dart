
enum CardColor {
  red,
  black,
}

enum CardSuit {
  spades,
  hearts,
  diamonds,
  clubs;

  String get asCharacter => switch (this) {
    spades => '♠',
    hearts => '♥',
    diamonds => '♦',
    clubs => '♣'
  };
}

enum CardValue {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king;

  String get asCharacter => switch (this) {
    ace => 'A',
    two => '2',
    three => '3',
    four => '4',
    five => '5',
    six => '6',
    seven => '7',
    eight => '8',
    nine => '9',
    ten => '10',
    jack => 'J',
    queen => 'Q',
    king => 'K',
  };
}

class PlayingCard {
  CardSuit suit;
  CardValue value;
  bool faceUp;

  PlayingCard(this.value, this.suit, {this.faceUp = false});

  CardColor get cardColor {
    if(suit == CardSuit.hearts || suit == CardSuit.diamonds) {
      return CardColor.red;
    } else {
      return CardColor.black;
    }
  }

  PlayingCard getFaceUp() => (faceUp)? this : PlayingCard(value, suit, faceUp: true);
  PlayingCard getFaceDown() => (!faceUp)? this : PlayingCard(value, suit, faceUp: false);
}
