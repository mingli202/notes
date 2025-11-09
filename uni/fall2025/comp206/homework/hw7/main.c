#include "./stringbuilder.h"

#include <stdio.h>
#include <stdlib.h>

int main() {
  struct string_builder sb = sb_init(0);
  sb_append(&sb, "hello world");

  printf("capacity: %i\n", sb.capacity);
  printf("size: %i\n", sb.capacity);
  char *s = sb_build(&sb);

  char s2[120];
  sb_copy_to(&sb, s2, 120);

  printf("s: %s\n", s);
  printf("s2: %s\n", s2);

  free(s);
  sb_destroy(&sb);

  return 0;
}
