package org.final_as;

import java.lang.Math.*;
import java.util.*;

public class McMetro {
  protected Track[] tracks;
  protected HashMap<BuildingID, Building> buildingTable = new HashMap<>();

  private TrieNode trie = new TrieNode();

  // You may initialize anything you need in the constructor
  McMetro(Track[] tracks, Building[] buildings) {
    this.tracks = tracks;

    // Populate buildings table
    for (Building building : buildings) {
      buildingTable.putIfAbsent(building.id(), building);
    }
  }

  // Maximum number of passengers that can be transported from start to end
  int maxPassengers(BuildingID start, BuildingID end) {
    // TODO: your implementation here
    return 0;
  }

  // Returns a list of trackIDs that connect to every building maximizing total
  // network capacity taking cost into account
  TrackID[] bestMetroSystem() {
    // TODO: your implementation here
    return new TrackID[0];
  }

  // Adds a passenger to the system
  void addPassenger(String name) {
    // your implementation here
    if (name == null || name.isEmpty()) {
      return;
    }

    TrieNode node = this.trie;

    name = name.toLowerCase();
    for (Character c : name.toCharArray()) {
      node.children.putIfAbsent(c, new TrieNode());
      node = node.children.get(c);
    }

    node.endOfWord = true;
    node.name = name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  // Do not change this
  void addPassengers(String[] names) {
    for (String s : names) {
      addPassenger(s);
    }
  }

  // Returns all passengers in the system whose names start with firstLetters
  ArrayList<String> searchForPassengers(String firstLetters) {
    // your implementation here
    TrieNode node = this.trie;
    ArrayList<String> names = new ArrayList<>();

    for (var c : firstLetters.toCharArray()) {
      node = node.children.get(c);

      if (node == null) {
        return names;
      }
    }

    ArrayList<TrieNode> stack = new ArrayList<>();
    stack.add(node);

    while (stack.size() > 0) {
      node = stack.removeLast();
      stack.addAll(node.children.values());

      if (node.endOfWord) {
        names.add(node.name);
      }
    }

    return names;
  }

  // Return how many ticket checkers will be hired
  static int hireTicketCheckers(int[][] schedules) {
    // your implementation here

    Arrays.sort(schedules, new TimeComparator()); // sort by end time
    HashMap<Integer, Integer> memo = new HashMap<>();

    return dp(0, schedules, memo);
  }

  static int dp(int index, int[][] schedules, HashMap<Integer, Integer> memo) {
    if (index >= schedules.length) {
      return 0;
    }

    if (memo.containsKey(index)) {
      return index;
    }

    int n = dp(index + 1, schedules, memo); // skip

    if (index + 1 < schedules.length &&
        schedules[index + 1][1] <= schedules[index][0]) {
      n = Math.max(n, dp(index + 1, schedules, memo) + 1); // take
    }

    memo.put(index, n);

    return n;
  }
}

class TrieNode {
  Map<Character, TrieNode> children = new HashMap<>();
  boolean endOfWord = false;
  String name = null;
}

class TimeComparator implements Comparator<int[]> {
  @Override
  public int compare(int[] a, int[] b) {
    return b[1] - a[1];
  }
}
