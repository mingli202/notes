package org.hashing;

import java.util.*;

public class Chaining extends SimpleHashSet {
  public ArrayList<ArrayList<Integer>> Table;

  protected Chaining(int w, int seed, int A) {
    super(w, seed, A);
    this.Table = new ArrayList<>(m);
    for (int i = 0; i < m; i++) {
      Table.add(new ArrayList<>());
    }
  }

  /**Implements the hash function h(k)*/
  public int hash(int key) {
    return (this.A * key % (power2(this.w)) >> (this.w - this.r));
  }

  /**Inserts key k into hash table. Returns the number of collisions
   * encountered*/
  @Override
  public int insert(int key) {
    // TODO
    throw new NotImplementedException("Chaining::insert");
  }

  /**
   * Removes key k from hash table. Returns the number of collisions
   * encountered
   */
  @Override
  int remove(int key) {
    // TODO
    throw new NotImplementedException("Chaining::remove");
  }

  /** Returns whether the key is in the set */
  @Override
  boolean contains(int key) {
    // TODO
    throw new NotImplementedException("Chaining::contains");
  }

  /** Return how many keys are currently in the set */
  @Override
  long size() {
    // TODO
    throw new NotImplementedException("Chaining::size");
  }
}
