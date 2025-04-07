package assignment3;

import java.awt.Color;

public class PerimeterGoal extends Goal {

  public PerimeterGoal(Color c) { super(c); }

  @Override
  public int score(Block board) {
    /*
     * ADD YOUR CODE HERE
     */
    Color[][] map = board.flatten();
    int score = 0;

    for (int i = 0; i < map.length; i++) {
      if (map[0].length > 0) {
        score += map[i][0].equals(this.targetGoal) ? 1 : 0;
        score += map[i][map[0].length - 1].equals(this.targetGoal) ? 1 : 0;
      }
    }

    if (map.length > 0) {
      for (int k = 0; k < map[0].length; k++) {
        score += map[0][k].equals(this.targetGoal) ? 1 : 0;
        score += map[map.length - 1][k].equals(this.targetGoal) ? 1 : 0;
      }
    }

    return score;
  }

  @Override
  public String description() {
    return "Place the highest number of " +
        GameColors.colorToString(targetGoal) +
        (" unit cells along the outer perimeter of the board. Corner cell "
         + "count twice toward the final score!");
  }
}
