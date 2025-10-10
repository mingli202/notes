package org.example;

import org.rbtree.MyRBTree;

public class App {
  public static void main(String[] args) {
    MyRBTree tree = new MyRBTree();
    MyRBTree treeNoPrint = new MyRBTree() {
      @Override
      public String toString() {
        return "";
      }
    };
    final int N = 2000; // moderate stress, keeps test reasonably fast
    for (int i = 0; i < N; i++) {
      treeNoPrint.insert(i);
    }
    System.out.println(tree.isValidRBT());
  }
}
