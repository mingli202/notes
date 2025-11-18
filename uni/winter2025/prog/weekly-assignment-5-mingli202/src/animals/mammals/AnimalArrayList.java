package animals.mammals;

public class AnimalArrayList {

  Animal[] array;
  int size;
  static int INITIAL_CAPACITY = 10;

  public AnimalArrayList() {
    array = new Animal[INITIAL_CAPACITY];
    size = 0;
  }

  public void add(Animal d) {
    // TODO
    if (this.size == this.array.length) {
      Animal[] newArray = new Animal[this.array.length + INITIAL_CAPACITY];

      for (int i = 0; i < this.size; i++) {
        newArray[i] = this.array[i];
      }

      this.array = newArray;
    }
    this.array[this.size] = d;
    this.size++;
  }

  public String toString() {

    // start with an empty string
    String msg = "";

    // start with the head node
    for (int i = 0; i < size; i++) {
      // append animal name
      msg = msg + array[i].getName() + "\n";
    }
    return msg;
  }
}
