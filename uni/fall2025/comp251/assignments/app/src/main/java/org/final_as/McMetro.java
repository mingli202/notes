package org.final_as;

import com.google.gson.Gson;
import java.lang.Math;
import java.util.*;

public class McMetro {
  protected Track[] tracks;
  protected HashMap<BuildingID, Building> buildingTable = new HashMap<>();

  private TrieNode trie = new TrieNode();

  private HashMap<BuildingID, HashSet<BuildingID>> ad = new HashMap<>();
  private NaiveDisjointSet<BuildingID> disjointSet = new NaiveDisjointSet<>();

  private HashMap<BuildingID[], Track> tracksTable = new HashMap<>();

  // You may initialize anything you need in the constructor
  McMetro(Track[] tracks, Building[] buildings) {
    this.tracks = tracks;

    // Populate buildings table
    for (Building building : buildings) {
      this.buildingTable.putIfAbsent(building.id(), building);
    }

    for (var track : tracks) {
      var b1 = track.startBuildingId();
      var b2 = track.endBuildingId();

      this.ad.putIfAbsent(b1, new HashSet<>());
      this.ad.putIfAbsent(b2, new HashSet<>());

      this.ad.get(b1).add(b2);
      this.ad.get(b2).add(b1);

      this.tracksTable.put(new BuildingID[] {b1, b2}, track);
      this.tracksTable.put(new BuildingID[] {b2, b1}, track);
    }

    HashSet<BuildingID> seen = new HashSet<>();

    for (var buildingId : this.ad.keySet()) {
      this.disjointSet.add(buildingId);
    }
    for (var buildingId : this.ad.keySet()) {
      this.discoverIslands(buildingId, seen);
    }
  }

  private void discoverIslands(BuildingID curr, HashSet<BuildingID> seen) {
    if (seen.contains(curr)) {
      return;
    }
    seen.add(curr);

    for (var other : this.ad.get(curr)) {
      this.disjointSet.union(other, curr);
      this.discoverIslands(other, seen);
    }
  }

  // Maximum number of passengers that can be transported from start to end
  int maxPassengers(BuildingID start, BuildingID end) {
    var rep1 = this.disjointSet.find(start);
    var rep2 = this.disjointSet.find(end);

    if (rep1 != rep2) {
      return 0;
    }

    return 0;
  }

  // Returns a list of trackIDs that connect to every building maximizing total
  // network capacity taking cost into account
  TrackID[] bestMetroSystem() {
    // your implementation here

    Arrays.sort(this.tracks, new Comparator<Track>() {
      @Override
      public int compare(Track o1, Track o2) {
        return goodNess(o2) - goodNess(o1);
      }
    });

    ArrayList<TrackID> bestTracks = new ArrayList<>();

    NaiveDisjointSet<BuildingID> buildings = new NaiveDisjointSet<>();

    for (var building : this.buildingTable.keySet()) {
      buildings.add(building);
    }

    for (var track : this.tracks) {
      var b1 = track.startBuildingId();
      var b2 = track.endBuildingId();

      var rep1 = buildings.find(b1);
      var rep2 = buildings.find(b2);

      if (rep1.equals(rep2)) {
        continue;
      }

      bestTracks.add(track.id());
      buildings.union(b1, b2);
    }

    return bestTracks.toArray(new TrackID[bestTracks.size()]);
  }

  private int goodNess(Track track) {
    var startBuilding = this.buildingTable.get(track.startBuildingId());
    var endBuilding = this.buildingTable.get(track.endBuildingId());

    return Math.min(
        Math.min(startBuilding.occupants(), endBuilding.occupants()),
        track.capacity());
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

    firstLetters = firstLetters.toLowerCase();

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

    Collections.sort(names);

    return names;
  }

  // Return how many ticket checkers will be hired
  static int hireTicketCheckers(int[][] schedules) {
    // your implementation here
    Arrays.sort(schedules, new TimeComparator()); // sort by start time
    HashMap<String, Integer> memo = new HashMap<>();

    Gson gson = new Gson();
    System.out.println(gson.toJson(schedules));

    return dp(0, schedules, memo, Integer.MIN_VALUE);
  }

  private static int dp(int index, int[][] schedules,
                        HashMap<String, Integer> memo, int previousEnd) {
    if (index >= schedules.length) {
      return 0;
    }

    var canBeTaken = schedules[index][0] >= previousEnd;

    var key = "" + index + canBeTaken;

    if (memo.containsKey(key)) {
      return memo.get(key);
    }

    int n = dp(index + 1, schedules, memo, previousEnd); // skip

    if (canBeTaken) {
      n = Math.max(n, dp(index + 1, schedules, memo, schedules[index][1]) +
                          1); // take
    }

    memo.put(key, n);

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
    return a[0] - b[0];
  }
}
