import static org.junit.jupiter.api.Assertions.*;

import assignment3.*;
import java.lang.reflect.Field;
import org.junit.jupiter.api.*;

public class TestCases {
  private Field xCoordField;
  private Field yCoordField;
  private Field sizeField;  // height/width of the square
  private Field levelField; // the root (outer most block) is at level 0
  private Field maxDepthField;
  private Field colorField;

  private Field childrenField; // {UR, UL, LL, LR}

  public static Block getMap(int size) { // TODO: remove this
    Block root = new Block(
        0, 0, size * 16 / 16, 0, 3, null,
        new Block[] {
            new Block(size * 8 / 16, 0, size * 8 / 16, 1, 3, GameColors.YELLOW,
                      new Block[0]),
            new Block(
                0, 0, size * 8 / 16, 1, 3, null,
                new Block[] {
                    new Block(size * 4 / 16, 0, size * 4 / 16, 2, 3,
                              GameColors.YELLOW, new Block[0]),
                    new Block(0, 0, size * 4 / 16, 2, 3, GameColors.BLUE,
                              new Block[0]),
                    new Block(0, size * 4 / 16, size * 4 / 16, 2, 3, null,
                              new Block[] {
                                  new Block(size * 2 / 16, size * 4 / 16,
                                            size * 2 / 16, 3, 3,
                                            GameColors.YELLOW, new Block[0]),
                                  new Block(0, size * 4 / 16, size * 2 / 16, 3,
                                            3, GameColors.BLUE, new Block[0]),
                                  new Block(0, size * 6 / 16, size * 2 / 16, 3,
                                            3, GameColors.RED, new Block[0]),
                                  new Block(size * 2 / 16, size * 6 / 16,
                                            size * 2 / 16, 3, 3,
                                            GameColors.GREEN, new Block[0]),
                              }),
                    new Block(size * 4 / 16, size * 4 / 16, size * 4 / 16, 2, 3,
                              GameColors.GREEN, new Block[0]),
                }),
            new Block(0, size * 8 / 16, size * 8 / 16, 1, 3, GameColors.RED,
                      new Block[0]),
            new Block(
                size * 8 / 16, size * 8 / 16, size * 8 / 16, 1, 3, null,
                new Block[] {
                    new Block(size * 12 / 16, size * 8 / 16, size * 4 / 16, 2,
                              3, null,
                              new Block[] {
                                  new Block(size * 14 / 16, size * 8 / 16,
                                            size * 2 / 16, 3, 3,
                                            GameColors.YELLOW, new Block[0]),
                                  new Block(size * 12 / 16, size * 8 / 16,
                                            size * 2 / 16, 3, 3,
                                            GameColors.BLUE, new Block[0]),
                                  new Block(size * 12 / 16, size * 10 / 16,
                                            size * 2 / 16, 3, 3, GameColors.RED,
                                            new Block[0]),
                                  new Block(size * 14 / 16, size * 10 / 16,
                                            size * 2 / 16, 3, 3,
                                            GameColors.GREEN, new Block[0]),
                              }),
                    new Block(size * 8 / 16, size * 8 / 16, size * 4 / 16, 2, 3,
                              GameColors.BLUE, new Block[0]),
                    new Block(size * 8 / 16, size * 12 / 16, size * 4 / 16, 2,
                              3, GameColors.RED, new Block[0]),
                    new Block(size * 12 / 16, size * 12 / 16, size * 4 / 16, 2,
                              3, GameColors.GREEN, new Block[0]),
                }),
        });

    return root;
  }

  @BeforeEach
  void setUp() throws NoSuchFieldException, IllegalAccessException {
    Block.gen.setSeed(2);

    xCoordField = Block.class.getDeclaredField("xCoord");
    yCoordField = Block.class.getDeclaredField("yCoord");
    sizeField = Block.class.getDeclaredField("size");
    levelField = Block.class.getDeclaredField("level");
    childrenField = Block.class.getDeclaredField("children");
  }

  @Test
  @Order(1)
  void blockConstructor() {
    Block.gen.setSeed(2);
    Block root = new Block(0, 2);

    String s = String.join("\n", "{ pos: (0, 0), size: 0, level: 0 }",
                           "\tG { pos: (0, 0), size: 0, level: 1 }",
                           "\tR { pos: (0, 0), size: 0, level: 1 }",
                           "\tY { pos: (0, 0), size: 0, level: 1 }",
                           "\t{ pos: (0, 0), size: 0, level: 1 }",
                           "\t\tB { pos: (0, 0), size: 0, level: 2 }",
                           "\t\tR { pos: (0, 0), size: 0, level: 2 }",
                           "\t\tY { pos: (0, 0), size: 0, level: 2 }",
                           "\t\tB { pos: (0, 0), size: 0, level: 2 }");

    assertEquals(s, root.toStringColor(true),
                 "instruction example, check your constructor");
  }

  @Test
  @Order(1)
  void blockConstructorNoDepth() {
    Block root = new Block(0, 0);
    assertEquals("{ pos: (0, 0), size: 0, level: 0 }",
                 root.toStringColor(false), "no depth");

    root = new Block(234, 0);
    assertEquals("{ pos: (0, 0), size: 0, level: 234 }",
                 root.toStringColor(false), "no depth, no change");

    root = new Block(-1, 0); // TODO: what if the level is negative
    assertEquals("{ pos: (0, 0), size: 0, level: -1 }",
                 root.toStringColor(false), "no depth, no change");
  }

  @Test
  void updateSizeAndPosition() {
    Block block = new Block(0, 2);
    assertThrows(IllegalArgumentException.class,
                 () -> { block.updateSizeAndPosition(13, 0, 0); });

    assertThrows(IllegalArgumentException.class,
                 () -> { block.updateSizeAndPosition(14, 0, 0); });

    assertAll("not throw", () -> {
      Block b = new Block(1, 2);
      b.updateSizeAndPosition(14, 0, 0);
    });
  }

  @Test
  void blockUpdateSizeAndPosition() {
    Block block = new Block(0, 2);
    block.updateSizeAndPosition(16, 0, 0);

    Block exp = new Block(
        0, 0, 16, 0, 2, null,
        new Block[] {
            new Block(8, 0, 8, 1, 2, GameColors.GREEN, new Block[0]),
            new Block(0, 0, 8, 1, 2, GameColors.RED, new Block[0]),
            new Block(0, 8, 8, 1, 2, GameColors.YELLOW, new Block[0]),
            new Block(
                8, 8, 8, 1, 2, null,
                new Block[] {
                    new Block(12, 8, 4, 2, 2, GameColors.BLUE, new Block[0]),
                    new Block(8, 8, 4, 2, 2, GameColors.RED, new Block[0]),
                    new Block(8, 12, 4, 2, 2, GameColors.YELLOW, new Block[0]),
                    new Block(12, 12, 4, 2, 2, GameColors.BLUE, new Block[0]),

                }),
        });

    assertEquals(exp, block);

    assertEquals("pos=(0,0), size=16, level=0\n"
                     + "\tGREEN, pos=(8,0), size=8, level=1\n"
                     + "\tRED, pos=(0,0), size=8, level=1\n"
                     + "\tYELLOW, pos=(0,8), size=8, level=1\n"
                     + "\tpos=(8,8), size=8, level=1\n"
                     + "\t\tBLUE, pos=(12,8), size=4, level=2\n"
                     + "\t\tRED, pos=(8,8), size=4, level=2\n"
                     + "\t\tYELLOW, pos=(8,12), size=4, level=2\n"
                     + "\t\tBLUE, pos=(12,12), size=4, level=2\n",
                 block.getBlockIndentedString(0));
  }

  @Test
  void blockGetSelectedBlock() {
    // 0 - 16
    Block root = getMap(16);

    assertNull(root.getSelectedBlock(-1, 10, 0));
    assertEquals(root, root.getSelectedBlock(10, 10, 0));
    assertEquals(new Block(8, 8, 4, 2, 3, GameColors.BLUE, new Block[0]),
                 root.getSelectedBlock(10, 10, 2));
    assertEquals(new Block(8, 8, 4, 2, 3, GameColors.BLUE, new Block[0]),
                 root.getSelectedBlock(10, 10, 3));

    assertEquals(new Block(12, 10, 2, 3, 3, GameColors.RED, new Block[0]),
                 root.getSelectedBlock(13, 11, 3));
    assertEquals(new Block(12, 8, 4, 2, 3, null, new Block[4]),
                 root.getSelectedBlock(13, 11, 2));
    assertEquals(new Block(8, 8, 8, 1, 3, null, new Block[4]),
                 root.getSelectedBlock(13, 11, 1));
    assertEquals(new Block(0, 0, 16, 0, 3, null, new Block[4]),
                 root.getSelectedBlock(13, 11, 0));
  }
}
