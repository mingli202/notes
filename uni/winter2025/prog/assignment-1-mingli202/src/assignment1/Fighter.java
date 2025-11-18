package assignment1;

public abstract class Fighter {
  private Tile position;
  private double health;
  private int weaponType;
  private int attackDamage;

  public Fighter(Tile position, double health, int weaponType,
                 int attackDamage) {
    this.health = health;
    this.weaponType = weaponType;
    this.attackDamage = attackDamage;

    if (!position.addFighter(this)) {
      throw new IllegalArgumentException(
          "Invalid Tile: Cannot add fighter to Tile");
    };

    this.position = position;
  }

  public final Tile getPosition() { return this.position; }
  public final double getHealth() { return this.health; }
  public final int getWeaponType() { return this.weaponType; }
  public final int getAttackDamage() { return this.attackDamage; }

  public void setPosition(Tile position) { this.position = position; }

  public double takeDamage(double dmgReceived, int attackerWeaponType) {
    if (attackerWeaponType > this.weaponType) {
      dmgReceived *= 1.5;
    } else if (attackerWeaponType < this.weaponType) {
      dmgReceived *= 0.5;
    }
    this.health -= dmgReceived;
    this.handleDeath();

    return dmgReceived;
  }

  private void handleDeath() {
    if (this.health <= 0.0) {
      this.position.removeFighter(this);
      this.position = null;
    }
  }

  public abstract int takeAction();

  @Override
  public boolean equals(Object other) {
    return other instanceof Fighter &&
        Math.abs(((Fighter)other).getHealth() - this.health) <= 0.001 &&
        ((Fighter)other).getPosition() == this.position;
  }
}
