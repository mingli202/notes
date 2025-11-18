package data_structures;

import data_structures.interfaces.SQueue;

public class SCircularQueue<E> implements SQueue<E> {
  private E[] queue;
  private int size;
  private int headIndex;
  private int tailIndex;
  private static final int DEFAULT_CAPACITY = 1;

  public SCircularQueue(int initialCapacity) {
    if (initialCapacity < 0)
      throw new IllegalArgumentException();
    queue = (E[]) new Object[initialCapacity];
    size = 0;
    headIndex = 0;
    tailIndex = -1;
  }

  public SCircularQueue() { this(DEFAULT_CAPACITY); }

  @Override
  public void enqueue(E e) {
    if (size == queue.length)
      resize();
    tailIndex = (tailIndex + 1) % queue.length;
    queue[tailIndex] = e;
    size++;
  }

  private void resize() {
    // implement
    E[] arr = (E[]) new Object[this.queue.length + 3];
    for (int i = 0; i < this.size; i++) {
      arr[i] = this.queue[(i + this.headIndex) % this.queue.length];
    }

    this.headIndex = 0;
    this.tailIndex = this.size - 1;
    this.queue = arr;
  }

  @Override
  public E dequeue() {
    if (size < 1)
      throw new ArrayIndexOutOfBoundsException("Queue is empty!");
    // implement
    E el = this.queue[headIndex];
    this.queue[headIndex] = null;
    this.headIndex = (this.headIndex + 1) % this.queue.length;
    this.size--;

    return el;
  }

  @Override
  public E peek() {
    if (size < 1)
      throw new ArrayIndexOutOfBoundsException("Queue is empty!");
    return queue[headIndex];
  }

  public String toString() {
    String msg = "size = " + size + "\n";
    msg = msg + "head = " + headIndex + "\n";
    msg = msg + "tail = " + tailIndex + "\n";
    for (int i = 0; i < size; i++) {
      int index = (headIndex + i) % queue.length;
      msg = msg + queue[index] + ",";
    }

    return msg;
  }
}
