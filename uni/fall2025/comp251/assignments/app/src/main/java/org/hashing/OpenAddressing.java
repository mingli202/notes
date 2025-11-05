package org.hashing;

public class OpenAddressing extends SimpleHashSet {
  public int[] Table;
  private int size = 0;

  protected OpenAddressing(int w, int seed, int A) {
    super(w, seed, A);
    this.Table = new int[m];
    for (int i = 0; i < m; i++) {
      Table[i] = -1;
    }
  }

  /**Implements the probe function p(k, i)*/
  public int probe(int key, int i) {
    int hash = (((this.A * key) % power2(this.w)) >> (this.w - this.r));
    return (hash + i) % this.m;
  }

  /**
   * Inserts key k into hash set. Returns the number of collisions encountered
   */
  @Override
  public int insert(int key) {
    boolean contains = this.contains(key);

    for (int i = 0; i < this.m; i++) {
      int hash = this.probe(key, i);
      int val = this.Table[hash];

      if (val == key) {
        return i + 1;
      }

      if (val < 0 && !contains) {
        this.Table[hash] = key;
        this.size++;
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
      int val = this.Table[this.probe(key, i)];

      if (val == -1) {
        return i + 1;
      }

      if (val == key) {
        this.Table[this.probe(key, i)] = -2;
        this.size--;
        return i;
      }
    }
    return this.m;
  }

  /** Returns whether the key is in the set */
  @Override
  public boolean contains(int key) {
    for (int i = 0; i < this.m; i++) {
      int val = this.Table[this.probe(key, i)];
      if (val == key) {
        return true;
      }
    }
    return false;
  }

  /** Return how many keys are currently in the set */
  @Override
  long size() {
    return this.size;
  }
}
