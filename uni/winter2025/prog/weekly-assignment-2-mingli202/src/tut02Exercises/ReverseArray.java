// the line below defines the package (i.e. folder) where the file lives.
package tut02Exercises;

public class ReverseArray {

  public static void swap(int[] a, int j, int k) {
    int tmp = a[j];
    a[j] = a[k];
    a[k] = tmp;
  }

  public static void reverseArray(int[] a) {
    if (a == null) {
      return;
    }

    int left = 0;
    int right = a.length - 1;

    while (left < right)
      swap(a, left++, right--);
  }
}
