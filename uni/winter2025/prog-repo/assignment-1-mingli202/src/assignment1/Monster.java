package assignment1;

public class Monster extends Fighter {
  private int rageLevel;
  public static int BERSERK_THRESHOLD;

  public Monster(Tile position, double health, int weaponType,
                 int attackDamage) {
    super(position, health, weaponType, attackDamage);
    this.rageLevel = 0;
  }

  @Override
  public int takeAction() {
    // System.out.println(this.toString());

    Tile t = this.getPosition();

    if (t == null) {
      return 0;
    }

    if (!t.isOnThePath()) {
      throw new Error("Monster should be on a Tile that is on the path");
    }

    Warrior w = this.getPosition().getWarrior();
    if (w != null) {
      w.takeDamage(this.getAttackDamage(), this.getWeaponType());

      // puts it to the back of the line
      if (!(t.removeFighter(this) && t.addFighter(this))) {
        throw new Error("Could not remove or add this monster");
      };
    } else {
      if (!t.removeFighter(this)) {
        throw new Error("Could not remove this monster");
      };

      Tile tNext = t.towardTheCastle();

      // the monster reached the end
      if (tNext == null) {
        return 0;
      }

      if (!tNext.addFighter(this)) {
        throw new Error("Could not add this monster");
      }

      this.setPosition(tNext);
    }

    if (this.rageLevel >= BERSERK_THRESHOLD) {
      this.rageLevel = 0;
      this.takeAction();
    }

    return 0;
  }

  private int max(int a, int b) {
    if (a > b) {
      return a;
    }
    return b;
  }

  @Override
  public double takeDamage(double dmgReceived, int attackerWeaponType) {
    this.rageLevel += max(attackerWeaponType - this.getWeaponType(), 0);
    return super.takeDamage(dmgReceived, attackerWeaponType);
  }

  @Override
  public boolean equals(Object other) {
    return super.equals(other) &&
        this.getAttackDamage() == ((Monster)other).getAttackDamage();
  }

  @Override
  public String toString() {
    return String.format("M(%f)", this.getHealth());
  }
}
