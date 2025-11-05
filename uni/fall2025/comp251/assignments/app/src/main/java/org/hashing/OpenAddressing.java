
package org.hashing;

import java.util.Arrays;

public class OpenAddressing extends SimpleHashSet {
  public int[] Table;

  protected OpenAddressing(int w, int seed, int A) {
    super(w, seed, A);
    this.Table = new int[m];
    for (int i = 0; i < m; i++) {
      Table[i] = -1;
    }
  }

  /**Implements the probe function p(k, i)*/
  public int probe(int key, int i) {
    // TODO
    throw new NotImplementedException("OpenAddressing::probe");
  }

  /**
   * Inserts key k into hash set. Returns the number of collisions encountered
   */
  @Override
  public int insert(int key) {
    // TODO
    throw new NotImplementedException("OpenAddressing::insert");
  }

  /**
   * Removes key k from hash table. Returns the number of collisions
   * encountered
   */
  @Override
  public int remove(int key) {
    // TODO
    throw new NotImplementedException("OpenAddressing::remove");
  }

  /** Returns whether the key is in the set */
  @Override
  public boolean contains(int key) {
    // TODO
    throw new NotImplementedException("OpenAddressing::contains");
  }

  /** Return how many keys are currently in the set */
  @Override
  long size() {
    // TODO
    throw new NotImplementedException("OpenAddressing::size");
  }
}
