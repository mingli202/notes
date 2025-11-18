package data_structures;

import data_structures.interfaces.SList;

public class SDoublyLinkedList<E> implements SList<E> {

  private class SDLLNode {
    private E data;
    private SDLLNode next;
    private SDLLNode prev;

    SDLLNode(E data, SDLLNode next, SDLLNode prev) {
      this.data = data;
      this.next = next;
      this.prev = prev;
    }
  }

  private SDLLNode head;
  private SDLLNode tail;
  private int size;

  public SDoublyLinkedList() {
    this.head = null;
    this.tail = null;
    this.size = 0;
  }

  @Override
  public void add(E e) {
    SDLLNode node = new SDLLNode(e, null, tail);
    if (null == head) {
      head = node;
      tail = node;
    } else {
      tail.next = node;
      node.prev = tail;
      tail = node;
    }
    size++;
  }

  @Override
  public void add(int index, E e) {
    if (index > size)
      throw new IndexOutOfBoundsException("Index: " + index +
                                          ", Size: " + size);
    // implement
    SDLLNode node = new SDLLNode(e, null, null);

    if (this.size == 0) {
      this.head = node;
      this.tail = node;
      this.size++;
      return;
    }

    SDLLNode it = this.head;
    SDLLNode prev = null;

    for (int i = 0; i < index; i++) {
      prev = it;
      it = it.next;
    }

    if (prev != null) {
      prev.next = node;
      node.prev = prev;
    }

    if (it != null) {
      node.next = it;
      it.prev = node;
    }

    if (index == 0) {
      this.head = node;
    }

    this.size++;
  }

  @Override
  public E get(int index) {
    if (index >= size)
      throw new IndexOutOfBoundsException("Index: " + index +
                                          ", Size: " + size);
    SDLLNode node = getNode(index);
    return node.data;
  }

  @Override
  public E remove(int index) {
    if (index >= size)
      throw new IndexOutOfBoundsException("Index: " + index +
                                          ", Size: " + size);
    SDLLNode ret;
    if (index == 0) {
      ret = head;
      head = head.next;
      if (null != head)
        head.prev = null;
      if (ret == tail)
        tail = null;
    } else if (index == size - 1) {
      ret = tail;
      ret.prev.next = ret.next;
      tail = ret.prev;
    } else {
      ret = getNode(index);
      ret.prev.next = ret.next;
      ret.next.prev = ret.prev;
    }
    size--;
    return ret.data;
  }

  @Override
  public int size() {
    return size;
  }

  private SDLLNode getNode(int index) {
    if (index >= size)
      throw new IndexOutOfBoundsException("Index: " + index +
                                          ", Size: " + size);
    // return the i-th node from head
    SDLLNode node;
    boolean traverseFromBack = (size - index) < index;
    if (traverseFromBack) {
      node = tail;
      for (int i = 0; i < size - index - 1; i++) {
        node = node.prev;
      }
    } else { // traverse from front
      node = head;
      for (int i = 0; i < index; i++) {
        node = node.next;
      }
    }
    return node;
  }

  public String toString() {
    String msg = "size = " + size + "\n";
    SDLLNode ptr = head;
    for (int i = 0; i < size; i++) {
      msg = msg + ptr.data + ",";
      ptr = ptr.next;
    }
    return msg;
  }
}
