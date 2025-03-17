import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import assignment2.*;
import org.junit.jupiter.api.*;

public class Tester {
  @Test
  void testDeckConstructor() {
    assertThrows(IllegalArgumentException.class,
                 () -> { Deck deck = new Deck(0, 0); });

    assertThrows(IllegalArgumentException.class,
                 () -> { Deck deck = new Deck(1, 0); });

    assertThrows(IllegalArgumentException.class,
                 () -> { Deck deck = new Deck(0, 1); });

    assertThrows(IllegalArgumentException.class,
                 () -> { Deck deck = new Deck(14, 1); });

    assertThrows(IllegalArgumentException.class,
                 () -> { Deck deck = new Deck(1, 5); });

    assertThrows(IllegalArgumentException.class,
                 () -> { Deck deck = new Deck(14, 5); });

    Deck deck = new Deck(1, 1);
    assertEquals(3, deck.numOfCards);
    assertEquals("AC", deck.head.toString());
    assertEquals("RJ", deck.head.next.toString());
    assertEquals("BJ", deck.head.next.next.toString());
    assertEquals("AC", deck.head.next.next.next.toString());

    deck = new Deck(2, 1);
    assertEquals(4, deck.numOfCards);
    assertEquals("AC", deck.head.toString());
    assertEquals("2C", deck.head.next.toString());
    assertEquals("RJ", deck.head.next.next.toString());
    assertEquals("BJ", deck.head.next.next.next.toString());
    assertEquals("AC", deck.head.next.next.next.next.toString());

    deck = new Deck(2, 2);
    assertEquals(6, deck.numOfCards);
    assertEquals("AC", deck.head.toString());
    assertEquals("2C", deck.head.next.toString());
    assertEquals("AD", deck.head.next.next.toString());
    assertEquals("2D", deck.head.next.next.next.toString());
    assertEquals("RJ", deck.head.next.next.next.next.toString());
    assertEquals("BJ", deck.head.next.next.next.next.next.toString());
    assertEquals("AC", deck.head.next.next.next.next.next.next.toString());

    // to be changed need to ensure that it is a deep copy by asserting deck and
    // deck_copy references are not equal
    Deck deck_copy = new Deck(deck);
    assertEquals(6, deck_copy.numOfCards);
    assertEquals("AC", deck_copy.head.toString());
    assertEquals("2C", deck_copy.head.next.toString());
    assertEquals("AD", deck_copy.head.next.next.toString());
    assertEquals("2D", deck_copy.head.next.next.next.toString());
    assertEquals("RJ", deck_copy.head.next.next.next.next.toString());
    assertEquals("BJ", deck_copy.head.next.next.next.next.next.toString());
    assertEquals("AC", deck_copy.head.next.next.next.next.next.next.toString());

    deck = new Deck(1, 1);
    Deck.PlayingCard c = deck.new PlayingCard("spades", 1);
    deck.addCard(c);
    assertEquals(4, deck.numOfCards);
    assertEquals("AC", deck.head.toString());
    assertEquals("RJ", deck.head.next.toString());
    assertEquals("BJ", deck.head.next.next.toString());
    assertEquals("AS", deck.head.next.next.next.toString());
    assertEquals("AC", deck.head.next.next.next.next.toString());

    Deck.Card cur = deck.head;
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // SHUFFLE
    deck.shuffle();
    cur = deck.head;
    System.out.print("Shuffled deck: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // LOCATEJOKER
    Deck.Joker bJokerFromDeck = deck.locateJoker("black");
    System.out.println("Joker " + bJokerFromDeck.toString() + " located.");

    Deck.Joker rJokerFromDeck = deck.locateJoker("red");
    System.out.println("Joker " + rJokerFromDeck.toString() + " located.");

    // FRESHDECK
    deck = new Deck(2, 1);
    cur = deck.head;
    System.out.print("FreshDeck: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // MOVE HEAD BY 2
    Deck.Card cardToMove = deck.head;
    deck.moveCard(cardToMove, 2);
    cur = deck.head;
    System.out.print("Head moved by 2: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // FRESHDECK
    deck = new Deck(2, 1);
    cur = deck.head;
    System.out.print("FreshDeck: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // MOVE SECOND CARD BY 2
    cardToMove = deck.head.next;
    deck.moveCard(cardToMove, 2);
    cur = deck.head;
    System.out.print("Second Card moved by 2: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // FRESHDECK
    deck = new Deck(2, 2);
    cur = deck.head;
    System.out.print("FreshDeck: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // TRIPECUT
    deck.tripleCut(deck.head.next.next, deck.head.prev.prev);
    cur = deck.head;
    System.out.print("Triple cut complete: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // FRESHDECK
    deck = new Deck(3, 2);
    Deck.PlayingCard c2 = deck.new PlayingCard("clubs", 3);
    deck.addCard(c2);
    cur = deck.head;
    System.out.print("FreshDeck: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // COUNTCUT
    deck.countCut();
    cur = deck.head;
    System.out.print("Count cut complete: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    // FRESHDECK
    deck = new Deck(3, 2);
    Deck.PlayingCard c3 = deck.new PlayingCard("clubs", 3);
    deck.addCard(c3);
    deck.moveCard(deck.head.prev, 6);
    deck.tripleCut(deck.head.next.next.next, deck.head.prev.prev.prev);
    cur = deck.head;
    System.out.print("FreshDeck: ");
    while (cur != deck.head.prev) {
      System.out.print(cur.toString() + ", ");
      cur = cur.next;
    }
    System.out.println(cur.toString());

    System.out.println(deck.lookUpCard().toString());
  }
}
