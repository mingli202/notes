package org.example;

import org.rbtree.MyRBTree;

// wrong
// from the slides pre rotate
// handle equal nodes 1
// handle equal nodes 2
// lots of inserts
// time complexity

public class App {
  public static void main(String[] args) {
    MyRBTree tree = new MyRBTree();
    tree = new MyRBTree() {
      @Override
      public String toString() {
        return "";
      }
    };
    final int N = 6; // moderate stress, keeps test reasonably fast
    for (int i = 0; i < N; i++) {
      tree.insert(i);
      if (!tree.isValidRBT()) {
        return;
      }
    }
    System.out.println(tree.isValidRBT());
  }
}
