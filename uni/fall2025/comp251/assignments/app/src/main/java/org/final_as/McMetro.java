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

    for (Character c : name.toCharArray()) {
      node.children.putIfAbsent(c, new TrieNode());
      node = node.children.get(c);
    }

    node.endOfWord = true;
    node.name = name;
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
  static int hireTicketCheckers(int[][] schedule) {
    // TODO: your implementation here
    return 0;
  }
}

class TrieNode {
  Map<Character, TrieNode> children = new HashMap<>();
  boolean endOfWord = false;
  String name = null;
}
