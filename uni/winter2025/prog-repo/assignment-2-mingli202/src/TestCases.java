import static org.junit.jupiter.api.Assertions.*;

import assignment2.*;
import assignment2.Deck.*;
import java.util.ArrayList;
import java.util.HashSet;
import org.junit.jupiter.api.*;

// wrapper class
class D extends Deck {
  public D() { super(); }
  public D(Deck d) { super(d); }
  public D(int numOfCardsPerSuit, int numOfSuits) {
    super(numOfCardsPerSuit, numOfSuits);
  }

  public Card[] toArray() {
    Card[] arr = new Card[this.numOfCards];

    Card it = this.head;
    for (int i = 0; i < this.numOfCards; i++) {
      arr[i] = it;
      it = it.next;
    }

    return arr;
  }

  public HashSet<Card> toSet() {
    HashSet<Card> set = new HashSet<Card>(this.numOfCards);

    Card it = this.head;
    for (int i = 0; i < this.numOfCards; i++) {
      set.add(it);
      it = it.next;
    }

    return set;
  }

  @Override
  public String toString() {
    String[] arr = new String[this.numOfCards];

    Card cursor = this.head;

    for (int i = 0; i < this.numOfCards; i++) {
      arr[i] = cursor.toString();
      cursor = cursor.next;
    }

    return "D (" + this.numOfCards + ") [" + String.join(", ", arr) + "]";
  }

  @Override
  public boolean equals(Object obj) {
    if (!(obj instanceof Deck)) {
      return false;
    }

    Deck d = (Deck)obj;

    if (d.numOfCards != this.numOfCards) {
      return false;
    }

    Card it1 = d.head;
    Card it2 = this.head;

    for (int i = 0; i < this.numOfCards; i++) {
      if (!(it1.toString().equals(it2.toString()))) {
        return false;
      }
    }

    return true;
  }
}

public class TestCases {

  private void fowardAndBackwardLoop(D deck) {
    Card cursor1 = deck.head;
    Card cursor2 = deck.head.prev;

    for (int i = 0; i < deck.numOfCards; i++) {
      assertNotNull(cursor1, "forward link is not well handled");
      assertNotNull(cursor2, "backward link is not well handled");
      cursor1 = cursor1.next;
      cursor2 = cursor1.prev;
    }

    assertTrue(cursor1 == deck.head, "should loop back to head");
    assertTrue(cursor2 == deck.head.prev, "should loop back to tail");
  }

  @Test
  @Order(0)
  void deckConstructorFail() {
    assertThrows(IllegalArgumentException.class,
                 () -> { new D(0, 1); }, "check your bounds");
    assertThrows(IllegalArgumentException.class,
                 () -> { new D(14, 1); }, "check your bounds");
    assertThrows(IllegalArgumentException.class,
                 () -> { new D(4, 0); }, "check your bounds");
    assertThrows(IllegalArgumentException.class,
                 () -> { new D(4, 5); }, "check your bounds");
  }

  @Test
  @Order(1)
  void deckConstructor() {
    D deck1 = new D(1, 1);
    assertEquals("D (3) [AC, RJ, BJ]", deck1.toString(), "basic constructor");

    D deck2 = new D(null);
    assertEquals("D (0) []", deck2.toString(),
                 "copy from nothing, so should be empty");

    D deck3 = new D(13, 4);
    assertEquals(4 * 13 + 2, deck3.numOfCards);
    HashSet<String> set = new HashSet<String>(deck3.numOfCards);

    Card it = deck3.head;

    for (int i = 0; i < deck3.numOfCards; i++) {
      assertFalse(set.contains(it.toString()), "every card is unique");
      set.add(it.toString());
      it = it.next;
    }
  }

  @Test
  @Order(1)
  void deckFowardBackwardLoop() {
    D deck = new D(3, 2);
    assertEquals(8, deck.numOfCards, "should have 6 cards + 2 jokers");

    ArrayList<Card> expected = new ArrayList<Card>(deck.numOfCards);

    for (int i = 0; i < 2; i++) {
      for (int k = 1; k <= 3; k++) {
        String suit = D.suitsInOrder[i];
        expected.add(deck.new PlayingCard(suit, k));
      }
    }

    expected.add(deck.new Joker("red"));
    expected.add(deck.new Joker("black"));

    Card cursor = deck.head;
    Card cursor_back = deck.head.prev;

    for (int i = 0; i < deck.numOfCards; i++) {
      assertEquals(expected.get(i).toString(), cursor.toString(),
                   "forward looping error: check your .next links");
      assertEquals(expected.get(expected.size() - i - 1).toString(),
                   cursor_back.toString(),
                   "backward looping error: check your .prev links");

      cursor = cursor.next;
      cursor_back = cursor_back.prev;
    }

    assertEquals(expected.get(0).toString(), cursor.toString(),
                 "forward looping error: check your .next links");
    assertEquals(expected.getLast().toString(), cursor_back.toString(),
                 "backward looping error: check your .prev links");
  }

  @Test
  @Order(2)
  void deckDeepCopy() {
    D deck1 = new D(3, 2);
    D deck2 = new D(deck1);

    assertEquals(deck1.numOfCards, deck2.numOfCards,
                 "should have the same number of cards: 8 cards");

    Card cursor1 = deck1.head;
    Card cursor2 = deck2.head;

    Card cursor3 = deck1.head;
    Card cursor4 = deck2.head;

    HashSet<Card> set1 = new HashSet<Card>(deck1.numOfCards);
    HashSet<Card> set2 = new HashSet<Card>(deck2.numOfCards);

    for (int i = 0; i < deck1.numOfCards; i++) {
      assertFalse(cursor1 == cursor2, "should not be the same reference");
      assertEquals(cursor1.toString(), cursor2.toString(),
                   "should be same value but different reference");

      assertFalse(cursor3 == cursor4, "should not be the same reference");
      assertEquals(cursor3.toString(), cursor4.toString(),
                   "should be same value but different reference");

      assertFalse(set1.contains(cursor2),
                  "should not have any reference to the copied deck");
      assertFalse(set1.contains(cursor4),
                  "should not have any reference to the copied deck");
      assertFalse(set2.contains(cursor1),
                  "should not have any reference to the copied deck");
      assertFalse(set2.contains(cursor3),
                  "should not have any reference to the copied deck");
      set1.add(cursor1);
      set2.add(cursor2);

      cursor1 = cursor1.next;
      cursor2 = cursor2.next;
      cursor3 = cursor3.prev;
      cursor4 = cursor4.prev;
    }

    deck1.moveCard(deck1.head, 1);
    assertNotEquals(deck1.head.next.getValue(), deck2.head.next.getValue(),
                    "mutating one deck should not change the other deck");
  }

  @Test
  @Order(2)
  void deckDeepCopySize0() {
    D deck1 = new D();
    D deck2 = new D(deck1);

    assertEquals(deck1.numOfCards, deck2.numOfCards,
                 "should have the same number of cards: 0 card");

    assertNull(deck1.head);
    assertNull(deck2.head);
  }

  @Test
  @Order(2)
  void deckDeepCopySize1() {
    D deck1 = new D();
    deck1.addCard(deck1.new PlayingCard("clubs", 1));
    D deck2 = new D(deck1);

    assertEquals(deck1.numOfCards, deck2.numOfCards,
                 "should have the same number of cards: 1");

    Card cursor1 = deck1.head;
    Card cursor2 = deck2.head;

    Card cursor3 = deck1.head;
    Card cursor4 = deck2.head;

    assertFalse(cursor1 == cursor2, "should not be the same reference");
    assertEquals(cursor1.toString(), cursor2.toString(),
                 "shoul be same value but different reference");

    assertFalse(cursor3 == cursor4, "should not be the same reference");
    assertEquals(cursor3.toString(), cursor4.toString(),
                 "shoul be same value but different reference");

    cursor1 = cursor1.next;
    cursor2 = cursor2.next;
    cursor3 = cursor3.prev;
    cursor4 = cursor4.prev;

    assertTrue(cursor1 == deck1.head,
               "original deck: head should point to itself");
    assertTrue(cursor1.next == deck1.head,
               "original deck: head should point to itself");
    assertTrue(cursor3 == deck1.head,
               "original deck: head should point to itself");
    assertTrue(cursor3.prev == deck1.head,
               "original deck: head should point to itself");

    assertTrue(cursor2 == deck2.head,
               "copied deck: head should point to itself");
    assertTrue(cursor2.next == deck2.head,
               "copied deck: head should point to itself");
    assertTrue(cursor4 == deck2.head,
               "copied deck: head should point to itself");
    assertTrue(cursor4.prev == deck2.head,
               "copied deck: head should point to itself");
  }

  @Test
  @Order(2)
  void deckDeepCopySizeMax() {
    D deck1 = new D(13, 4);
    D deck2 = new D(deck1);

    assertEquals(deck1.numOfCards, deck2.numOfCards,
                 "should have the same number of cards: 54");

    Card cursor1 = deck1.head;
    Card cursor2 = deck2.head;

    Card cursor3 = deck1.head;
    Card cursor4 = deck2.head;

    for (int i = 0; i <= deck1.numOfCards; i++) {
      assertFalse(cursor1 == cursor2, "should not be the same reference");
      assertEquals(cursor1.toString(), cursor2.toString(),
                   "forward looping error: check your .next links");

      assertFalse(cursor3 == cursor4, "should not be the same reference");
      assertEquals(cursor3.toString(), cursor4.toString(),
                   "backward looping error: check your .prev links");

      cursor1 = cursor1.next;
      cursor2 = cursor2.next;
      cursor3 = cursor3.prev;
      cursor4 = cursor4.prev;
    }
  }

  @Test
  @Order(3)
  void deckAddCardNormal() {
    D d = new D(3, 2);
    Card head = d.head;

    d.addCard(null);
    assertEquals("D (8) [AC, 2C, 3C, AD, 2D, 3D, RJ, BJ]", d.toString(),
                 "added nothing");

    Card c = d.new PlayingCard("clubs", 1);
    d.addCard(c);

    assertTrue(d.head == head, "head remains unchanged");
    assertTrue(c == d.head.prev, "new card is the last card");

    assertTrue(c.next == d.head, ".next link of new card is properly done");
    assertTrue(c.prev == d.head.prev.prev,
               ".prev link of new card is properly done");
    assertTrue(c == d.head.prev.prev.next,
               ".next link of second to last card is properly done");
    assertEquals(9, d.numOfCards, "num of cards is handled");
  }

  @Test
  @Order(3)
  void deckAddCardSize0() {
    D d = new D();

    Card c = d.new PlayingCard("clubs", 1);
    d.addCard(c);

    assertTrue(d.head == c, "new card is the new head");
    assertTrue(d.head.prev == d.head, "head should point to itself");
    assertTrue(d.head.next == d.head, "head should point to itself");
    assertEquals(1, d.numOfCards, "num of cards is handled");
  }

  @Test
  @Order(3)
  void deckAddCardSize1() {
    D d = new D();

    Card c1 = d.new PlayingCard("clubs", 1);
    Card c2 = d.new PlayingCard("clubs", 2);
    d.addCard(c1);
    d.addCard(c2);

    //   head
    // <- c1 <-> c2 ->
    assertEquals(d.numOfCards, 2, "num of cards is handled");

    assertTrue(d.head == c1, "head is the first added card");
    assertTrue(c1 == c2.prev, ".prev link is handled");
    assertTrue(c1 == c2.next, ".next link is handled");
    assertTrue(c2 == d.head.prev, ".prev link is handled");
    assertTrue(c2 == d.head.next, ".next link is handled");
    assertEquals("D (2) [AC, 2C]", d.toString());
  }

  @Test
  @Order(4)
  void deckShuffle() {
    D.gen.setSeed(10);

    D deck = new D(13, 2);

    deck.addCard(deck.new PlayingCard("spades", 3));
    deck.shuffle();

    assertEquals(
        "D (29) [5D, 5C, 7C, KD, RJ, KC, 4C, 8C, 8D, BJ, JC, 2C, 6D, 3C, "
            + "AC, 7D, 6C, QC, AD, 2D, 10C, 10D, 3S, 4D, 9D, QD, 3D, 9C, JD]",
        deck.toString(),
        "using seed = 10 should give the same result for everybody");

    fowardAndBackwardLoop(deck);
  }

  @Test
  @Order(4)
  void deckShuffleEmptyAndSize1() {
    D deck = new D();
    assertEquals("D (0) []", deck.toString());
    deck.shuffle();
    assertEquals("D (0) []", deck.toString());

    deck.addCard(deck.new PlayingCard("clubs", 1));
    assertEquals("D (1) [AC]", deck.toString());
    deck.shuffle();
    assertEquals("D (1) [AC]", deck.toString());
  }

  @Test
  @Order(5)
  void deckShuffleNoCopy() {
    D deck = new D(5, 1);

    HashSet<Card> set = deck.toSet();
    deck.shuffle();

    for (Card c : deck.toArray()) {
      assertTrue(set.contains(c),
                 "Shuffle should not create new cards, only swapping them");
    }
  }

  @Test
  @Order(5)
  void deckActuallyShuffle() {
    D deck1 = new D(13, 4);
    deck1.shuffle();

    D deck2 = new D(13, 4);

    boolean isEqual = true;
    Card[] a1 = deck1.toArray();
    Card[] a2 = deck2.toArray();

    for (int i = 0; i < deck1.numOfCards; i++) {
      if (a1[i].getValue() != a2[i].getValue()) {
        isEqual = false;
        break;
      }
    }

    assertFalse(isEqual, "shuffle did did not shuffle");
  }

  @Test
  @Order(5)
  void deckLocateJoker() {
    D deck = new D();

    assertNull(deck.locateJoker("red"), "there's no red joker");
    assertNull(deck.locateJoker("black"), "there's no black joker");
    assertEquals(0, deck.numOfCards);

    Joker jRed = deck.new Joker("red");
    Joker jBlack = deck.new Joker("black");

    PlayingCard c1 = deck.new PlayingCard("clubs", 1);
    PlayingCard c2 = deck.new PlayingCard("clubs", 2);

    deck.addCard(c1);
    assertTrue(deck.head == c1);
    assertEquals(1, deck.numOfCards);

    deck.addCard(jRed);
    assertEquals(2, deck.numOfCards);
    assertTrue(deck.locateJoker("red") == jRed,
               "return same reference to red joker");

    deck.addCard(c2);
    deck.addCard(jBlack);
    assertTrue(deck.locateJoker("black") == jBlack,
               "return same reference to black joker");

    assertEquals("D (4) [AC, RJ, 2C, BJ]", deck.toString());

    // assertNull(deck.locateJoker("blue"), "locate a non existing joker");
    // assertNull(deck.locateJoker(null), "locate nothing");
  }

  @Test
  @Order(6)
  void deckMoveCard() {
    D deck = new D(2, 2);

    PlayingCard c1 = deck.new PlayingCard("clubs", 3);    // 3C
    PlayingCard c2 = deck.new PlayingCard("diamonds", 3); //  3D
    PlayingCard c3 = deck.new PlayingCard("clubs", 4);    // 4C

    deck.addCard(c1);
    deck.addCard(c2);
    deck.addCard(c3);

    assertEquals("D (9) [AC, 2C, AD, 2D, RJ, BJ, 3C, 3D, 4C]", deck.toString());

    deck.moveCard(c1, 0);
    assertEquals("D (9) [AC, 2C, AD, 2D, RJ, BJ, 3C, 3D, 4C]", deck.toString(),
                 "Move c1 by 0");

    deck.moveCard(c1, 1);
    assertEquals("D (9) [AC, 2C, AD, 2D, RJ, BJ, 3D, 3C, 4C]", deck.toString(),
                 "Move 3C down 1");

    deck.moveCard(c2, 1);
    assertEquals("D (9) [AC, 2C, AD, 2D, RJ, BJ, 3C, 3D, 4C]", deck.toString(),
                 "Move 3D down 1");

    deck.moveCard(c1, 3);
    assertEquals("D (9) [AC, 3C, 2C, AD, 2D, RJ, BJ, 3D, 4C]", deck.toString(),
                 "Move 3C down 2");

    deck.moveCard(c3, 4);
    assertEquals("D (9) [AC, 3C, 2C, AD, 4C, 2D, RJ, BJ, 3D]", deck.toString(),
                 "Move 4C down 4");

    deck.moveCard(c3, 10);
    assertEquals("D (9) [AC, 3C, 2C, AD, 2D, RJ, 4C, BJ, 3D]", deck.toString(),
                 "Move 4C down 10 positions same as 2");

    // deck.moveCard(c3, -5);
    // assertEquals("D (9) [AC, 4C, 3C, 2C, AD, 2D, RJ, BJ, 3D]",
    // deck.toString(),
    //              "Move 4C down -5 positions same as 2");

    fowardAndBackwardLoop(deck);
  }

  @Test
  @Order(6)
  void deckMoveHeadAndLast() {
    D deck = new D(2, 2);

    PlayingCard c1 = deck.new PlayingCard("clubs", 3);    // 3C
    PlayingCard c2 = deck.new PlayingCard("diamonds", 3); //  3D
    PlayingCard c3 = deck.new PlayingCard("clubs", 4);    // 4C

    deck.addCard(c1);
    deck.addCard(c2);
    deck.addCard(c3);

    assertEquals("D (9) [AC, 2C, AD, 2D, RJ, BJ, 3C, 3D, 4C]", deck.toString());

    deck.moveCard(deck.head, 1);
    assertEquals(
        "D (9) [AC, AD, 2D, RJ, BJ, 3C, 3D, 4C, 2C]", deck.toString(),
        "Move head by 1. Head should not move, but shift everything else");

    deck.moveCard(c3, 2);
    assertEquals("D (9) [AC, 4C, AD, 2D, RJ, BJ, 3C, 3D, 2C]", deck.toString(),
                 "Move 4C by 2. Should be below the top card");
  }

  @Test
  @Order(6)
  void deckMoveJoker() {
    D deck = new D(2, 2);
    assertEquals("D (6) [AC, 2C, AD, 2D, RJ, BJ]", deck.toString());

    Joker joker = deck.locateJoker("red");
    assertNotNull(joker);
    deck.moveCard(joker, 2);

    assertEquals("D (6) [AC, RJ, 2C, AD, 2D, BJ]", deck.toString(),
                 "Move red joker down by 2. Should never appear at the top");
  }

  @Test
  @Order(7)
  void deckTripleCut() {
    D deck = new D(6, 1);
    assertEquals("D (8) [AC, 2C, 3C, 4C, 5C, 6C, RJ, BJ]", deck.toString());

    Joker redJoker = deck.locateJoker("red");
    Joker blackJoker = deck.locateJoker("black");

    assertNotNull(redJoker);
    assertNotNull(blackJoker);

    deck.moveCard(blackJoker, 2);
    deck.moveCard(redJoker, 5);
    assertEquals("D (8) [AC, 2C, BJ, 3C, 4C, RJ, 5C, 6C]", deck.toString());

    deck.tripleCut(blackJoker, redJoker);
    assertEquals("D (8) [5C, 6C, BJ, 3C, 4C, RJ, AC, 2C]", deck.toString(),
                 "triple cut");

    deck.addCard(deck.new PlayingCard("clubs", 7));
    deck.addCard(deck.new PlayingCard("clubs", 8));
    deck.addCard(deck.new PlayingCard("clubs", 9));
    assertEquals("D (11) [5C, 6C, BJ, 3C, 4C, RJ, AC, 2C, 7C, 8C, 9C]",
                 deck.toString(), "add cards after triple cut");

    deck.tripleCut(blackJoker, redJoker);
    assertEquals("D (11) [AC, 2C, 7C, 8C, 9C, BJ, 3C, 4C, RJ, 5C, 6C]",
                 deck.toString(), "triple cut with added cards");

    fowardAndBackwardLoop(deck);
  }

  @Test
  @Order(7)
  void deckTripleCutEmptySectionAdjacent() {
    D deck = new D(6, 1);
    assertEquals("D (8) [AC, 2C, 3C, 4C, 5C, 6C, RJ, BJ]", deck.toString());

    Joker redJoker = deck.locateJoker("red");
    Joker blackJoker = deck.locateJoker("black");

    assertNotNull(redJoker);
    assertNotNull(blackJoker);

    deck.tripleCut(redJoker, blackJoker);
    assertEquals("D (8) [RJ, BJ, AC, 2C, 3C, 4C, 5C, 6C]", deck.toString());
    fowardAndBackwardLoop(deck);
    deck.addCard(deck.new PlayingCard("clubs", 7));

    deck.tripleCut(redJoker, blackJoker);
    assertEquals("D (9) [AC, 2C, 3C, 4C, 5C, 6C, 7C, RJ, BJ]", deck.toString(),
                 "triple cut after adding card");
    fowardAndBackwardLoop(deck);
  }

  @Test
  @Order(7)
  void deckTripleCutEmpty1stAnd3rdSection() {
    D deck = new D(6, 1);
    assertEquals("D (8) [AC, 2C, 3C, 4C, 5C, 6C, RJ, BJ]", deck.toString());

    Joker redJoker = deck.locateJoker("red");
    Joker blackJoker = deck.locateJoker("black");

    assertNotNull(redJoker);
    assertNotNull(blackJoker);

    deck.moveCard(redJoker, 2);
    assertEquals("D (8) [AC, RJ, 2C, 3C, 4C, 5C, 6C, BJ]", deck.toString());

    deck.tripleCut(redJoker, blackJoker);
    assertEquals("D (8) [RJ, 2C, 3C, 4C, 5C, 6C, BJ, AC]", deck.toString(),
                 "triple cut with empty 3rd section");
    deck.addCard(deck.new PlayingCard("clubs", 7));

    deck.tripleCut(redJoker, blackJoker);
    assertEquals("D (9) [AC, 7C, RJ, 2C, 3C, 4C, 5C, 6C, BJ]", deck.toString());
    fowardAndBackwardLoop(deck);
  }

  @Test
  @Order(7)
  void deckTripleCutEmptySectionAndAdjacent() {
    D deck = new D(6, 1);
    deck.head = deck.head.prev;
    assertEquals("D (8) [BJ, AC, 2C, 3C, 4C, 5C, 6C, RJ]", deck.toString());

    Joker redJoker = deck.locateJoker("red");
    Joker blackJoker = deck.locateJoker("black");

    assertNotNull(redJoker);
    assertNotNull(blackJoker);

    deck.tripleCut(blackJoker, redJoker);
    assertEquals(
        "D (8) [BJ, AC, 2C, 3C, 4C, 5C, 6C, RJ]", deck.toString(),
        "triple cut but a joker is the head and the other is the tail");
    fowardAndBackwardLoop(deck);
  }

  @Test
  @Order(7)
  void deckTripleCutNonJoker() {
    D deck = new D(6, 1);
    assertEquals("D (8) [AC, 2C, 3C, 4C, 5C, 6C, RJ, BJ]", deck.toString());
    deck.tripleCut(deck.head.next.next, deck.head.prev.prev.prev);
    assertEquals("D (8) [RJ, BJ, 3C, 4C, 5C, 6C, AC, 2C]", deck.toString(),
                 "triple cut random non joker");
  }

  @Test
  @Order(8)
  void deckCountCut() {
    D deck = new D(6, 1);
    Card c = deck.new PlayingCard("clubs", 7);
    deck.addCard(c);

    assertEquals("D (9) [AC, 2C, 3C, 4C, 5C, 6C, RJ, BJ, 7C]", deck.toString());

    deck.countCut();
    assertEquals("D (9) [BJ, AC, 2C, 3C, 4C, 5C, 6C, RJ, 7C]", deck.toString(),
                 "Take 7 from the top and put it before last");

    Card c2 = deck.new PlayingCard("clubs", 9);
    deck.addCard(c2);
    assertEquals("D (10) [BJ, AC, 2C, 3C, 4C, 5C, 6C, RJ, 7C, 9C]",
                 deck.toString());

    deck.countCut();
    assertEquals("D (10) [BJ, AC, 2C, 3C, 4C, 5C, 6C, RJ, 7C, 9C]",
                 deck.toString(),
                 "Count cut n - 1 cards, should remain unchanged");

    Card c3 = deck.new PlayingCard("clubs", 11);
    deck.addCard(c3);
    deck.countCut();
    assertEquals("D (11) [BJ, AC, 2C, 3C, 4C, 5C, 6C, RJ, 7C, 9C, JC]",
                 deck.toString(), "Count cut n cards, should remain unchanged");

    deck.addCard(deck.new PlayingCard("spades", 13));
    deck.countCut();
    assertEquals("D (12) [4C, 5C, 6C, RJ, 7C, 9C, JC, BJ, AC, 2C, 3C, KS]",
                 deck.toString(), "Count cut 52 cards, same as 4");
    fowardAndBackwardLoop(deck);
  }

  @Test
  @Order(9)
  void deckLookUpCard() {
    D deck = new D(6, 1);
    assertEquals("D (8) [AC, 2C, 3C, 4C, 5C, 6C, RJ, BJ]", deck.toString());

    Card c1 = deck.new PlayingCard("clubs", 7);
    Joker redJoker = deck.locateJoker("red");
    Joker blackJoker = deck.locateJoker("black");

    deck.addCard(c1);
    deck.tripleCut(redJoker, blackJoker);
    assertEquals("D (9) [7C, RJ, BJ, AC, 2C, 3C, 4C, 5C, 6C]", deck.toString());

    assertEquals(deck.lookUpCard().getValue(),
                 (deck.new PlayingCard("clubs", 5)).getValue(), "Look up card");
    assertTrue(deck.lookUpCard() == deck.head.prev.prev, "Look up card");

    deck.moveCard(blackJoker, 5);
    assertNull(deck.lookUpCard(), "joker should return null");
  }

  @Test
  @Order(10)
  void deckGenNextKeystreamValue() {
    D test = new D(3, 2);
    D expected = new D(3, 2);
    assertEquals("D (8) [AC, 2C, 3C, AD, 2D, 3D, RJ, BJ]", test.toString());
    assertEquals("D (8) [AC, 2C, 3C, AD, 2D, 3D, RJ, BJ]", expected.toString());

    // the steps manually
    Joker redJoker = expected.locateJoker("red");
    Joker blackJoker = expected.locateJoker("black");
    expected.moveCard(redJoker, 1);
    expected.moveCard(blackJoker, 2);
    assertEquals("D (8) [AC, BJ, 2C, 3C, AD, 2D, 3D, RJ]", expected.toString());

    expected.tripleCut(blackJoker,
                       redJoker); // make sure to find which joker comes first
    assertEquals("D (8) [BJ, 2C, 3C, AD, 2D, 3D, RJ, AC]", expected.toString());

    expected.countCut();
    assertEquals("D (8) [2C, 3C, AD, 2D, 3D, RJ, BJ, AC]", expected.toString());

    Card val = expected.lookUpCard();
    assertEquals("AD", val.toString());

    // test your method
    assertEquals(
        val.getValue(), test.generateNextKeystreamValue(),
        "your method should return the same as the steps manually done");
  }
  @Test
  @Order(10)
  void deckGenNextKeystreamValue2() {
    D deck = new D(3, 1);
    D exp = new D(3, 1);
    assertEquals("D (5) [AC, 2C, 3C, RJ, BJ]", deck.toString());
    assertEquals("D (5) [AC, 2C, 3C, RJ, BJ]", exp.toString());

    exp.moveCard(exp.locateJoker("red"), 1);
    exp.moveCard(exp.locateJoker("black"), 2);
    assertEquals("D (5) [AC, BJ, 2C, 3C, RJ]", exp.toString());
    exp.tripleCut(exp.locateJoker("black"), exp.locateJoker("red"));
    exp.countCut();
    assertEquals("D (5) [2C, 3C, RJ, BJ, AC]", exp.toString());
    assertNull(exp.lookUpCard(), "manual steps arrives at red joker");

    exp.moveCard(exp.locateJoker("red"), 1);
    exp.moveCard(exp.locateJoker("black"), 2);
    exp.tripleCut(exp.locateJoker("black"), exp.locateJoker("red"));
    exp.countCut();
    int val = exp.lookUpCard().getValue();
    assertEquals(val, 1, "manual steps arrives at AC joker");

    assertEquals(1, deck.generateNextKeystreamValue(),
                 "redo the steps after hitting a joker");
  }

  @Test
  @Order(10)
  void cipherOddKeyStreamSize() {
    D deck = new D(13, 4);
    SolitaireCipher cipher = new SolitaireCipher(deck);

    assertArrayEquals(new int[] {}, cipher.getKeystream(0));
  }

  @Test
  @Order(10)
  void exampleKeystream() {
    D.gen.setSeed(10);
    D deck = new D(5, 2);
    deck.shuffle();
    assertEquals("D (12) [3C, 3D, AD, 5C, BJ, 2C, 2D, 4D, AC, RJ, 4C, 5D]",
                 deck.toString(), "Shuffle");

    SolitaireCipher cipher = new SolitaireCipher(deck);

    assertEquals("D (12) [3C, 3D, AD, 5C, BJ, 2C, 2D, 4D, AC, RJ, 4C, 5D]",
                 deck.toString(), "Shuffle");

    assertArrayEquals(new int[] {4, 4, 15, 3, 3, 2, 1, 14, 16, 17, 17, 14},
                      cipher.getKeystream(12));
  }

  @Test
  @Order(11)
  void cipherEncodeDecode() {
    D.gen.setSeed(10);
    D deck = new D(5, 2);
    deck.shuffle();
    assertEquals("D (12) [3C, 3D, AD, 5C, BJ, 2C, 2D, 4D, AC, RJ, 4C, 5D]",
                 deck.toString(), "Shuffle");

    SolitaireCipher cipher1 = new SolitaireCipher(deck);
    SolitaireCipher cipher2 = new SolitaireCipher(deck);

    assertEquals("D (12) [3C, 3D, AD, 5C, BJ, 2C, 2D, 4D, AC, RJ, 4C, 5D]",
                 deck.toString(), "Shuffle");

    String text = "Is 02398 0)(*)9!@#@^*)_++][][;'.,?><that    øˆ¨∑´®you, "
                  + "|||``12`~~~~`12Bob?234098";
    String encoded = cipher1.encode(text);
    assertEquals("MWIKDVZCKSFP", encoded);
    assertEquals("ISTHATYOUBOB", cipher2.decode(encoded));
  }

  @Test
  @Order(11)
  void cipherNoCopy() {
    D deck = new D(5, 1);
    SolitaireCipher ciper = new SolitaireCipher(deck);
    int[] k1 = ciper.getKeystream(10);
    int[] k2 = ciper.getKeystream(10);

    boolean same = true;

    for (int i = 0; i < 10; i++) {
      if (k1[i] != k2[i]) {
        same = false;
        break;
      }
    }

    assertFalse(same, "the same cipher must not make copy of the deck when "
                          + "making the keystream");
  }

  @Test
  @Order(11)
  void ciperEncodeDecodeNothing() {
    D deck = new D(13, 4);
    deck.shuffle();
    SolitaireCipher ciper = new SolitaireCipher(deck);

    String msg = "1304987  10398  1903  475)(*&)(*& ()*& )(*&@#(*$& @#)}{ "
                 + "\": \": ?>< ?><?><? ><\"})";
    String encodedMsg = ciper.encode(msg);
    assertEquals("", encodedMsg);
    assertEquals("", ciper.encode(null));

    assertEquals("", ciper.decode(""));
    assertEquals("", ciper.decode(null));
  }
}
