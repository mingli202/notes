#include "stringbuilder.h"
#include <stdlib.h>
#include <string.h>

struct string_builder sb_init(int capacity) {
  struct string_builder sb = {.capacity = capacity,
                              .size = 0,
                              .buf = (char *)malloc(capacity * sizeof(char))};

  return sb;
};

void sb_grow(struct string_builder *sb) {
  sb->capacity *= 2;

  char *new_buf = (char *)malloc(sb->capacity * sizeof(char));

  for (int k = 0; k < sb->size; k++) {
    new_buf[k] = sb->buf[k];
  }

  free(sb->buf);
  sb->buf = new_buf;
}

void sb_appendn(struct string_builder *sb, char const *buf, int len) {
  for (int i = 0; i < strlen(buf) && i < len; i++) {
    if (sb->size == sb->capacity) {
      sb_grow(sb);
    }

    sb->buf[sb->size] = buf[i];
    sb->size++;
  }
};

void sb_append(struct string_builder *sb, char const *buf) {
  for (int i = 0; i < strlen(buf); i++) {
    if (sb->size == sb->capacity) {
      sb_grow(sb);
    }

    sb->buf[sb->size] = buf[i];
    sb->size++;
  }
}

void sb_copy_to(struct string_builder const *sb, char *dst, int len) {
  if (len > sb->size) {
    len = sb->size + 1;
  }

  for (int i = 0; i < len; i++) {
    dst[i] = sb->buf[i];
  }

  dst[len - 1] = '\0';
}

char *sb_build(struct string_builder const *sb) {
  char *str = (char *)malloc(sb->size * sizeof(char) + 1);

  for (int i = 0; i < sb->size; i++) {
    str[i] = sb->buf[i];
  }

  str[sb->size] = '\0';

  return str;
}

void sb_destroy(struct string_builder *sb) { free(sb->buf); }
