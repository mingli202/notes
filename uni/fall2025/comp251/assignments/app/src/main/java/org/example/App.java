package org.example;

import org.rbtree.MyRBTree;

public class App {
  public static void main(String[] args) {
    MyRBTree tree = new MyRBTree();
    tree.insert(10);
    tree.insert(4);
    tree.insert(5);
    tree.insert(2);
    tree.insert(5);
    tree.insert(3);
    // System.out.println(tree.toString());
  }
}
