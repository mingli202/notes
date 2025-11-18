package assignment1;

public class Bladesworn extends Warrior {
  public static double BASE_HEALTH;
  public static int BASE_COST;
  public static int WEAPON_TYPE = 3;
  public static int BASE_ATTACK_DAMAGE;

  @Override
  public int takeAction() {
    // System.out.println(this.toString());

    Tile t = this.getPosition();

    if (t == null) {
      return 0;
    }

    int skillPoint = 0;

    if (t.getNumOfMonsters() > 0) {
      Monster first = t.getMonster();
      double dmgDealt =
          first.takeDamage(this.getAttackDamage(), this.getWeaponType());

      skillPoint = (int)(this.getAttackDamage() / dmgDealt) + 1;
    } else {
      Tile tNext = t.towardTheCamp();

      if (tNext != null && tNext.addFighter(this)) {
        if (!t.removeFighter(this)) {
          throw new Error("Can't remove fighter from tile");
        };
        this.setPosition(tNext);
      }
    }

    return skillPoint;
  }

  public Bladesworn(Tile position) {
    super(position, BASE_HEALTH, WEAPON_TYPE, BASE_ATTACK_DAMAGE, BASE_COST);
  }

  @Override
  public String toString() {
    return String.format("B(%f)", this.getHealth());
  }
}
