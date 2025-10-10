package org.example;

import org.rbtree.MyRBTree;

public class App {

  public static void main(String[] args) {
    MyRBTree tree = new MyRBTree();
    tree.insert(1);
    System.out.println(tree.toString());
  }
}
