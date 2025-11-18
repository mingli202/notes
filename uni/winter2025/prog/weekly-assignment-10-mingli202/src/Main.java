import assignment10.NumOccurrencesChecker;
import assignment10.QuickSort;
import java.util.Arrays;

public class Main {

  public static void main(String[] args) throws Exception {
    int[] list = new int[] {3, 5, 7, 2, 8, 10, 1, 4};
    System.out.println();
    System.out.println("\n\n**************** BEFORE SORTING ****************");
    System.out.println(Arrays.toString(list));
    System.out.println("**************** AFTER SORTING ****************");
    QuickSort.quicksort(list, 0, list.length - 1);
    System.out.println(Arrays.toString(list));
    System.out.println("***************************************");

    list = new int[] {6, -4, 3, -2, 7, 8, -9, 1, -5, 0};
    System.out.println();
    System.out.println("\n\n**************** BEFORE SORTING ****************");
    System.out.println(Arrays.toString(list));
    System.out.println("**************** AFTER SORTING ****************");
    QuickSort.quicksort(list, 0, list.length - 1);
    System.out.println(Arrays.toString(list));
    System.out.println("***************************************");

    list = new int[] {-6, -7, -5, -3, -8, -9, -1, -2, -0};
    System.out.println();
    System.out.println("\n\n**************** BEFORE SORTING ****************");
    System.out.println(Arrays.toString(list));
    System.out.println("**************** AFTER SORTING ****************");
    QuickSort.quicksort(list, 0, list.length - 1);
    System.out.println(Arrays.toString(list));
    System.out.println("***************************************");

    list = new int[] {4, 4, 4, 5, 6, 7, 3, 1, 0, 2, 34, 6, 7, 8};
    System.out.println();
    System.out.println("\n\n**************** BEFORE SORTING ****************");
    System.out.println(Arrays.toString(list));
    System.out.println("**************** AFTER SORTING ****************");
    QuickSort.quicksort(list, 0, list.length - 1);
    System.out.println(Arrays.toString(list));
    System.out.println("***************************************");

    list = new int[] {1};
    System.out.println();
    System.out.println("\n\n**************** BEFORE SORTING ****************");
    System.out.println(Arrays.toString(list));
    System.out.println("**************** AFTER SORTING ****************");
    QuickSort.quicksort(list, 0, list.length - 1);
    System.out.println(Arrays.toString(list));
    System.out.println("***************************************");

    testNumOccurKTimes(new int[] {2, 3, 5, 5, 5, 5, 5, 7, 8}, 5, 5, true);
    testNumOccurKTimes(new int[] {2, 4, 5, 5, 5, 5, 5, 6, 6}, 5, 5, true);
    testNumOccurKTimes(new int[] {2, 4, 5, 5, 5, 5, 5, 6, 6}, 5, 4, false);
    testNumOccurKTimes(new int[] {2, 4, 5, 5, 5, 5, 5, 6, 6}, 5, 6, false);
    testNumOccurKTimes(new int[] {1}, 1, 1, true);
    testNumOccurKTimes(new int[] {1}, 1, 2, false);
    testNumOccurKTimes(new int[] {1}, 2, 1, false);
    testNumOccurKTimes(new int[] {1, 1}, 1, 2, true);
    testNumOccurKTimes(new int[] {2, 2, 5}, 2, 2, true);
    testNumOccurKTimes(new int[] {1, 2, 2, 5}, 2, 2, true);
    testNumOccurKTimes(new int[] {1, 1, 2, 2, 5}, 2, 2, true);
    testNumOccurKTimes(new int[] {1, 1, 2, 2, 3, 5}, 2, 2, true);
    testNumOccurKTimes(new int[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 5},
                       2, 2, true);
    testNumOccurKTimes(new int[] {1, 1, 1, 3, 3, 5}, 3, 2, true);
    testNumOccurKTimes(new int[] {1, 1, 1, 3, 3, 5, 5, 5, 5, 5, 5, 5, 5, 5}, 3,
                       2, true);
  }

  static void testNumOccurKTimes(int[] list, int n, int k,
                                 boolean expectedOutput) {
    NumOccurrencesChecker checker = new NumOccurrencesChecker();

    System.out.println(
        "\n\n**************** testNumOccurKTimes ****************");
    System.out.println(Arrays.toString(list));
    System.out.println("***************************************");
    System.out.println("n: " + String.valueOf(n) + ", k: " + String.valueOf(k));
    System.out.println("Expected output: " + expectedOutput);
    System.out.println("Actual output: " + checker.numOccursKTimes(list, n, k));
    System.out.println("***************************************");
  }
}
