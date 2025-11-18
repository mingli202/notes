package assignment10;
public class QuickSort {
  // sort list in-place
  public static void quicksort(int[] list, int low, int high) {
    if (list == null || list.length < 1)
      throw new IllegalArgumentException("invalid list");
    if (high - low + 1 <= 1 || low < 0 || high >= list.length)
      return;
    int sortedPivot = placeAndDivide(list, low, high);
    quicksort(list, low, sortedPivot - 1);
    quicksort(list, sortedPivot + 1, high);
  }

  // return index of sorted pivot. Note: low and high are inclusive
  static int placeAndDivide(int[] list, int low, int high) {
    int pivot = list[high];

    for (int i = low; i <= high; i++) {
      if (list[i] <= pivot) {
        swap(list, low, i);
        low++;
      }
    }

    return low - 1;
  }

  static void swap(int[] list, int i, int j) {
    int temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
}
