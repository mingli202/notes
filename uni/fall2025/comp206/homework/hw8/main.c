#include "ringbuffer.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  if (argc != 3) {
    fprintf(stderr, "Usage: %s N PATH\n", argv[0]);
    return 1;
  }

  char* endptr;
  long n = strtol(argv[1], &endptr, 10);
  if (*endptr != '\0') {
    fprintf(stderr, "N must be a positive integer\n");
    return 1;
  }
  if (n == 0) {
    return 0;
  }

  char *path = argv[2];

  struct ringbuffer rb = rb_init(n);

  FILE *fp = fopen(path, "r");
  if (fp == NULL) {
    fprintf(stderr, "Failed to open %s\n", path);
    return 3;
  }

  char line[LINE_LENGTH + 1];
  while (fgets(line, LINE_LENGTH, fp) != NULL) {
    rb_push(&rb, line);
  }

  fclose(fp);

  while (rb_pop(&rb, line)) {
    printf("%s", line);
  }

  rb_destroy(&rb);

  return 0;
}
