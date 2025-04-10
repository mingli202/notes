package assignment2;

import java.util.Random;

public class Deck {
  public static String[] suitsInOrder = {"clubs", "diamonds", "hearts",
                                         "spades"};
  public static Random gen = new Random();

  public int numOfCards = 0; // contains the total number of cards in the deck
  // contains a pointer to the card on the top of the deck
  public Card head = null;

  public Deck(int numOfCardsPerSuit, int numOfSuits) {
    if (numOfCardsPerSuit < 1 || numOfCardsPerSuit > 13 || numOfSuits < 1 ||
        numOfSuits > suitsInOrder.length) {
      throw new IllegalArgumentException("Must be a number between 1 and 13");
    }

    Card head = new PlayingCard("", 0);
    Card cursor = head;

    for (int i = 0; i < numOfSuits; i++) {
      for (int k = 1; k <= numOfCardsPerSuit; k++) {
        PlayingCard card = new PlayingCard(suitsInOrder[i], k);
        card.prev = cursor;
        cursor.next = card;
        cursor = cursor.next;

        this.numOfCards++;
      }
    }

    Joker redJoker = new Joker("red");
    Joker blackJoker = new Joker("black");

    cursor.next = redJoker;
    redJoker.prev = cursor;

    redJoker.next = blackJoker;
    blackJoker.prev = redJoker;

    head = head.next;

    blackJoker.next = head;
    head.prev = blackJoker;

    this.numOfCards += 2;

    this.head = head;
  }

  /*
   * Implements a copy constructor for Deck using Card.getCopy().
   * This method runs in O(n), where n is the number of cards in d.
   */
  public Deck(Deck d) {
    if (d == null || d.numOfCards == 0) {
      return;
    }

    Card head = new PlayingCard("", 0);
    Card cursor = head;
    Card d_cursor = d.head;

    for (int k = 0; k < d.numOfCards; k++) {
      Card card = d_cursor.getCopy();
      cursor.next = card;
      card.prev = cursor;

      cursor = cursor.next;
      d_cursor = d_cursor.next;
    }

    head = head.next;

    cursor.next = head;
    head.prev = cursor;

    this.numOfCards = d.numOfCards;
    this.head = head;
  }

  /*
   * For testing purposes we need a default constructor.
   */
  public Deck() {}

  /*
   * Adds the specified card at the bottom of the deck. This
   * method runs in $O(1)$.
   */
  public void addCard(Card c) {
    if (c == null) {
      return;
    }

    if (this.head == null) {
      this.head = c;
      this.head.next = head;
      this.head.prev = head;
    } else {
      head.prev.next = c;
      c.prev = this.head.prev;

      c.next = this.head;
      this.head.prev = c;
    }

    this.numOfCards++;
  }

  /*
   * Shuffles the deck using the algorithm described in the pdf.
   * This method runs in O(n) and uses O(n) space, where n is the total
   * number of cards in the deck.
   */
  public void shuffle() {
    if (this.numOfCards < 2) {
      return;
    }

    Card[] cards = new Card[this.numOfCards];

    Card it = this.head;

    for (int i = 0; i < cards.length; i++) {
      cards[i] = it;
      it = it.next;
    }

    for (int i = cards.length - 1; i > 0; i--) {
      int k = gen.nextInt(i + 1);

      Card tpm = cards[i];
      cards[i] = cards[k];
      cards[k] = tpm;
    }

    for (int i = 0; i < cards.length; i++) {
      int ind = (i + 1) % cards.length;

      cards[i].next = cards[ind];
      cards[ind].prev = cards[i];
    }

    this.head = cards[0];
  }

  /*
   * Returns a reference to the joker with the specified color in
   * the deck. This method runs in O(n), where n is the total number of
   * cards in the deck.
   */
  public Joker locateJoker(String color) {
    if (color == null) {
      return null;
    }

    Card it = this.head;
    for (int i = 0; i < this.numOfCards; i++) {
      if (it instanceof Joker && ((Joker)it).redOrBlack.equals(color)) {
        return ((Joker)it);
      }
      it = it.next;
    }

    return null;
  }

  /*
   * Moved the specified Card, p positions down the deck. You can
   * assume that the input Card does belong to the deck (hence the deck is
   * not empty). This method runs in O(p).
   */
  public void moveCard(Card c, int p) {
    for (int i = 0; i < p; i++) {
      Card next = c.next;
      Card prev = c.prev;

      c.next = next.next;
      next.next.prev = c;

      next.next = c;
      c.prev = next;

      prev.next = next;
      next.prev = prev;
    }
  }

  /*
   * Performs a triple cut on the deck using the two input cards. You
   * can assume that the input cards belong to the deck and the first one is
   * nearest to the top of the deck. This method runs in O(1)
   */
  public void tripleCut(Card firstCard, Card secondCard) {
    Card head = this.head;
    Card tail = head.prev;

    if (firstCard == head) {
      this.head = secondCard.next;
      return;
    } else if (secondCard == tail) {
      this.head = firstCard;
      return;
    }

    Card last = firstCard.prev;
    Card first = secondCard.next;

    last.next = first;
    first.prev = last;

    secondCard.next = head;
    head.prev = secondCard;

    tail.next = firstCard;
    firstCard.prev = tail;

    this.head = first;
  }

  /*
   * Performs a count cut on the deck. Note that if the value of the
   * bottom card is equal to a multiple of the number of cards in the deck,
   * then the method should not do anything. This method runs in O(n).
   */
  public void countCut() {
    if (this.numOfCards < 2) {
      return;
    }

    Card it = this.head;
    Card head = this.head;
    Card tail = this.head.prev;
    Card beforeTail = tail.prev;

    int count = tail.getValue() % this.numOfCards;

    if (count == 0 || count == this.numOfCards - 1) {
      return;
    }

    for (int i = 0; i < count - 1; i++) {
      it = it.next;
    }

    this.head = it.next;

    beforeTail.next = head;
    head.prev = beforeTail;

    it.next = tail;
    tail.prev = it;

    tail.next = this.head;
    this.head.prev = tail;
  }

  /*
   * Returns the card that can be found by looking at the value of the
   * card on the top of the deck, and counting down that many cards. If the
   * card found is a Joker, then the method returns null, otherwise it returns
   * the Card found. This method runs in O(n).
   */
  public Card lookUpCard() {
    int count = this.head.getValue();
    Card it = this.head;

    for (int i = 0; i < count; i++) {
      it = it.next;
    }

    if (it instanceof Joker) {
      return null;
    }

    return it;
  }

  /*
   * Uses the Solitaire algorithm to generate one value for the keystream
   * using this deck. This method runs in O(n).
   */
  public int generateNextKeystreamValue() {
    Card c = null;

    Joker redJoker = this.locateJoker("red");
    Joker blackJoker = this.locateJoker("black");

    while (c == null) {
      this.moveCard(redJoker, 1);
      this.moveCard(blackJoker, 2);

      Card it = this.head;

      for (int i = 0; i < this.numOfCards; i++) {
        if (it instanceof Joker) {
          String color = ((Joker)it).redOrBlack;
          if (color.equals("red")) {
            this.tripleCut(redJoker, blackJoker);
          } else {
            this.tripleCut(blackJoker, redJoker);
          }
          break;
        }

        it = it.next;
      }

      this.countCut();

      c = this.lookUpCard();
    }

    return c.getValue();
  }

  //@Override
  // public String toString() {
  //  String[] arr = new String[this.numOfCards];
  //
  //  Card cursor = this.head;
  //
  //  for (int i = 0; i < this.numOfCards; i++) {
  //    arr[i] = cursor.toString();
  //    cursor = cursor.next;
  //  }
  //
  //  return "Deck (" + this.numOfCards + ") [" + String.join(", ", arr) + "]";
  //}

  public abstract class Card {
    public Card next;
    public Card prev;

    public abstract Card getCopy();
    public abstract int getValue();
  }

  public class PlayingCard extends Card {
    public String suit;
    public int rank;

    public PlayingCard(String s, int r) {
      this.suit = s.toLowerCase();
      this.rank = r;
    }

    public String toString() {
      String info = "";
      if (this.rank == 1) {
        // info += "Ace";
        info += "A";
      } else if (this.rank > 10) {
        String[] cards = {"Jack", "Queen", "King"};
        // info += cards[this.rank - 11];
        info += cards[this.rank - 11].charAt(0);
      } else {
        info += this.rank;
      }
      // info += " of " + this.suit;
      info = (info + this.suit.charAt(0)).toUpperCase();
      return info;
    }

    public PlayingCard getCopy() {
      return new PlayingCard(this.suit, this.rank);
    }

    public int getValue() {
      int i;
      for (i = 0; i < suitsInOrder.length; i++) {
        if (this.suit.equals(suitsInOrder[i]))
          break;
      }

      return this.rank + 13 * i;
    }
  }

  public class Joker extends Card {
    public String redOrBlack;

    public Joker(String c) {
      if (!c.equalsIgnoreCase("red") && !c.equalsIgnoreCase("black"))
        throw new IllegalArgumentException("Jokers can only be red or black");

      this.redOrBlack = c.toLowerCase();
    }

    public String toString() {
      // return this.redOrBlack + " Joker";
      return (this.redOrBlack.charAt(0) + "J").toUpperCase();
    }

    public Joker getCopy() { return new Joker(this.redOrBlack); }

    public int getValue() { return numOfCards - 1; }

    public String getColor() { return this.redOrBlack; }
  }
}
