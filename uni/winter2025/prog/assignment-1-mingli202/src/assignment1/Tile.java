package assignment1;

public class Tile {
  private boolean isCastle, isCamp, onThePath;
  private Tile towardTheCastle, towardTheCamp;
  private Warrior warrior;
  private MonsterTroop troop;

  public Tile() {
    this.isCastle = false;
    this.isCamp = false;
    this.onThePath = false;
    this.towardTheCastle = null;
    this.towardTheCamp = null;
    this.warrior = null;
    this.troop = new MonsterTroop();
  }

  public Tile(boolean isCastle, boolean isCamp, boolean onThePath,
              Tile towardTheCastle, Tile towardTheCamp, Warrior warrior,
              MonsterTroop troop) {
    this.isCastle = isCastle;
    this.isCamp = isCamp;
    this.onThePath = onThePath;
    this.towardTheCastle = towardTheCastle;
    this.towardTheCamp = towardTheCamp;
    this.warrior = warrior;
    this.troop = troop != null ? troop : new MonsterTroop();
  }

  public boolean isCastle() { return this.isCastle; }
  public boolean isCamp() { return this.isCamp; }
  public void buildCastle() {
    this.onThePath = true;
    this.isCastle = true;
  }
  public void buildCamp() {
    this.onThePath = true;
    this.isCamp = true;
  }
  public boolean isOnThePath() { return onThePath; }

  public Tile towardTheCastle() {
    if (!this.onThePath || this.isCastle) {
      return null;
    }

    return this.towardTheCastle;
  }

  public Tile towardTheCamp() {
    if (!this.onThePath || this.isCamp) {
      return null;
    }

    return this.towardTheCamp;
  }

  public void createPath(Tile towardTheCastle, Tile towardTheCamp) {
    if ((this.isCamp && towardTheCamp != null) ||
        (this.isCastle && towardTheCastle != null) ||
        (!this.isCamp && towardTheCamp == null) ||
        (!this.isCastle && towardTheCastle == null)) {
      throw new IllegalArgumentException(
          "Invalid toward" + (this.isCamp ? "Camp" : "Castle") +
          ". This tile is a " + (this.isCamp ? "Camp" : "Castle") + " Tile");
    }

    this.onThePath = true;
    this.towardTheCastle = towardTheCastle;
    this.towardTheCamp = towardTheCamp;
  }

  public int getNumOfMonsters() { return this.troop.sizeOfTroop(); }
  public Warrior getWarrior() { return this.warrior; }
  public Monster getMonster() { return this.troop.getFirstMonster(); }
  public Monster[] getMonsters() { return this.troop.getMonsters(); }

  public boolean addFighter(Fighter fighter) {
    if (fighter instanceof Warrior) {
      if (this.warrior != null || this.isCamp) {
        return false;
      }

      this.warrior = (Warrior)fighter;
    } else if (fighter instanceof Monster) {
      if (!this.onThePath) {
        return false;
      }

      this.troop.addMonster((Monster)fighter);
    }

    fighter.setPosition(this);

    return true;
  }

  public boolean removeFighter(Fighter fighter) {
    if (fighter instanceof Warrior) {
      if (this.warrior != fighter) {
        return false;
      }
      this.warrior = null;
    } else if (fighter instanceof Monster) {
      if (!this.troop.removeMonster((Monster)fighter))
        return false;
    }

    fighter.setPosition(null);

    return true;
  }

  //@Override
  // public String toString() {
  //  return "Tile(" + String.valueOf(this.getWarrior()) + ",(" +
  //      this.getNumOfMonsters() + ")" + Arrays.toString(this.getMonsters()) +
  //      ")";
  //}
}
