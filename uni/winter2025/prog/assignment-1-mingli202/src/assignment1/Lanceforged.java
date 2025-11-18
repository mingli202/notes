package assignment1;

public class Lanceforged extends Warrior {
  public static double BASE_HEALTH;
  public static int BASE_COST;
  public static int WEAPON_TYPE = 3;
  public static int BASE_ATTACK_DAMAGE;

  private int piercingPower;
  private int actionRange;

  public Lanceforged(Tile position, int piercingPower, int actionRange) {
    super(position, BASE_HEALTH, WEAPON_TYPE, BASE_ATTACK_DAMAGE, BASE_COST);
    this.piercingPower = piercingPower;
    this.actionRange = actionRange;
  }

  @Override
  public int takeAction() {
    // System.out.println(this.toString());

    Tile t = this.getPosition();

    if (t == null) {
      return 0;
    }

    int skillPoint = 0;
    int nMonsterHit = 0;

    for (int i = 0; i <= this.actionRange && t != null; i++) {
      if (!t.isOnThePath() || t.isCamp() || t == null) {
        break;
      }

      Monster[] monsters = t.getMonsters();

      for (int k = 0; k < Math.min(t.getNumOfMonsters(), this.piercingPower);
           k++) {
        double dmgDealt = monsters[k].takeDamage(this.getAttackDamage(),
                                                 this.getWeaponType());

        skillPoint += (int)(this.getAttackDamage() / dmgDealt) + 1;
        nMonsterHit++;
      }

      t = t.towardTheCamp();
    }

    return nMonsterHit == 0 ? 0 : skillPoint / nMonsterHit;
  }

  @Override
  public String toString() {
    return String.format("L(%f)", this.getHealth());
  }
}
