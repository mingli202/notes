package org.final_as;

import java.lang.Math.*;
import java.util.*;

public class McMetro {
  protected Track[] tracks;
  protected HashMap<BuildingID, Building> buildingTable = new HashMap<>();

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
    // TODO: your implementation here
  }

  // Do not change this
  void addPassengers(String[] names) {
    for (String s : names) {
      addPassenger(s);
    }
  }

  // Returns all passengers in the system whose names start with firstLetters
  ArrayList<String> searchForPassengers(String firstLetters) {
    // TODO: your implementation here
    return new ArrayList<>();
  }

  // Return how many ticket checkers will be hired
  static int hireTicketCheckers(int[][] schedule) {
    // TODO: your implementation here
    return 0;
  }
}
