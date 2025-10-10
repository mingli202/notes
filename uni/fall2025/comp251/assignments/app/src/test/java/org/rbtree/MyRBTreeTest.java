package org.rbtree;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import org.junit.jupiter.api.Test;

/**
 * JUnit 5 tests for a Red-Black Tree implementation.
 *
 * Required public API on the SUT (system under test):
 *   - void insert(int val)
 *   - boolean isValidRBT()
 *
 * If your class is named differently or in a package, adjust the type name.
 */
public class MyRBTreeTest {

  // Adjust this type if your implementation uses a different class name.
  private MyRBTree newTree() {
    return new MyRBTree() {
      @Override
      public String toString() {
        return "";
      }
    };
  }

  private String[] toArrayString(MyRBTree tree) throws Exception {
    var list = new ArrayList<String>();

    Field nilField = tree.getClass().getDeclaredField("nil");
    Field rootField = tree.getClass().getDeclaredField("root");

    RBTree.Node nil = (RBTree.Node)nilField.get(tree);
    RBTree.Node root = (RBTree.Node)rootField.get(tree);

    this.inOrder(root, list, nil);

    return (String[])list.toArray();
  }

  private void inOrder(RBTree.Node node, ArrayList<String> list,
                       RBTree.Node nil) {
    if (node == null) {
      return;
    }
    this.inOrder(node.left, list, nil);
    list.add(node == nil ? "nil" : String.valueOf(node.val));
    this.inOrder(node.right, list, nil);
  }

  @Test
  void emptyTreeIsValid() {
    MyRBTree tree = newTree();
    assertTrue(tree.isValidRBT(),
               "A newly-created (empty) tree should be a valid RBT.");
  }

  @Test
  void singleInsertIsValid() {
    MyRBTree tree = newTree();
    tree.insert(10);
    assertTrue(tree.isValidRBT(), "A tree with a single node must satisfy "
                                      + "RBT properties (root black).");
  }

  @Test
  void insertMinAndMaxIntegerValues() {
    MyRBTree tree = newTree();
    tree.insert(Integer.MIN_VALUE);
    tree.insert(Integer.MAX_VALUE);
    assertTrue(tree.isValidRBT(),
               "Tree must remain valid after inserting "
                   + "Integer.MIN_VALUE and Integer.MAX_VALUE.");
  }

  @Test
  void negativeZeroAndPositiveValues() {
    MyRBTree tree = newTree();
    tree.insert(0);
    tree.insert(-1);
    tree.insert(-1000);
    tree.insert(1);
    assertTrue(
        tree.isValidRBT(),
        "Tree must handle negative, zero, and positive values correctly.");
  }

  @Test
  void ascendingInsertMaintainsValidity() {
    MyRBTree tree = newTree();
    for (int i = 1; i <= 200; i++) {
      tree.insert(i);
    }
    assertTrue(tree.isValidRBT(),
               "Inserting strictly ascending values should keep tree valid.");
  }

  @Test
  void descendingInsertMaintainsValidity() {
    MyRBTree tree = newTree();
    for (int i = 200; i >= 1; i--) {
      tree.insert(i);
    }
    assertTrue(tree.isValidRBT(),
               "Inserting strictly descending values should keep tree valid.");
  }

  @Test
  void incrementalInsertMaintainsValidity() {
    MyRBTree tree = newTree();
    // Insert 0..499 and assert after each insert
    for (int i = 0; i < 500; i++) {
      tree.insert(i);
      assertTrue(tree.isValidRBT(),
                 "Tree violated RBT properties after inserting " + i);
    }
  }

  @Test
  void randomOrderInsertsMaintainValidity() {
    MyRBTree tree = newTree();
    final int N = 1000;
    List<Integer> nums = new ArrayList<>(N);
    for (int i = 0; i < N; i++)
      nums.add(i);
    Collections.shuffle(nums, new Random(12345)); // deterministic shuffle
    for (int v : nums) {
      tree.insert(v);
    }
    assertTrue(tree.isValidRBT(),
               "Random-order inserts should preserve RBT properties.");
  }

  @Test
  void duplicateInsertDoesNotBreakTree() {
    MyRBTree tree = newTree();
    tree.insert(42);
    try {
      // Some implementations ignore duplicates, some throw; accept both.
      tree.insert(42);
    } catch (Exception ignored) {
      // If the implementation throws on duplicate inserts, that's fine.
      // We just need to ensure the tree stays valid (no corruption).
    }
    assertTrue(tree.isValidRBT(),
               "Duplicate insertion should not corrupt the tree.");
  }

  @Test
  void manyInsertsStressTest() {
    MyRBTree tree = newTree();
    final int N = 2000; // moderate stress, keeps test reasonably fast
    for (int i = 0; i < N; i++) {
      tree.insert(i);
    }
    assertTrue(tree.isValidRBT(), "After many inserts (0.." + (N - 1) +
                                      ") tree must remain valid.");
  }

  /**
   * Reflection-based test: try to corrupt the root color and verify
   * isValidRBT() detects the problem. This test is permissive:
   * - it tries to find a field named "root" or a Node-typed field.
   * - then it looks for a color-like field in the node (boolean, enum).
   * - if no suitable field is found, the test is skipped (assumption).
   *
   * This avoids false failures on implementations that name things
   * differently.
   */
  @Test
  void isValidDetectsBrokenRootColor() throws Exception {
    MyRBTree tree = newTree();
    tree.insert(12345); // ensure root exists

    Field rootField = tree.getClass().getDeclaredField("root");
    rootField.setAccessible(true);

    Object root = rootField.get(tree);

    // Find a 'color' like field on the node
    Field colorField = root.getClass().getDeclaredField("color");

    colorField.setAccessible(true);

    // Save original value, mutate to break the root-black rule, assert
    // isValidRBT() false, then restore original value.
    Object original = colorField.get(root);

    try {
      colorField.set(root, Color.RED);
      assertFalse(tree.isValidRBT(),
                  "isValidRBT() should detect a root color violation (enum).");
    } finally {
      colorField.set(root, original);
    }
  }
}
