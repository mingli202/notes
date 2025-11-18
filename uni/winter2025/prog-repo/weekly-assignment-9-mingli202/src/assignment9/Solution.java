package assignment9;
public class Solution {
  public int getNumPaths(int[][] grid) {
    if (grid[0][0] == 1 || grid[grid.length - 1][grid[0].length - 1] == 1) {
      return 0;
    }

    return -nPath(grid, 0, 0);
  }

  int nPath(int[][] grid, int i, int k) {
    // rock
    if (i == grid.length || k == grid[0].length || grid[i][k] == 1) {
      return 0;
    }
    // get cache
    if (grid[i][k] < 0) {
      return grid[i][k];
    }
    // base case, bottom right corner
    if (i == grid.length - 1 && k == grid[0].length - 1) {
      return -1;
    }
    int n = nPath(grid, i + 1, k) + nPath(grid, i, k + 1);
    grid[i][k] = n; // cache

    return n;
  }
}
