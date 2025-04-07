import assignment3.*;

public class Main {
  public static void main(String[] args) {
    Block.gen.setSeed(2);

    Block b = new Block(0, 2);
    System.out.println(b.getBlockIndentedString(0));
  }
}
