package org.rbtree;

import java.util.HashMap;
import java.util.Map;

public class MyRBTree extends RBTree {
  MyRBTree() {
    super();
    this.root = this.nil;
    this.nil.color = Color.BLACK;
    this.nil.parent = this.nil;
  }

  public void insert(int val) {
    if (this.root == this.nil) {
      this.root = new Node(val, this.nil, Color.BLACK);
      return;
    }

    Node node = this._addNode(val);

    while (node.parent.color == Color.RED) {
      Node uncle = this._getUncle(node);

      // case 1
      if (uncle.color == Color.RED) {
        node.parent.color = Color.BLACK;
        uncle.color = Color.BLACK;
        node = node.parent.parent;
      } else {
        // case 2 + 3
        if (node.parent.right == node) {
          if (node.parent.parent.left == node.parent) {
            node = this._rightRotate(node.parent);
          } else {
            node.parent.color = Color.BLACK;
            node.parent.parent.color = Color.RED;
            this._leftRotate(node.parent.parent);
          }
        } else {
          if (node.parent.parent.right == node.parent) {
            node = this._leftRotate(node.parent);
          } else {
            node.parent.color = Color.BLACK;
            node.parent.parent.color = Color.RED;
            this._rightRotate(node.parent.parent);
          }
        }
      }
    }
  }

  private Node _addNode(int val) {
    Node node = this.root;

    var newNode = new Node(val, node.left, Color.RED);
    while (true) {
      if (val < node.val) {
        if (node.left == this.nil) {
          node.left = newNode;
          break;
        } else {
          node = node.left;
        }
      } else {
        if (node.right == this.nil) {
          node.right = newNode;
          break;
        } else {
          node = node.right;
        }
      }
    }

    newNode.left = this.nil;
    newNode.right = this.nil;

    return newNode;
  }

  private Node _getUncle(Node node) {
    Node parent = node.parent;

    if (parent == this.nil) {
      return this.nil;
    }

    Node grandparent = parent.parent;

    if (grandparent == this.nil) {
      return this.nil;
    }

    Node uncle =
        grandparent.left == parent ? grandparent.right : grandparent.left;

    return uncle;
  }

  private Node _rightRotate(Node node) {
    Node parent = node.parent;
    Node newRoot = node.left;

    node.left = newRoot.right;
    newRoot.right = node;

    if (parent.left == node) {
      parent.left = newRoot;
    } else {
      parent.right = newRoot;
    }

    return node;
  }

  private Node _leftRotate(Node node) {
    Node parent = node.parent;
    Node newRoot = node.right;

    node.right = newRoot.left;
    newRoot.left = node;

    if (parent.left == node) {
      parent.left = newRoot;
    } else {
      parent.right = newRoot;
    }

    return node;
  }

  public boolean isValidRBT() {
    if (this.root.color != Color.BLACK) {
      return false;
    }

    Map<Integer, Integer> blackheights = new HashMap<Integer, Integer>();

    try {
      this._blackHeight(this.root, 0, blackheights);
      return true;
    } catch (Error e) {
      return false;
    }
  }

  private int _blackHeight(Node node, int depth,
                           Map<Integer, Integer> blackheights) {
    if (node == this.nil) {
      return 1;
    }

    if (node.color == Color.RED && node.parent.color == Color.RED) {
      throw new Error("Cannot be red like the parent");
    }

    if (node.left.val > node.val || node.right.val < node.val) {
      throw new Error("Invalid binary search tree");
    }

    // check black heights
    int blackHeight = this._blackHeight(node.left, depth + 1, blackheights) +
                      this._blackHeight(node.right, depth + 1, blackheights);

    if (!blackheights.containsKey(depth)) {
      blackheights.put(depth, blackHeight);
    } else {
      int otherBlackHeight = blackheights.get(depth);

      if (otherBlackHeight != blackHeight) {
        throw new Error("Not equal black height");
      }
    }

    return blackHeight + (node.color == Color.BLACK ? 1 : 0);
  }
}
