package wassignment12;

import java.util.ArrayList;

public class Heap<T extends Comparable<T>> {
  public ArrayList<T> heap;

  private int parent(int i) { return (i - 1) / 2; }
  private int left(int i) { return i * 2 + 1; }
  private int right(int i) { return i * 2 + 2; }

  public Heap() { heap = new ArrayList<>(); }

  public void add(T e) {
    this.heap.add(e);
    int i = this.heap.size() - 1;
    int parent = parent(i);

    while (i > 0 && this.heap.get(parent).compareTo(this.heap.get(i)) > 0) {
      swap(parent, i);
      i = parent;
      parent = parent(i);
    }
  }

  private void heapify(int i) {
    int left = left(i);
    int right = right(i);
    int toSwap = i;

    if (left < this.heap.size() &&
        this.heap.get(i).compareTo(this.heap.get(left)) > 0) {
      toSwap = left;
    }
    if (right < this.heap.size() &&
        this.heap.get(toSwap).compareTo(this.heap.get(right)) > 0) {
      toSwap = right;
    }
    if (toSwap != i) {
      swap(toSwap, i);
      this.heapify(toSwap);
    }
  }

  public T removeMin() {
    if (this.heap.size() == 0) {
      return null;
    }

    T last = this.heap.removeLast();
    T min = this.heap.get(0);
    this.heap.set(0, last);

    this.heapify(0);

    return min;
  }

  public void swap(int i, int j) {
    T temp = heap.get(i);
    heap.set(i, heap.get(j));
    heap.set(j, temp);
  }
}
