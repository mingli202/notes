package assignment3;

import java.awt.Color;
import java.util.ArrayList;
import java.util.Random;

public class Block {
  private int xCoord;
  private int yCoord;
  private int size;  // height/width of the square
  private int level; // the root (outer most block) is at level 0
  private int maxDepth;
  private Color color;

  private Block[] children; // {UR, UL, LL, LR}

  public static Random gen = new Random();

  /*
   * These two constructors are here for testing purposes.
   */
  public Block() {}

  public Block(int x, int y, int size, int lvl, int maxD, Color c,
               Block[] subBlocks) {
    this.xCoord = x;
    this.yCoord = y;
    this.size = size;
    this.level = lvl;
    this.maxDepth = maxD;
    this.color = c;
    this.children = subBlocks;
  }

  /*
   * Creates a random block given its level and a max depth.
   *
   * xCoord, yCoord, size, and highlighted should not be initialized
   * (i.e. they will all be initialized by default)
   */
  public Block(int lvl, int maxDepth) {
    this.level = lvl;
    this.maxDepth = maxDepth;
    this.children = new Block[] {};

    if (maxDepth > 0 && lvl < maxDepth &&
        gen.nextDouble() < Math.exp(-0.25 * lvl)) {
      this.children = new Block[] {
          new Block(lvl + 1, maxDepth),
          new Block(lvl + 1, maxDepth),
          new Block(lvl + 1, maxDepth),
          new Block(lvl + 1, maxDepth),
      };
    } else {
      this.color =
          GameColors.BLOCK_COLORS[gen.nextInt(GameColors.BLOCK_COLORS.length)];
    }
  }

  /*
   * Updates size and position for the block and all of its sub-blocks, while
   * ensuring consistency between the attributes and the relationship of the
   * blocks.
   *
   *  The size is the height and width of the block. (xCoord, yCoord) are the
   *  coordinates of the top left corner of the block.
   */
  public void updateSizeAndPosition(int size, int xCoord, int yCoord) {
    /*
     * ADD YOUR CODE HERE
     */
    if (size < 0 || size % (int)Math.pow(2, this.maxDepth - this.level) != 0) {
      throw new IllegalArgumentException("invalid size");
    }

    this.xCoord = xCoord;
    this.yCoord = yCoord;
    this.size = size;

    if (this.children.length > 0) {
      this.children[0].updateSizeAndPosition(
          size / 2, this.xCoord + this.size / 2, this.yCoord);
      this.children[1].updateSizeAndPosition(size / 2, this.xCoord,
                                             this.yCoord);
      this.children[2].updateSizeAndPosition(size / 2, this.xCoord,
                                             this.yCoord + this.size / 2);
      this.children[3].updateSizeAndPosition(
          size / 2, this.xCoord + this.size / 2, this.yCoord + this.size / 2);
    }
  }

  /*
   * Returns a List of blocks to be drawn to get a graphical representation of
   * this block.
   *
   * This includes, for each undivided Block:
   * - one BlockToDraw in the color of the block
   * - another one in the FRAME_COLOR and stroke thickness 3
   *
   * Note that a stroke thickness equal to 0 indicates that the block should be
   * filled with its color.
   *
   * The order in which the blocks to draw appear in the list does NOT matter.
   */
  public ArrayList<BlockToDraw> getBlocksToDraw() {
    /*
     * ADD YOUR CODE HERE
     */
    ArrayList<BlockToDraw> list = new ArrayList<BlockToDraw>();

    populateBlockToDrawList(list, this);

    return list;
  }

  static private void populateBlockToDrawList(ArrayList<BlockToDraw> list,
                                              Block block) {
    if (block.children.length == 0) {
      list.add(new BlockToDraw(block.color, block.xCoord, block.yCoord,
                               block.size, 0));
      list.add(new BlockToDraw(GameColors.FRAME_COLOR, block.xCoord,
                               block.yCoord, block.size, 3));
      return;
    }

    for (Block child : block.children) {
      populateBlockToDrawList(list, child);
    }
  }

  /*
   * This method is provided and you should NOT modify it.
   */
  public BlockToDraw getHighlightedFrame() {
    return new BlockToDraw(GameColors.HIGHLIGHT_COLOR, this.xCoord, this.yCoord,
                           this.size, 5);
  }

  /*
   * Return the Block within this Block that includes the given location
   * and is at the given level. If the level specified is lower than
   * the lowest block at the specified location, then return the block
   * at the location with the closest level value.
   *
   * The location is specified by its (x, y) coordinates. The lvl indicates
   * the level of the desired Block. Note that if a Block includes the location
   * (x, y), and that Block is subdivided, then one of its sub-Blocks will
   * contain the location (x, y) too. This is why we need lvl to identify
   * which Block should be returned.
   *
   * Input validation:
   * - this.level <= lvl <= maxDepth (if not throw exception)
   * - if (x,y) is not within this Block, return null.
   */
  public Block getSelectedBlock(int x, int y, int lvl) {
    /*
     * ADD YOUR CODE HERE
     */
    // lvl = Math.min(lvl, this.maxDepth);
    if (lvl < this.level || lvl > this.maxDepth) {
      throw new IllegalArgumentException("invalid level");
    }

    if (!(this.xCoord <= x && x < this.xCoord + this.size && this.yCoord <= y &&
          y < this.yCoord + this.size)) {
      return null;
    }

    if (this.level == lvl || this.children.length == 0) {
      return this;
    }

    for (Block child : this.children) {
      Block b = child.getSelectedBlock(x, y, lvl);
      if (b != null) {
        return b;
      }
    }

    return null;
  }

  /*
   * Swaps the child Blocks of this Block.
   * If input is 1, swap vertically. If 0, swap horizontally.
   * If this Block has no children, do nothing. The swap
   * should be propagate, effectively implementing a reflection
   * over the x-axis or over the y-axis.
   *
   */
  public void reflect(int direction) {
    /*
     * ADD YOUR CODE HERE
     */
    if (direction != 0 && direction != 1) {
      throw new IllegalArgumentException("invalid direction");
    }

    if (this.children.length == 0) {
      return;
    }

    if (direction == 0) { // x-axis
      Block tpm = this.children[3];
      this.children[3] = this.children[0];
      this.children[0] = tpm;
      tpm = this.children[1];
      this.children[1] = this.children[2];
      this.children[2] = tpm;
    } else { // y-axis
      Block tpm = this.children[1];
      this.children[1] = this.children[0];
      this.children[0] = tpm;
      tpm = this.children[2];
      this.children[2] = this.children[3];
      this.children[3] = tpm;
    }

    this.updateSizeAndPosition(this.size, this.xCoord, this.yCoord);

    for (Block child : this.children) {
      child.reflect(direction);
    }
  }

  /*
   * Rotate this Block and all its descendants.
   * If the input is 1, rotate clockwise. If 0, rotate
   * counterclockwise. If this Block has no children, do nothing.
   */
  public void rotate(int direction) {
    /*
     * ADD YOUR CODE HERE
     */
    if (direction != 0 && direction != 1) {
      throw new IllegalArgumentException("invalid direction");
    }

    if (this.children.length == 0) {
      return;
    }

    if (direction == 1) {
      Block tpm = this.children[0];
      this.children[0] = this.children[1];
      this.children[1] = this.children[2];
      this.children[2] = this.children[3];
      this.children[3] = tpm;
    } else {
      Block tpm = this.children[0];
      this.children[0] = this.children[3];
      this.children[3] = this.children[2];
      this.children[2] = this.children[1];
      this.children[1] = tpm;
    }

    this.updateSizeAndPosition(this.size, this.xCoord, this.yCoord);

    for (Block child : this.children) {
      child.rotate(direction);
    }
  }

  /*
   * Smash this Block.
   *
   * If this Block can be smashed,
   * randomly generate four new children Blocks for it.
   * (If it already had children Blocks, discard them.)
   * Ensure that the invariants of the Blocks remain satisfied.
   *
   * A Block can be smashed iff it is not the top-level Block
   * and it is not already at the level of the maximum depth.
   *
   * Return True if this Block was smashed and False otherwise.
   *
   */
  public boolean smash() {
    /*
     * ADD YOUR CODE HERE
     */
    if (this.level == 0 || this.level >= this.maxDepth) {
      return false;
    }

    this.children = new Block[] {
        new Block(this.level + 1, this.maxDepth),
        new Block(this.level + 1, this.maxDepth),
        new Block(this.level + 1, this.maxDepth),
        new Block(this.level + 1, this.maxDepth),
    };

    this.updateSizeAndPosition(this.size, this.xCoord, this.yCoord);

    return true;
  }

  /*
   * Return a two-dimensional array representing this Block as rows and columns
   * of unit cells.
   *
   * Return and array arr where, arr[i] represents the unit cells in row i,
   * arr[i][j] is the color of unit cell in row i and column j.
   *
   * arr[0][0] is the color of the unit cell in the upper left corner of this
   * Block.
   */
  public Color[][] flatten() {
    /*
     * ADD YOUR CODE HERE
     */
    int size = (int)Math.pow(2, this.maxDepth);
    int scale = this.size / size;
    Color[][] map = new Color[size][size];

    for (int i = 0; i < size; i++) {
      for (int k = 0; k < size; k++) {
        map[i][k] =
            this.getSelectedBlock(this.xCoord + k * scale,
                                  this.yCoord + i * scale, this.maxDepth)
                .color;
      }
    }

    return map;
  }

  // These two get methods have been provided. Do NOT modify them.
  public int getMaxDepth() { return this.maxDepth; }

  public int getLevel() { return this.level; }

  /*
   * The next 5 methods are needed to get a text representation of a block.
   * You can use them for debugging. You can modify these methods if you wish.
   */
  public String toString() {
    return String.format("pos=(%d,%d), size=%d, level=%d", this.xCoord,
                         this.yCoord, this.size, this.level);
  }

  public String toStringColor(boolean includeColor) {
    String indent = "";
    for (int i = 0; i < this.level + 1; i++) {
      indent += "\t";
    }

    String s = "{ "
               + "pos: (" + this.xCoord + ", " + this.yCoord + ")"
               + ", size: " + this.size + ", level: " + this.level + " }";

    if (this.children.length == 0) {
      if (includeColor) {
        char color = GameColors.colorToString(this.color).charAt(0);
        s = color + " " + s;
      }
    } else {
      for (Block b : this.children) {
        s += "\n" + indent + b.toStringColor(includeColor);
      }
    }

    return s;
  }

  public void printBlock() {
    System.out.println(this.getBlockIndentedString(0));
  }

  public String getBlockIndentedString(int indentation) {
    String indent = "";
    for (int i = 0; i < indentation; i++) {
      indent += "\t";
    }

    if (this.children.length == 0) {
      // it's a leaf. Print the color!
      String colorInfo = GameColors.colorToString(this.color) + ", ";
      return indent + colorInfo + this + "\n";
    } else {
      String s = indent + this + "\n";
      for (Block b : this.children)
        s += b.getBlockIndentedString(indentation + 1);
      return s;
    }
  }

  private static void coloredPrint(String message, Color color) {
    System.out.print(GameColors.colorToANSIColor(color));
    System.out.print(message);
    System.out.print(GameColors.colorToANSIColor(Color.WHITE));
  }

  public void printColoredBlock() {
    Color[][] colorArray = this.flatten();
    for (Color[] colors : colorArray) {
      for (Color value : colors) {
        String colorName = GameColors.colorToString(value).toUpperCase();
        if (colorName.length() == 0) {
          colorName = "\u2588";
        } else {
          colorName = colorName.substring(0, 1);
        }
        coloredPrint(colorName, value);
      }
      System.out.println();
    }
  }
}
