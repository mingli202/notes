package org.final_as;

import java.lang.Math;
import java.util.*;

public class McMetro {
  protected Track[] tracks;
  protected HashMap<BuildingID, Building> buildingTable = new HashMap<>();

  private TrieNode trie = new TrieNode();

  private HashMap<BuildingID, HashSet<Track>> ad = new HashMap<>();

  private HashMap<TrackID, Integer> capacityTable = new HashMap<>();
  private HashMap<TrackID, Integer> flowTable = new HashMap<>();

  // You may initialize anything you need in the constructor
  McMetro(Track[] tracks, Building[] buildings) {
    if (tracks == null) {
      tracks = new Track[0];
    }

    this.tracks = tracks;

    // Populate buildings table
    for (Building building : buildings) {
      this.buildingTable.putIfAbsent(building.id(), building);
    }

    for (var track : tracks) {
      var b1 = track.startBuildingId();

      this.ad.putIfAbsent(b1, new HashSet<>());

      this.ad.get(b1).add(track);

      this.capacityTable.put(track.id(), this.capacity(track));
      this.flowTable.put(track.id(), 0);
    }
  }

  // Maximum number of passengers that can be transported from start to end
  int maxPassengers(BuildingID start, BuildingID end) {
    if (!this.buildingTable.containsKey(start) ||
        !this.buildingTable.containsKey(end)) {
      return 0;
    }

    int maxFlow = 0;

    while (true) {
      LinkedList<BuildingID> q = new LinkedList<>();
      HashSet<BuildingID> seen = new HashSet<>();
      HashMap<BuildingID, Track> parents = new HashMap<>();

      q.add(start);

      // find a path by doing bfs
      while (!q.isEmpty()) {
        var current = q.poll();

        seen.add(current);

        if (current.equals(end)) {
          break;
        }

        var tracks = this.ad.get(current);

        for (Track track : tracks) {
          var flow = this.flowTable.get(track.id());
          var capacity = this.capacityTable.get(track.id());

          if (!seen.contains(track.endBuildingId()) && flow < capacity) {
            q.add(track.endBuildingId());
            parents.putIfAbsent(track.endBuildingId(), track);
          }
        }
      }

      if (!seen.contains(end)) {
        break;
      }

      // trace back the path
      var building = end;
      int minFlow = Integer.MAX_VALUE;

      while (!building.equals(start)) {
        var track = parents.get(building);
        var capacity = capacityTable.get(track.id());
        var flow = flowTable.get(track.id());
        var residual = capacity - flow;

        minFlow = Math.min(minFlow, residual);
        building = track.startBuildingId();
      }

      // deal with local variable not final error
      int pathFlow = minFlow;

      // update flows
      building = end;
      while (!building.equals(start)) {
        var track = parents.get(building);
        this.flowTable.compute(track.id(), (k, v) -> v + pathFlow);
        building = track.startBuildingId();
      }

      maxFlow += pathFlow;
    }

    return maxFlow;
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

  private int capacity(Track track) {
    var startBuilding = this.buildingTable.get(track.startBuildingId());
    var endBuilding = this.buildingTable.get(track.endBuildingId());

    return Math.min(
        Math.min(startBuilding.occupants(), endBuilding.occupants()),
        track.capacity());
  }

  private int goodNess(Track track) {
    return this.capacity(track) / track.cost();
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
    Arrays.sort(schedules, new TimeComparator()); // sort by end time

    int n = 0;

    int previousEndTime = Integer.MIN_VALUE;

    for (var s : schedules) {
      if (s[0] >= previousEndTime) {
        n++;
        previousEndTime = s[1];
      }
    }

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
    return a[1] - b[1];
  }
}
