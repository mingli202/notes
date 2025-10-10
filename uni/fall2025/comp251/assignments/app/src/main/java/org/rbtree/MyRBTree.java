package org.rbtree;

import com.google.common.base.Strings;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Queue;

public class MyRBTree extends RBTree {
  public static final String ANSI_RESET = "\u001B[0m";
  public static final String ANSI_RED = "\u001B[31m";
  public static final String ANSI_GREEN = "\u001B[32m";
  public static final String ANSI_WHITE = "\u001B[37m";

  public MyRBTree() {
    super();
    this.nil = new Node(0, null, Color.BLACK);
    this.root = this.nil;
  }

  public void insert(int val) {
    if (this.root == this.nil) {
      this.root = this._newNode(val, this.nil, Color.BLACK);
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

  private Node _newNode(int val, Node parent, Color color) {
    Node node = new Node(val, parent, color);
    node.left = this.nil;
    node.right = this.nil;

    return node;
  }

  private Node _addNode(int val) {
    Node node = this.root;

    var newNode = this._newNode(val, node.left, Color.RED);

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
    } catch (Exception e) {
      return false;
    }
  }

  private int _blackHeight(Node node, int depth,
                           Map<Integer, Integer> blackheights)
      throws Exception {
    if (node == this.nil) {
      return 1;
    }

    if (node.color == Color.RED && node.parent.color == Color.RED) {
      throw new Exception("Cannot be red like the parent");
    }

    if (node.left.val > node.val || node.right.val < node.val) {
      throw new Exception("Invalid binary search tree");
    }

    // check black heights
    int blackHeight = this._blackHeight(node.left, depth + 1, blackheights) +
                      this._blackHeight(node.right, depth + 1, blackheights);

    if (!blackheights.containsKey(depth)) {
      blackheights.put(depth, blackHeight);
    } else {
      int otherBlackHeight = blackheights.get(depth);

      if (otherBlackHeight != blackHeight) {
        throw new Exception("Not equal black height");
      }
    }

    return blackHeight + (node.color == Color.BLACK ? 1 : 0);
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
          Strings.padEnd(l.string, l.string.length() + 2, ' ') + r.string;
      q.addFirst(new NodeString(newString, l.length + 2 + r.length));
    }

    int len = q.getLast().length;

    while (!leftTree.isEmpty()) {
      var n = leftTree.pollFirst();
      q.addFirst(new NodeString(
          Strings.padEnd(n.string, len - n.length + n.string.length(), ' '),
          len));
    }

    while (!rightTree.isEmpty()) {
      var n = rightTree.pollFirst();
      q.addFirst(new NodeString(
          Strings.padStart(n.string, len - n.length + n.string.length(), ' '),
          len));
    }

    String leftArrowString = this._center("/", leftLength);
    String rightArrowString = this._center("\\", rightLength);

    String arrowStrings =
        Strings.padEnd(leftArrowString, leftArrowString.length() + 2, ' ') +
        rightArrowString;

    q.add(new NodeString(arrowStrings, arrowStrings.length()));

    NodeString rootString = new NodeString(root);
    rootString = new NodeString(this._center(rootString, len), len);
    q.add(rootString);

    return q.reversed();
  }

  private String _center(String str, int length) {
    str =
        Strings.padStart(str, (length - str.length()) / 2 + str.length(), ' ');
    str = Strings.padEnd(str, length, ' ');

    return str;
  }

  private String _center(NodeString str, int length) {
    int nStart = (length - str.length) / 2;

    String s = Strings.padStart(str.string, nStart + str.string.length(), ' ');
    s = Strings.padEnd(s, length - nStart - str.length + s.length(), ' ');

    return s;
  }
}
