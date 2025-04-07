import static org.junit.jupiter.api.Assertions.*;

import assignment3.*;
import java.awt.*;
import java.lang.reflect.Field;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

public class ReleasedHiddenTester {
  @Test
  @Tag("score:1")
  @DisplayName("Secret Block constructor test2")
  public void secret_block3()
      throws NoSuchFieldException, IllegalAccessException {
    Block.gen = new Random(47941931);

    final Block[] b = new Block[1];

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        b[0] = new Block(4, 6);
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    Block expected = new Block(0, 0, 0, 4, 6, GameColors.RED, new Block[0]);

    assertTrue(HelperMethods.equals(expected, b[0]),
               "Blocks are not generated correctly. "
                   + "Expected one block of RED color.");
  }
  @Test
  @Tag("score:2")
  @DisplayName("Secret getBlocksToDraw() test1")
  public void secret_getBlocksToDraw1() {
    Block.gen = new Random(415135);
    Block b = new Block(0, 4);
    b.updateSizeAndPosition(128, 0, 0);
    //        Block b = rb.toBlock();

    final ArrayList<BlockToDraw>[] result = new ArrayList[] {new ArrayList<>()};

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        result[0] = b.getBlocksToDraw();
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertEquals(
        116, result[0].size(),
        "getBlocksToDraw() is returning incorrect number of BlocksToDraw.");

    int frameBorderBlocks = 0;
    int red = 0, green = 0, blue = 0, yellow = 0;

    for (int i = 0; i < result[0].size(); i++) {
      if (result[0].get(i).getColor() == GameColors.FRAME_COLOR &&
          result[0].get(i).getStrokeThickness() == 3) {
        frameBorderBlocks++;
      } else if (result[0].get(i).getColor() == GameColors.RED &&
                 result[0].get(i).getStrokeThickness() == 0) {
        red++;
      } else if (result[0].get(i).getColor() == GameColors.GREEN &&
                 result[0].get(i).getStrokeThickness() == 0) {
        green++;
      } else if (result[0].get(i).getColor() == GameColors.BLUE &&
                 result[0].get(i).getStrokeThickness() == 0) {
        blue++;
      } else if (result[0].get(i).getColor() == GameColors.YELLOW &&
                 result[0].get(i).getStrokeThickness() == 0) {
        yellow++;
      }
    }

    assertEquals(58, frameBorderBlocks,
                 "getBlocksToDraw() is returning incorrect number of "
                     + "FRAME_COLOR blocks.");
    assertEquals(
        13, red,
        "getBlocksToDraw() is returning incorrect number of RED blocks.");
    assertEquals(
        13, green,
        "getBlocksToDraw() is returning incorrect number of GREEN blocks.");
    assertEquals(
        18, blue,
        "getBlocksToDraw() is returning incorrect number of BLUE blocks.");
    assertEquals(
        14, yellow,
        "getBlocksToDraw() is returning incorrect number of YELLOW blocks.");
  }
  @Test
  @Tag("score:2")
  @DisplayName("Secret getSelectedBlock() test3")
  public void secret_getSelectedBlock3()
      throws NoSuchFieldException, IllegalAccessException {
    Block.gen = new Random(14868663);
    Block b = new Block(0, 2);
    b.updateSizeAndPosition(8, 0, 0);

    Block[] actualSelectedBlock = new Block[1];

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        actualSelectedBlock[0] = b.getSelectedBlock(0, 0, 0);
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertTrue(HelperMethods.equals(actualSelectedBlock[0], b),
               "getSelectedBlock() is not returning the correct block.");
  }
  @Test
  @Tag("score:1")
  @DisplayName("Secret getSelectedBlock() test1")
  public void secret_getSelectedBlock1() {
    Block.gen = new Random(1314262);
    Block b = new Block(0, 2);
    b.updateSizeAndPosition(8, 4, 4);

    Block[] selectedBlock = new Block[1];

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        selectedBlock[0] = b.getSelectedBlock(1, 2, 2);
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertNull(selectedBlock[0], "getSelectedBlock() is not returning null "
                                     +
                                     "when the position is outside the block.");
  }
  @Test
  @Tag("score:1")
  @DisplayName("Secret rotate() test1")
  public void secret_rotate1()
      throws NoSuchFieldException, IllegalAccessException {
    Block.gen = new Random(1245);
    Block b = new Block(0, 2);
    b.updateSizeAndPosition(8, 0, 0);
    Block toRotate = b.getSelectedBlock(4, 2, 2);

    Block.gen = new Random(1245);
    Block rb = new Block(0, 2);
    rb.updateSizeAndPosition(8, 0, 0);
    Block reference = rb.getSelectedBlock(4, 2, 2);

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750),
                                         ()
                                             -> {
                                           try {
                                             toRotate.rotate(0);
                                           } catch (Exception e) {
                                             fail("Unexpected exception: " + e);
                                           }
                                         },
                                         "Took too long / Infinite loop"

    );

    assertTrue(HelperMethods.equals(reference, toRotate),
               "rotate() is changing size/coordinates when the rotation is "
                   + "not possible.");
  }

  @Test
  @Tag("score:1")
  @DisplayName("Secret flatten() test2")
  void secret_flatten2() {
    Block.gen = new Random(9876);
    Block b = new Block(2, 2);
    b.updateSizeAndPosition(6, 10, 2);

    Color[][][] c = {null};

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        c[0] = b.flatten();
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertEquals(
        GameColors.YELLOW, c[0][0][0],
        "flatten() is not returning the block colors in the correct order.");
  }

  @Test
  @Tag("score:2")
  @DisplayName("Secret flatten() test4")
  void secret_flatten4() {
    Block.gen = new Random(777777);
    Block b = new Block(4, 8);
    b.updateSizeAndPosition(80, 5, 10);

    Color[][][] c = {null};

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        c[0] = b.flatten();
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    for (Color[] colors : c[0]) {
      for (Color color : colors) {
        assertEquals(GameColors.BLUE, color,
                     "flatten() is not returning the block colors in the "
                         + "correct order.");
      }
    }
  }

  @Test
  @Tag("score:1")
  @DisplayName("Secret PerimeterGoal score() test1")
  void secret_PGScore1() {
    Block.gen = new Random(901931);
    Block b = new Block(0, 10);
    b.updateSizeAndPosition(1024, 0, 0);

    PerimeterGoal p = new PerimeterGoal(GameColors.YELLOW);

    int[] actual = {-1};

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        actual[0] = p.score(b);
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertEquals(688, actual[0],
                 "PG score() is not returning the correct score.");
  }

  @Test
  @Tag("score:1")
  @DisplayName("Secret BlobGoal score() test1")
  void secret_BGScore1() {
    Block.gen = new Random(524133);
    Block b = new Block(0, 5);
    b.updateSizeAndPosition(1024, 0, 0);

    BlobGoal g = new BlobGoal(GameColors.RED);

    int[] score = {-1};

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        score[0] = g.score(b);
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertEquals(107, score[0],
                 "BG score() is not returning the correct score.");
  }

  @Test
  @Tag("score:2")
  @DisplayName("Secret BlobGoal score() test3")
  void secret_BGScore3() {
    Block.gen = new Random(22222);
    Block b = new Block(0, 6);
    b.updateSizeAndPosition(128, 10, 50);

    BlobGoal g1 = new BlobGoal(GameColors.YELLOW);
    BlobGoal g2 = new BlobGoal(GameColors.RED);

    int[] score = {-1};

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        score[0] = g1.score(b) + g2.score(b);
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertEquals(573, score[0],
                 "BG score() is not returning the correct score.");
  }
}

class HelperMethods {

  public static Object[] getChildren(Object b)
      throws NoSuchFieldException, IllegalAccessException {
    Field childrenField;

    childrenField = Block.class.getDeclaredField("children");

    childrenField.setAccessible(true);

    return (Block[])childrenField.get(b);
  }

  public static Color getColor(Object b)
      throws NoSuchFieldException, IllegalAccessException {
    Field colorField;

    colorField = Block.class.getDeclaredField("color");

    colorField.setAccessible(true);

    return (Color)colorField.get(b);
  }

  public static int getSize(Object b)
      throws NoSuchFieldException, IllegalAccessException {
    Field sizeField;

    sizeField = Block.class.getDeclaredField("size");

    sizeField.setAccessible(true);

    return (int)sizeField.get(b);
  }

  public static ArrayList<Integer> getCoords(Object b)
      throws NoSuchFieldException, IllegalAccessException {

    Field xCoordField, yCoordField;

    xCoordField = Block.class.getDeclaredField("xCoord");
    yCoordField = Block.class.getDeclaredField("yCoord");

    xCoordField.setAccessible(true);
    yCoordField.setAccessible(true);

    return new ArrayList<>(
        Arrays.asList((int)xCoordField.get(b), (int)yCoordField.get(b)));
  }

  public static int getLevel(Object b) { return ((Block)b).getLevel(); }

  public static int getMaxDepth(Object b) { return ((Block)b).getMaxDepth(); }

  public static boolean equals(Object b1, Object b2)
      throws NoSuchFieldException, IllegalAccessException {
    if (b1 == null || b2 == null) {
      return false;
    }

    if (getSize(b1) != getSize(b2)) {
      return false;
    }

    Color c1 = getColor(b1);
    Color c2 = getColor(b2);

    if (c1 == null && c2 == null) {
      // dont do anything
    } else if (c1 == null || c2 == null) {
      return false;
    } else if (!c1.equals(c2)) {
      return false;
    }

    ArrayList<Integer> coords1 = getCoords(b1);
    ArrayList<Integer> coords2 = getCoords(b2);

    if (!coords1.equals(coords2)) {
      return false;
    }

    if (getLevel(b1) != getLevel(b2)) {
      return false;
    }

    if (getMaxDepth(b1) != getMaxDepth(b2)) {
      return false;
    }

    Object[] children1 = getChildren(b1);
    Object[] children2 = getChildren(b2);

    if (children1 == null || children2 == null) {
      return false;
    } else {
      return children1.length == children2.length;
    }
  }

  public static ArrayList<Object> traverse(Object b1)
      throws NoSuchFieldException, IllegalAccessException {

    return traverseHelper((Block)b1);
  }

  public static ArrayList<Object> traverseHelper(Object b)
      throws NoSuchFieldException, IllegalAccessException {
    ArrayList<Object> blocks = new ArrayList<>();
    blocks.add(b);
    if (getChildren(b) != null) {
      for (Object child : getChildren(b)) {
        blocks.addAll(traverseHelper(child));
      }
    }
    return blocks;
  }

  @Test
  @Tag("score:4")
  @DisplayName("Secret undiscoveredBlobSize test2")
  public void secret_undiscoveredBlobSize2() {
    Block.gen = new Random(777888899);
    Block rb = new Block(0, 6);
    rb.updateSizeAndPosition(256, 0, 0);

    Color[][] unitCells = rb.flatten();

    boolean[][] visited = new boolean[unitCells.length][unitCells[0].length];

    Random r = new Random(1234567);
    for (int i = 0; i < 30; i++) {
      int x = r.nextInt(unitCells.length);
      int y = r.nextInt(unitCells[0].length);
      visited[x][y] = true;
    }

    BlobGoal g = new BlobGoal(GameColors.BLUE);

    int[] size = {-1};

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        size[0] = g.undiscoveredBlobSize(19, 20, unitCells, visited);
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertEquals(335, size[0],
                 "undiscoveredBlobSize() is not returning the correct size.");
  }
  @Test
  @Tag("score:2")
  @DisplayName("Secret undiscoveredBlobSize test3")
  public void secret_undiscoveredBlobSize3() {
    Block.gen = new Random(99998888);
    Block b = new Block(4, 9);
    b.updateSizeAndPosition(128, 10, 20);

    Color[][] unitCells = b.flatten();

    boolean[][] visited = new boolean[unitCells.length][unitCells[0].length];

    BlobGoal g = new BlobGoal(GameColors.RED);
    int[] size = {-1};

    Assertions.assertTimeoutPreemptively(Duration.ofMillis(750), () -> {
      try {
        size[0] = g.undiscoveredBlobSize(750, 1000, unitCells, visited);
      } catch (Exception e) {
        fail("Unexpected exception: " + e);
      }
    }, "Took too long / Infinite loop");

    assertEquals(0, size[0]);
  }
}
