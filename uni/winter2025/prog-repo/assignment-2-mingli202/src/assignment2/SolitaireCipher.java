package assignment2;

public class SolitaireCipher {
  public Deck key;

  public SolitaireCipher(Deck key) {
    this.key = new Deck(key); // deep copy of the deck
  }

  /*
   * Generates a keystream of the given size
   */
  public int[] getKeystream(int size) {
    // Deck key = new Deck(this.key);
    int[] arr = new int[size];

    for (int i = 0; i < size; i++) {
      arr[i] = key.generateNextKeystreamValue();
    }

    return arr;
  }

  /*
   * Encodes the input message using the algorithm described in the pdf.
   */
  public String encode(String msg) {
    if (msg == null) {
      return "";
    }

    msg = msg.toUpperCase();

    String encoded = "";

    int[] bytes = msg.chars().filter((b) -> b >= 'A' && b <= 'Z').toArray();
    int[] keyStream = this.getKeystream(bytes.length);

    for (int i = 0; i < bytes.length; i++) {
      int b = bytes[i];

      if (b >= 'A' && b <= 'Z') {
        int encodedByte = (b + keyStream[i] - 'A') % ('Z' - 'A' + 1) + 'A';
        encoded += (char)encodedByte;
      }
    }

    return encoded;
  }

  /*
   * Decodes the input message using the algorithm described in the pdf.
   */
  public String decode(String msg) {
    if (msg == null) {
      return "";
    }

    int[] keyStream = this.getKeystream(msg.length());

    int[] bytes = msg.chars().toArray();

    String decoded = "";

    for (int i = 0; i < bytes.length; i++) {
      int decodedByte =
          (bytes[i] - 'A' - keyStream[i] + ('Z' - 'A' + 1)) % ('Z' - 'A' + 1) +
          'A';
      decoded += (char)decodedByte;
    }

    return decoded;
  }
}
