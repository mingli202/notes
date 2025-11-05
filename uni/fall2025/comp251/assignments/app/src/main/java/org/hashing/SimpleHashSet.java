package org.hashing;

import java.util.Random;

abstract public class SimpleHashSet {
  public int m; // number of SLOTS AVAILABLE
  public int A; // the default random number
  protected int w;
  protected int r;

  abstract int insert(int key);
  abstract int remove(int key);
  abstract boolean contains(int key);
  abstract long size();

  protected SimpleHashSet(int w, int seed, int A) {
    this.w = w;
    this.r = (w - 1) / 2 + 1;
    this.m = power2(r);
    if (A == -1) {
      this.A = generateRandom(power2(w - 1), power2(w), seed);
    } else {
      this.A = A;
    }
  }

  public static int power2(int w) { return (int)Math.pow(2, w); }

  public static int generateRandom(int min, int max, int seed) {
    Random generator = new Random();
    if (seed >= 0) {
      generator.setSeed(seed);
    }
    int i = generator.nextInt(max - min - 1);
    return i + min + 1;
  }
}
