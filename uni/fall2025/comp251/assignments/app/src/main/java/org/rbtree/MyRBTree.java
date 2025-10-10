package org.rbtree;

public class MyRBTree extends RBTree {
  MyRBTree() {
    super();
    this.root = this.nil;
    this.nil.color = Color.BLACK;
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
    // TODO: Your implementation here
    return false;
  }
}
