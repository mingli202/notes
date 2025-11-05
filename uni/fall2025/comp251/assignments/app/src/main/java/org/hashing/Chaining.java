package org.hashing;

import java.util.*;

public class Chaining extends SimpleHashSet {
  public ArrayList<ArrayList<Integer>> Table;

  private int size = 0;

  protected Chaining(int w, int seed, int A) {
    super(w, seed, A);
    this.Table = new ArrayList<>(m);
    for (int i = 0; i < m; i++) {
      Table.add(new ArrayList<>());
    }
  }

  /**Implements the hash function h(k)*/
  public int hash(int key) {
    return ((this.A * key) % (power2(this.w)) >> (this.w - this.r));
  }

  /**Inserts key k into hash table. Returns the number of collisions
   * encountered*/
  @Override
  public int insert(int key) {
    var slot = this.Table.get(this.hash(key));

    int index = slot.indexOf(key);
    if (index != -1) {
      return index + 1;
    }

    int collision = slot.size();
    slot.add(key);
    this.size++;

    return collision;
  }

  /**
   * Removes key k from hash table. Returns the number of collisions
   * encountered
   */
  @Override
  int remove(int key) {
    var slot = this.Table.get(this.hash(key));

    int index = slot.indexOf(key);

    if (index != -1) {
      slot.remove(index);
      this.size--;
      return index;
    }

    return slot.size();
  }

  /** Returns whether the key is in the set */
  @Override
  boolean contains(int key) {
    return this.Table.get(this.hash(key)).contains(key);
  }

  /** Return how many keys are currently in the set */
  @Override
  long size() {
    return this.size;
  }
}
