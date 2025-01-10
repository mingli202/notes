public class hello {
  public static void main(String[] args) {
    int x = 5;
    int y = x++ + ++x + x++;
    System.out.println(String.format("y: %d", y));
  }
}
