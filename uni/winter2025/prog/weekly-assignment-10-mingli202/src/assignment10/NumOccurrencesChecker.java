package assignment10;

public class NumOccurrencesChecker {

  // returns True if the list contains exactly k occurrences of n. Assume the
  // list is sorted according to ascending order. Your program must run in
  // O(logn).
  public boolean numOccursKTimes(int[] list, int n, int k) {
    return (bisect(list, n, n + 0.5, true) - bisect(list, n, n - 0.5, false)) ==
        k;
  }

  private int bisect(int[] list, int original, double n, boolean isRight) {
    int left = 0;
    int right = list.length - 1;

    while (left < right) {
      int mid = (left + right) / 2;

      if (n < list[mid]) {
        right = mid - 1;
      } else if (n > list[mid]) {
        left = mid + 1;
      } else {
        left = mid;
        break;
      }
    }

    if (isRight && list[left] == original || list[left] < original) {
      left++;
    }

    return left;
  }
}
