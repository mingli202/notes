import static org.junit.jupiter.api.Assertions.*;

import assignment2.Deck;
import assignment2.SolitaireCipher;
import java.util.Random;
import org.junit.jupiter.api.Test;
class DeckTest {

  Deck deck = new Deck(3, 4);
  Deck.Joker black = deck.locateJoker("black");
  Deck.Joker red = deck.locateJoker("red");
  Deck.Card ac = deck.head;
  Deck deck2 = new Deck(4, 2);

  Deck example = new Deck(5, 2);

  SolitaireCipher cipher = new SolitaireCipher(deck);

  /*** DECK TESTS ***/
  @Test
  public void addCard() {
    // System.out.println(dumpDeck(deck));
    assertEquals(14, deck.numOfCards);
  }

  @Test
  public void copyDeck() {
    Deck deckCopy = new Deck(deck);
    assertEquals(dumpDeck(deck), dumpDeck(deckCopy));
    assertEquals(deck.numOfCards, deckCopy.numOfCards);
  }

  //@Test // PRIVATE FUNCTION
  // public void removeCard() {
  //  deck.removeCard(red);
  //  assertEquals("1: AC; 2: 2C; 3: 3C; 4: AD; 5: 2D; 6: 3D; 7: AH; 8: 2H; 9: "
  //  +
  //               "3H; 10: AS; 11: 2S; 12: 3S; 13: BJ; ",
  //               dumpDeck(deck));
  //  assertEquals(13, deck.numOfCards);
  //}

  @Test
  public void shuffleDeck() {
    deck.shuffle();
    assertEquals(14, deck.numOfCards);
  }

  //@Test // PRIVATE FUNCTION
  // public void addCardAfter() {
  //  deck.removeCard(red);
  //  deck.addCardAfterCard(red, black);
  //  assertEquals("1: AC; 2: 2C; 3: 3C; 4: AD; 5: 2D; 6: 3D; 7: AH; 8: 2H; 9: "
  //  +
  //               "3H; 10: AS; 11: 2S; 12: 3S; 13: BJ; 14: RJ; ",
  //               dumpDeck(deck));
  //  assertEquals(14, deck.numOfCards);
  //}

  @Test
  public void moveCard() {
    deck.moveCard(red, 3);
    assertEquals("1: AC; 2: 2C; 3: RJ; 4: 3C; 5: AD; 6: 2D; 7: 3D; 8: AH; 9: "
                     + "2H; 10: 3H; 11: AS; 12: 2S; 13: 3S; 14: BJ; ",
                 dumpDeck(deck));
  }

  @Test
  public void moveHead() {
    deck.moveCard(deck.head, 1);
    assertEquals("1: AC; 2: 3C; 3: AD; 4: 2D; 5: 3D; 6: AH; 7: 2H; 8: 3H; 9: "
                     + "AS; 10: 2S; 11: 3S; 12: RJ; 13: BJ; 14: 2C; ",
                 dumpDeck(deck));
  }

  @Test
  public void moveTail() {
    deck.moveCard(deck.head.prev, 1);
    assertEquals("1: AC; 2: BJ; 3: 2C; 4: 3C; 5: AD; 6: 2D; 7: 3D; 8: AH; 9: "
                     + "2H; 10: 3H; 11: AS; 12: 2S; 13: 3S; 14: RJ; ",
                 dumpDeck(deck));
  }

  //@Test // PRIVATE FUNCTION
  // public void checkFirstJoker() {
  //  deck.moveCard(black, 3);
  //  String colour = deck.checkFirstJoker();
  //  assertEquals("black", colour);
  //}

  @Test
  public void tripleCutEnd() {
    deck.tripleCut(red, black);
    assertEquals("1: RJ; 2: BJ; 3: AC; 4: 2C; 5: 3C; 6: AD; 7: 2D; 8: 3D; 9: "
                     + "AH; 10: 2H; 11: 3H; 12: AS; 13: 2S; 14: 3S; ",
                 dumpDeck(deck));
  }

  @Test
  public void testTripleCut() {
    Deck mock = mockDeck(3, 6);
    Deck.Joker mockRed = mock.locateJoker("red");
    Deck.Joker mockBlack = mock.locateJoker("black");
    mock.tripleCut(mockRed, mockBlack);
    assertEquals(
        "1: 7C; 2: 8C; 3: 9C; 4: RJ; 5: 4C; 6: 5C; 7: BJ; 8: AC; 9: 2C; ",
        dumpDeck(mock));

    mock = mockDeck(1, 6);
    mockRed = mock.locateJoker("red");
    mockBlack = mock.locateJoker("black");
    mock.tripleCut(mockRed, mockBlack);
    assertEquals(
        "1: 7C; 2: 8C; 3: 9C; 4: RJ; 5: 2C; 6: 3C; 7: 4C; 8: 5C; 9: BJ; ",
        dumpDeck(mock));
  }

  @Test
  public void countCut() {
    deck.removeCard(ac);
    deck.addCard(ac);
    deck.countCut();
    assertEquals("1: 3C; 2: AD; 3: 2D; 4: 3D; 5: AH; 6: 2H; 7: 3H; 8: AS; 9: "
                     + "2S; 10: 3S; 11: RJ; 12: BJ; 13: 2C; 14: AC; ",
                 dumpDeck(deck));
  }

  @Test
  public void lookupCard() {
    assertEquals(deck.head.next, deck.lookUpCard());
  }

  @Test
  public void generateNextKeystreamValue() {
    System.out.println(deck.generateNextKeystreamValue());
    System.out.println(dumpDeck(deck));
    assertEquals(14, deck.numOfCards);
  }

  @Test
  public void generateNextKeystreamValue2() {
    System.out.println(deck2.generateNextKeystreamValue());
    System.out.println(dumpDeck(deck2));
    assertEquals(10, deck2.numOfCards);
  }

  /*** SOLITAIRE CYPHER TESTS ***/
  //@Test // PRIVATE FUNCTION
  // public void manipulateMsg() {
  //  String s = SolitaireCipher.manipulateMsg("Is that you, Bob?");
  //  assertEquals("ISTHATYOUBOB", s);
  //}

  /*** SOLITAIRE CYPHER TESTS ***/
  @Test
  public void exampleShuffle() {
    Deck.gen = new Random(10);
    example.shuffle();
    assertEquals("1: 3C; 2: 3D; 3: AD; 4: 5C; 5: BJ; 6: 2C; 7: 2D; 8: 4D; 9: "
                     + "AC; 10: RJ; 11: 4C; 12: 5D; ",
                 dumpDeck(example));
  }

  @Test
  public void generateKeystream() {
    Deck.gen = new Random(10);
    example.shuffle();
    SolitaireCipher sc = new SolitaireCipher(example);
    int[] arr = sc.getKeystream(12);
    assertEquals("4, 4, 15, 3, 3, 2, 1, 14, 16, 17, 17, 14, ", arrString(arr));
  }

  @Test
  public void encode() {
    Deck.gen = new Random(10);
    example.shuffle();
    SolitaireCipher sc = new SolitaireCipher(example);
    String msg = sc.encode("Is that you, Bob?");
    assertEquals("MWIKDVZCKSFP", msg);
  }

  @Test
  public void decode() {
    Deck.gen = new Random(10);
    example.shuffle();
    SolitaireCipher sc = new SolitaireCipher(example);
    String msg = sc.decode("MWIKDVZCKSFP");
    assertEquals("ISTHATYOUBOB", msg);
  }

  // helper functions
  private String dumpDeck(Deck d) {
    String returnString = "";
    Deck.Card c = d.head;
    for (int i = 0; i < d.numOfCards; i++) {
      returnString += (i + 1) + ": " + c.toString() + "; ";
      c = c.next;
    }
    return returnString;
  }

  private Deck mockDeck(int firstJoker, int secondJoker) {
    Deck d = new Deck();
    String suit = "clubs";

    for (int i = 1; i <= 9; i++) {
      if (i == firstJoker) {
        Deck.Card joker = d.new Joker("red");
        d.addCard(joker);
      } else if (i == secondJoker) {
        Deck.Card joker = d.new Joker("black");
        d.addCard(joker);
      } else {
        Deck.Card card = d.new PlayingCard(suit, i);
        d.addCard(card);
      }
    }
    return d;
  }

  private String arrString(int[] arr) {
    String s = "";
    for (int j : arr) {
      s += j + ", ";
    }
    return s;
  }
}
