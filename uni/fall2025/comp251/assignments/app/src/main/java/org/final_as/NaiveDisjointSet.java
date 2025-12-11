package org.final_as;

import java.util.*;

public class NaiveDisjointSet<T> {
  HashMap<T, T> parentMap = new HashMap<>();
  HashMap<T, Integer> rank = new HashMap<>();

  void add(T element) {
    this.parentMap.put(element, element);
    this.rank.put(element, 1);
  }

  T find(T a) {
    T node = parentMap.get(a);
    if (node.equals(a)) {
      return node;
    } else {
      T rep = find(parentMap.get(a));

      this.parentMap.put(a, rep);

      return rep;
    }
  }

  void union(T a, T b) {
    int rankA = this.rank.get(a);
    int rankB = this.rank.get(b);

    if (rankA < rankB) {
      parentMap.put(find(a), find(b));
    } else {
      parentMap.put(find(a), find(b));

      if (rankA == rankB) {
        this.rank.put(b, rankB + 1);
      }
    }
  }
}
