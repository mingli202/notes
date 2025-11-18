// the line below defines the package (i.e. folder) where the file lives.
package tut02Exercises;

public class CharRightShift {
  public static char charRightShift(char ch, int shift) {
    // Verify if the input is a lowercase letter
    if (ch < 'a' || ch > 'z') {
      return ch;
    }

    int pos = ch - (int)'a';

    if (shift < 0) {
      shift = 26 + shift % 26;
    }

    pos = (pos + shift) % 26 + (int)'a';

    return (char)pos;
  }
}
