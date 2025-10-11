package org.rbtree;

import java.util.ArrayDeque;
import java.util.Deque;

public class MyRBTree extends RBTree {
  public static final String ANSI_RESET = "\u001B[0m";
  public static final String ANSI_RED = "\u001B[31m";
  public static final String ANSI_GREEN = "\u001B[32m";
  public static final String ANSI_WHITE = "\u001B[37m";

  public MyRBTree() {
    super();
    this.nil = new Node(0, null, Color.BLACK);
    this.root = this.nil;
    this.root.parent = this.nil;
  }

  public void insert(int val) {
    if (this.root == this.nil) {
      this.root = this._newNode(val, this.nil, Color.BLACK);
      return;
    }

    Node node = this._addNode(val);

    System.out.println(this);
    while (node.parent.color == Color.RED) {
      Node uncle = this._getUncle(node);

      // case 1
      if (uncle.color == Color.RED) {
        node.parent.color = Color.BLACK;
        uncle.color = Color.BLACK;
        if (node.parent.parent != this.root) {
          node.parent.parent.color = Color.RED;
        }
        node = node.parent.parent;
      } else {
        // case 2 + 3
        if (node.parent.parent.left == node.parent) {
          if (node.parent.right == node) {
            node = this._leftRotate(node.parent);
            System.out.println(this);
          }

          node.parent.color = Color.BLACK;
          node.parent.parent.color = Color.RED;
          this._rightRotate(node.parent.parent);
        } else {
          if (node.parent.left == node) {
            node = this._rightRotate(node.parent);
            System.out.println(this);
          }

          node.parent.color = Color.BLACK;
          node.parent.parent.color = Color.RED;
          this._leftRotate(node.parent.parent);
        }
      }

      System.out.println(this);
    }
  }

  private Node _newNode(int val, Node parent, Color color) {
    Node node = new Node(val, parent, color);
    node.left = this.nil;
    node.right = this.nil;

    return node;
  }

  private Node _addNode(int val) {
    Node node = this.root;

    var newNode = this._newNode(val, null, Color.RED);

    while (true) {
      if (val < node.val) {
        if (node.left == this.nil) {
          node.left = newNode;
          newNode.parent = node;
          break;
        } else {
          node = node.left;
        }
      } else {
        if (node.right == this.nil) {
          node.right = newNode;
          newNode.parent = node;
          break;
        } else {
          node = node.right;
        }
      }
    }

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
    newRoot.right.parent = node;

    newRoot.right = node;
    node.parent = newRoot;

    if (parent == this.nil) {
      this.root = newRoot;
      newRoot.parent = this.nil;
    } else {
      if (parent.left == node) {
        parent.left = newRoot;
      } else {
        parent.right = newRoot;
      }
      newRoot.parent = parent;
    }

    return node;
  }

  private Node _leftRotate(Node node) {
    Node parent = node.parent;
    Node newRoot = node.right;

    node.right = newRoot.left;
    newRoot.left.parent = node;

    newRoot.left = node;
    node.parent = newRoot;

    if (parent == this.nil) {
      this.root = newRoot;
      newRoot.parent = this.nil;
    } else {

      if (parent.left == node) {
        parent.left = newRoot;
      } else {
        parent.right = newRoot;
      }
      newRoot.parent = parent;
    }

    return node;
  }

  public boolean isValidRBT() {
    if (this.root.color != Color.BLACK || this.nil.color != Color.BLACK) {
      return false;
    }

    BH bh = new BH(-1);

    try {
      this._blackHeight(this.root, 0, bh);
      return true;
    } catch (Exception e) {
      System.out.println(e.getMessage());
      return false;
    }
  }

  class BH {
    Integer bh;
    public BH(Integer bh) { this.bh = bh; }
  }

  private void _blackHeight(Node node, int currentBh, BH bh) throws Exception {
    if (node == this.nil) {
      if (bh.bh == -1) {
        bh.bh = currentBh;
      } else if (bh.bh != currentBh) {
        throw new Exception("Black height not equal");
      }
      return;
    }

    if (node.color == Color.RED && node.parent.color == Color.RED) {
      throw new Exception("Cannot be red like the parent");
    }

    if ((node.left != this.nil && node.left.val > node.val) ||
        (node.right != this.nil && node.right.val < node.val)) {
      throw new Exception("Invalid binary search tree");
    }
    if ((node.left != this.nil && node.left.parent != node) ||
        (node.right != this.nil && node.right.parent != node)) {
      throw new Exception("Parent links are wrong");
    }

    this._blackHeight(node.left,
                      currentBh + (node.color == Color.BLACK ? 1 : 0), bh);
    this._blackHeight(node.right,
                      currentBh + (node.color == Color.BLACK ? 1 : 0), bh);
  }

  private class NodeString {
    String string;
    int length;

    public NodeString(Node node) {
      String s = node == nil ? "nil" : String.valueOf(node.val);
      this.string =
          (node.color == Color.BLACK ? ANSI_GREEN : ANSI_RED) + s + ANSI_RESET;
      this.length = s.length();
    }

    public NodeString(String str, int length) {
      this.string = str;
      this.length = length;
    }
  }

  @Override
  public String toString() {
    return String.join(
        "\n",
        this.treeToStringArray(this.root).stream().map(s -> s.string).toList());
  }

  private Deque<NodeString> treeToStringArray(Node root) {
    var q = new ArrayDeque<NodeString>();

    if (root == this.nil) {
      q.addFirst(new NodeString(root));
      return q;
    }

    var leftTree = treeToStringArray(root.left);
    var rightTree = treeToStringArray(root.right);

    int leftLength = leftTree.element().length;
    int rightLength = rightTree.element().length;

    while (!leftTree.isEmpty() && !rightTree.isEmpty()) {
      var l = leftTree.pollFirst();
      var r = rightTree.pollFirst();

      String newString =
          this.padEnd(l.string, l.string.length() + 2) + r.string;
      q.addFirst(new NodeString(newString, l.length + 2 + r.length));
    }

    int len = q.getLast().length;

    while (!leftTree.isEmpty()) {
      var n = leftTree.pollFirst();
      q.addFirst(new NodeString(
          this.padEnd(n.string, len - n.length + n.string.length()), len));
    }

    while (!rightTree.isEmpty()) {
      var n = rightTree.pollFirst();
      q.addFirst(new NodeString(
          this.padStart(n.string, len - n.length + n.string.length()), len));
    }

    String leftArrowString = this._center("/", leftLength);
    String rightArrowString = this._center("\\", rightLength);

    String arrowStrings =
        this.padEnd(leftArrowString, leftArrowString.length() + 2) +
        rightArrowString;

    q.add(new NodeString(arrowStrings, arrowStrings.length()));

    NodeString rootString = new NodeString(root);
    rootString = new NodeString(this._center(rootString, len), len);
    q.add(rootString);

    return q.reversed();
  }

  private String _center(String str, int length) {
    str = this.padStart(str, (length - str.length()) / 2 + str.length());
    str = this.padEnd(str, length);

    return str;
  }

  private String _center(NodeString str, int length) {
    int nStart = (length - str.length) / 2;

    String s = padStart(str.string, nStart + str.string.length());
    s = padEnd(s, length - nStart - str.length + s.length());

    return s;
  }

  private String padStart(String s, int len) {
    return String.format("%" + len + "s", s);
  }

  private String padEnd(String s, int len) {
    return String.format("%-" + len + "s", s);
  }
}
