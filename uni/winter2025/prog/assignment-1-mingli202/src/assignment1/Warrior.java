package assignment1;

public abstract class Warrior extends Fighter {
  private int requiredSkillPoints;

  // percentage of dmg reduction warriors receive when on castle tile
  public static double CASTLE_DMG_REDUCTION;

  public Warrior(Tile position, double health, int weaponType, int attackDamage,
                 int requiredSkillPoints) {
    super(position, health, weaponType, attackDamage);
    this.requiredSkillPoints = requiredSkillPoints;
  }

  public int getTrainingCost() { return this.requiredSkillPoints; }

  @Override
  public double takeDamage(double dmgReceived, int attackerWeaponType) {
    return super.takeDamage(this.getPosition().isCastle()
                                ? dmgReceived * (1 - CASTLE_DMG_REDUCTION)
                                : dmgReceived,
                            attackerWeaponType);
  }
}
