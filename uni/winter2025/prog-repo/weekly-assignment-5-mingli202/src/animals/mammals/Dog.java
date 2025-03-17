package animals.mammals;

public class Dog extends Animal {
  private int energy;

  public Dog(String name) { this(name, "brown", "Chihuahua", 2); }

  public Dog(String name, String color, String breed, int energy) {
    super(name, color, breed);
    this.energy = energy;
  }

  public void bark() {
    if (energy > 5) {
      System.out.println("WOOF WOOF!");
    } else {
      System.out.println("woof woof");
    }
  }

  @Override
  public String getSound() {
    return "Woof";
  }

  @Override
  public boolean equals(Object object) {
    // TODO complete method
    return super.equals(object) &&
        this.energy ==
            ((Dog)object).energy; // placeholder only, remove if needed
  }
}
