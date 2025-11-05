
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
    int hash = (this.A * (key % (power2(this.w))) >> (this.w - this.r));
    return (hash + i) % this.m;
  }

  /**
   * Inserts key k into hash set. Returns the number of collisions encountered
   */
  @Override
  public int insert(int key) {
    for (int i = 0; i < this.m; i++) {
      if (this.Table[this.probe(key, i)] == -1) {
        this.Table[this.probe(key, i)] = key;
        return i;
      }
    }
    return this.m;
  }

  /**
   * Removes key k from hash table. Returns the number of collisions
   * encountered
   */
  @Override
  public int remove(int key) {
    for (int i = 0; i < this.m; i++) {
      if (this.Table[this.probe(key, i)] == key) {
        this.Table[this.probe(key, i)] = -1;
        return i;
      }
    }
    return this.m;
  }

  /** Returns whether the key is in the set */
  @Override
  public boolean contains(int key) {
    for (int i = 0; i < this.m; i++) {
      if (this.Table[this.probe(key, i)] == key) {
        return true;
      }
    }
    return false;
  }

  /** Return how many keys are currently in the set */
  @Override
  long size() {
    int n = 0;
    for (int i = 0; i < this.m; i++) {
      if (this.Table[i] != -1) {
        n++;
      }
    }
    return n;
  }
}
