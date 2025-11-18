package assignment3;

import java.awt.Color;

public class BlobGoal extends Goal {

  public BlobGoal(Color c) { super(c); }

  @Override
  public int score(Block board) {
    /*
     * ADD YOUR CODE HERE
     */
    int score = 0;
    Color[][] map = board.flatten();
    boolean[][] visited = new boolean[map.length][map[0].length];

    for (int i = 0; i < map.length; i++) {
      for (int k = 0; k < map[0].length; k++) {
        int s = undiscoveredBlobSize(i, k, map, visited);
        if (s > score) {
          score = s;
        }
      }
    }

    return score;
  }

  @Override
  public String description() {
    return "Create the largest connected blob of " +
        GameColors.colorToString(targetGoal) +
        " blocks, anywhere within the block";
  }

  public int undiscoveredBlobSize(int i, int k, Color[][] unitCells,
                                  boolean[][] visited) {
    /*
     * ADD YOUR CODE HERE
     */
    if (i < 0 || i >= unitCells.length || k < 0 || k >= unitCells[0].length ||
        visited[i][k] || !unitCells[i][k].equals(targetGoal)) {
      return 0;
    }
    visited[i][k] = true;
    int size = 1;

    size += undiscoveredBlobSize(i + 1, k, unitCells, visited);
    size += undiscoveredBlobSize(i - 1, k, unitCells, visited);
    size += undiscoveredBlobSize(i, k + 1, unitCells, visited);
    size += undiscoveredBlobSize(i, k - 1, unitCells, visited);

    return size;
  }
}
