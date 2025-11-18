import assignment3.*;
import java.awt.Color;
import java.util.Random;

public class Main {
  public static void main(String[] args) {
    testBlock();
    testBlob();
    testPeri();
  }

  public static void testBlock() {
    Block.gen = new Random(2);
    Block b1 = new Block(0, 0);
    b1.updateSizeAndPosition(1, 0, 0);
    System.out.print("Actual: ");
    b1.printColoredBlock();
    System.out.println(
        "Expected: B (It's normal that the colors of the letters aren't the "
        + "same as long as it's the same letter)\n");

    try {
      Block.gen = new Random(2);
      Block b2 = new Block(0, 3);
      b2.updateSizeAndPosition(2, 0, 0);
      System.out.println("Actual: ");
      b2.printColoredBlock();
    } catch (IllegalArgumentException e) {
      System.out.println("Actual: Wrong size input for max depth 3");
    } finally {
      System.out.println("Expected: Wrong size input for max depth 3\n");
    }

    try {
      Block.gen = new Random(2);
      Block b3 = new Block(1, 3);
      b3.updateSizeAndPosition(32, 3, 5);
      Block b33 = b3.getSelectedBlock(0, 0, 2);
      System.out.println("Actual: ");
      b33.printColoredBlock();
    } catch (NullPointerException e) {
      System.out.println("Actual: X and Y coordinates out of bounds");
    } finally {
      System.out.println("Expected: X and Y coordinates out of bounds (It's "
                         + "normal to have an empty \"Actual:\" above it)\n");
    }

    try {
      Block.gen = new Random(2);
      Block b4 = new Block(1, 3);
      b4.updateSizeAndPosition(32, 3, 5);
      Block b44 = b4.getSelectedBlock(32, 7, 0);
      System.out.println("Actual: ");
      b44.printColoredBlock();
    } catch (IllegalArgumentException e) {
      System.out.println("Actual: level below minimum of 1");
    } finally {
      System.out.println("Expected: level below minimum of 1\n");
    }

    try {
      Block.gen = new Random(2);
      Block bb = new Block(1, 3);
      bb.updateSizeAndPosition(32, 3, 5);
      Block bbb = bb.getSelectedBlock(32, 7, 4);
      System.out.println("Actual: ");
      bbb.printColoredBlock();
    } catch (IllegalArgumentException e) {
      System.out.println("Actual: level above maximum of 3");
    } finally {
      System.out.println("Expected: level above maximum of 3\n");
    }

    System.out.println("Actual:");
    Block.gen = new Random(2);
    Block b5 = new Block(0, 3);
    b5.updateSizeAndPosition(32, 3, 5);
    Block b55 = b5.getSelectedBlock(32, 7, 0);
    b55.printColoredBlock();
    System.out.println();
    System.out.println("Expected: ");
    System.out.println("RRRRGGGG\nRRRRGGGG\nRRRRGGGG\nRRRRGGGG\nYYYYBRBY\nYYY"
                       + "YYYRY\nYYYYGGBB\nYYYYYGGG\n");

    Block.gen = new Random(10);
    Block b6 = new Block(2, 0, 2, 2, 3, GameColors.RED, new Block[0]);
    Block b7 = new Block(0, 0, 2, 2, 3, GameColors.GREEN, new Block[0]);
    Block b8 = new Block(0, 2, 2, 2, 3, GameColors.BLUE, new Block[0]);
    Block b9 = new Block(2, 2, 2, 2, 3, GameColors.YELLOW, new Block[0]);
    Block[] arr = new Block[] {b6, b7, b8, b9};

    Block main = new Block(0, 0, 4, 1, 3, null, arr);

    System.out.println("NEW BLOCK");
    main.printColoredBlock();
    System.out.println("--AFTER COUNTERCLOCKWISE ROTATION--");
    main.rotate(0);
    main.printColoredBlock();
    System.out.println("--AFTER CLOCKWISE ROTATION-- (Should look like "
                       + "before the first rotation)");
    main.rotate(1);
    main.printColoredBlock();
    System.out.println(
        "--AFTER 4 COUNTERCLOCKWISE ROTATION-- (Should look the same)");
    main.rotate(0);
    main.rotate(0);
    main.rotate(0);
    main.rotate(0);
    main.printColoredBlock();
    System.out.println("--AFTER SMASHING--");
    main.smash();
    main.printColoredBlock();
    System.out.println("--AFTER X AXIS REFLECTION--");
    main.reflect(0);
    main.printColoredBlock();
    System.out.println("--AFTER Y AXIS REFLECTION--");
    main.reflect(1);
    main.printColoredBlock();
    System.out.println();
  }

  public static void testBlob() {
    Color[][] c1 = new Color[][] {
        {GameColors.RED, GameColors.RED, GameColors.RED, GameColors.RED},
        {GameColors.RED, GameColors.RED, GameColors.RED, GameColors.RED},
        {GameColors.RED, GameColors.RED, GameColors.RED, GameColors.RED},
        {GameColors.RED, GameColors.RED, GameColors.RED, GameColors.RED}};

    Color[][] c2 = new Color[][] {{GameColors.GREEN, GameColors.YELLOW,
                                   GameColors.GREEN, GameColors.GREEN},
                                  {GameColors.YELLOW, GameColors.GREEN,
                                   GameColors.YELLOW, GameColors.GREEN},
                                  {GameColors.GREEN, GameColors.YELLOW,
                                   GameColors.GREEN, GameColors.GREEN},
                                  {GameColors.GREEN, GameColors.GREEN,
                                   GameColors.GREEN, GameColors.GREEN}};

    boolean[][] v1 = new boolean[4][4];
    boolean[][] v2 = new boolean[4][4];
    boolean[][] v3 = new boolean[4][4];
    boolean[][] v4 = new boolean[4][4];
    boolean[][] v5 = new boolean[4][4];

    BlobGoal game1 = new BlobGoal(GameColors.RED);
    BlobGoal game2 = new BlobGoal(GameColors.BLUE);
    BlobGoal game3 = new BlobGoal(GameColors.YELLOW);
    BlobGoal game4 = new BlobGoal(GameColors.GREEN);

    System.out.println("Testing Blob Goal (look at the code to see the 2D "
                       + "array of colors used)\n");
    System.out.println("Expected: 16, Actual: " +
                       game1.undiscoveredBlobSize(2, 3, c1, v1));
    System.out.println("Expected: 0, Actual: " +
                       game2.undiscoveredBlobSize(2, 3, c1, v2));
    System.out.println("Expected: 0, Actual: " +
                       game3.undiscoveredBlobSize(1, 1, c2, v3));
    System.out.println("Expected: 1, Actual: " +
                       game4.undiscoveredBlobSize(1, 1, c2, v4));
    System.out.println("Expected: 0, Actual: " +
                       game4.undiscoveredBlobSize(10, 10, c2, v5) + "\n");
  }

  public static void testPeri() {
    Block.gen = new Random(50);
    System.out.println("Testing Perimeter Goal\n");
    Block B1 = new Block(1, 4);
    B1.updateSizeAndPosition(16, 5, 3);
    Block B2 = new Block(1, 4);
    B2.updateSizeAndPosition(48, 5, 3);

    B1.printColoredBlock();
    System.out.println();
    PerimeterGoal game5 = new PerimeterGoal(GameColors.BLUE);
    PerimeterGoal game6 = new PerimeterGoal(GameColors.YELLOW);
    System.out.println("Expected: 8, Actual: " + game5.score(B1));
    System.out.println("Expected: 7, Actual: " + game6.score(B1) + "\n");

    B2.printColoredBlock();
    System.out.println();
    PerimeterGoal game7 = new PerimeterGoal(GameColors.BLUE);
    PerimeterGoal game8 = new PerimeterGoal(GameColors.YELLOW);
    System.out.println("Expected: 8, Actual: " + game7.score(B2));
    System.out.println("Expected: 3, Actual: " + game8.score(B2));
  }
}
