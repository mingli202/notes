package data_structures;

import data_structures.interfaces.SList;
import data_structures.interfaces.SStack;

public class SListStack<E> implements SStack<E> {
  private SList<E> stack;

  public SListStack(SList<E> list) { stack = list; }

  public void push(E e) {
    // implement one-liner
    stack.add(e);
  }

  public E peek() {
    // implement one-liner
    return stack.get(stack.size() - 1);
  }

  public E pop() {
    //  implement one-liner
    return stack.remove(stack.size() - 1);
  }

  public String toString() { return stack.toString(); }
}
