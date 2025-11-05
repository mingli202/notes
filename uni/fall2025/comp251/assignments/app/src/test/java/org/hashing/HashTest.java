package org.hashing;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.*;

public class HashTest {
  private static final int W = 10;
  private static final int SEED = 0;
  private static final int A = -1;
  private Chaining chaining;
  private OpenAddressing openAddressing;

  @BeforeEach
  void setup() {
    openAddressing = new OpenAddressing(W, SEED, A);
    chaining = new Chaining(W, SEED, A);
  }

  @Test
  void test0() {
    assertEquals(30, openAddressing.probe(1, 0));
  }

  @Test
  void test1() {
    assertEquals(1, openAddressing.probe(1, 3));
  }

  @Test
  void test14() {
    assertEquals(30, chaining.hash(1));
  }
}
