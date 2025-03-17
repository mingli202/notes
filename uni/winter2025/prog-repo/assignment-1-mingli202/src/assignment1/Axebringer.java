package assignment1;

public class Axebringer extends Warrior {
  public static double BASE_HEALTH;
  public static int BASE_COST;
  public static int WEAPON_TYPE = 2;
  public static int BASE_ATTACK_DAMAGE;

  private boolean isSkip;

  public Axebringer(Tile position) {
    super(position, BASE_HEALTH, WEAPON_TYPE, BASE_ATTACK_DAMAGE, BASE_COST);
    this.isSkip = false;
  }

  @Override
  public int takeAction() {
    // System.out.println(this.toString());

    if (this.isSkip) {
      this.isSkip = false;
      return 0;
    }

    Tile t = this.getPosition();

    if (t == null) {
      return 0;
    }

    if (t.getNumOfMonsters() > 0) {
      Monster first = t.getMonster();
      double dmgDealt =
          first.takeDamage(this.getAttackDamage(), this.getWeaponType());
      return (int)(this.getAttackDamage() / dmgDealt) + 1;
    }

    t = t.towardTheCamp();

    if (t == null || t.isCamp() || t.getNumOfMonsters() == 0) {
      return 0;
    }

    double damageDealt =
        t.getMonster().takeDamage(this.getAttackDamage(), this.getWeaponType());

    this.isSkip = true;

    return (int)(this.getAttackDamage() / damageDealt) + 1;
  }

  @Override
  public String toString() {
    return String.format("A(%f)", this.getHealth());
  }
}
