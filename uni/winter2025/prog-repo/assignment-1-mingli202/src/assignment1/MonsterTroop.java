package assignment1;

public class MonsterTroop {
  private Monster[] monsters;
  private int numOfMonsters;

  // implement a circular array
  private int first;
  private int last;

  public MonsterTroop() {
    this.monsters = new Monster[3];
    this.numOfMonsters = 0;
    this.first = 0;
    this.last = 2;
  }

  public int sizeOfTroop() { return this.numOfMonsters; }

  public Monster[] getMonsters() {
    Monster[] monsters = new Monster[this.numOfMonsters];

    for (int i = 0; i < this.numOfMonsters; i++) {
      monsters[i] = this.monsters[(first + i) % this.monsters.length];
    }

    return monsters;
  }

  public Monster getFirstMonster() {
    if (this.numOfMonsters == 0) {
      return null;
    }
    return this.monsters[this.first];
  }

  public void addMonster(Monster monster) {
    if (this.numOfMonsters == this.monsters.length) {
      Monster[] monsters = new Monster[this.monsters.length + 3];

      for (int i = 0; i < this.numOfMonsters; i++) {
        monsters[i] = this.monsters[(first + i) % this.numOfMonsters];
      }
      monsters[this.numOfMonsters] = monster;

      this.monsters = monsters;

      this.first = 0;
      this.last = this.numOfMonsters;
    } else {
      this.last = (this.last + 1) % this.monsters.length;
      this.monsters[this.last] = monster;
    }

    this.numOfMonsters += 1;
  }

  public boolean removeMonster(Monster monster) {
    int i = this.findMonster(monster);

    if (i == this.last) {
      this.monsters[this.last] = null;
      this.last = (this.last - 1 + this.monsters.length) % this.monsters.length;
      this.numOfMonsters--;
      return true;
    }

    if (i == -1) {
      return false;
    }

    int k = i;

    for (; i != this.last && this.monsters[i] != null; i = k) {
      k = (i - 1 + this.monsters.length) % this.monsters.length;

      this.monsters[i] = this.monsters[k];
    }

    this.monsters[this.first] = null;
    this.first = (this.first + 1) % this.monsters.length;
    this.numOfMonsters--;

    return true;
  }

  public int findMonster(Monster monster) {
    for (int i = 0; i < this.numOfMonsters; i++) {
      int k = (i + this.first) % this.monsters.length;
      if (this.monsters[k] == monster) {
        return k;
      }
    }
    return -1;
  }

  //@Override
  // public String toString() {
  //  Monster[] m = this.getMonsters();
  //
  //  return "MT(" + this.numOfMonsters + ")" + Arrays.deepToString(m);
  //}
}
