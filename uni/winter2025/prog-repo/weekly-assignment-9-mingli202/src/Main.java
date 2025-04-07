import assignment9.Solution;
import java.util.Arrays;

public class Main {

  public static void main(String[] args) {
    testCases(new int[][] {{0, 0, 0}, {0, 1, 0}, {0, 0, 0}}, 1, 2);
    testCases(new int[][] {{0, 1, 0}, {0, 0, 0}, {0, 0, 0}}, 2, 3);
    testCases(new int[][] {{1}}, 3, 0);
    testCases(new int[][] {{0, 0}}, 4, 1);
    testCases(new int[][] {{1, 0}}, 5, 0);
    testCases(new int[][] {{0, 1, 0}, {0, 1, 0}, {0, 0, 0}}, 6, 1);
    testCases(
        new int[][] {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}, 6,
        20);

    testCases(
        new int[][] {{0, 0, 1, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 1, 0, 0}}, 7,
        0);

    testCases(
        new int[][] {{0, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 0, 0}}, 8,
        4);

    testCases(new int[][] {{0}}, 9, 1);
    testCases(new int[20][20], 10, 985525432);
  }

  public static void testCases(int[][] grid, int gridNum, int expectedResult) {
    System.out.println("\n\n************** GRID " + gridNum +
                       " **************");
    System.out.println(Arrays.deepToString(grid));
    System.out.println("************* RESULTS **************");
    System.out.println("Expected: " + expectedResult +
                       ", Actual: " + new Solution().getNumPaths(grid));
  }
}
