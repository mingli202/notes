#include <ctype.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int is_anagram(char *s1, char *s2) {

  if (strlen(s1) != strlen(s2)) {
    return false;
  }

  int *frequency_array = (int *)calloc(26, sizeof(int));

  for (int i = 0; i < strlen(s1); i++) {
    frequency_array[s1[i] - 'a']++;
  }

  for (int i = 0; i < strlen(s2); i++) {
    frequency_array[s2[i] - 'a']--;
  }

  for (int i = 0; i < 26; i++) {
    if (frequency_array[i] != 0) {
      return false;
    }
  }

  return true;
}

int is_all_lowercase(char *s) {
  for (int i = 0; i < strlen(s); i++) {
    if (!islower(s[i])) {
      return false;
    }
  }
  return true;
}

long gcd(long n1, long n2) {
  if (n1 == 0)
    return n2;
  return gcd(n2 % n1, n1);
}

long gcd_many(int n, long ns[]) {
  int gcds = ns[0];

  for (int i = 1; i < n; i++) {
    gcds = gcd(gcds, ns[i]);
  }

  return gcds;
}

int handle_sqrt(int argc, char *argv[]) {
  if (argc != 3) {
    fprintf(stderr, "error: wrong count of inputs to sqrt\n");
    return 2;
  }

  char *endptr;
  char *n = argv[2];
  double val = strtod(n, &endptr);

  if (endptr == n || *endptr != '\0' || val < 0) {
    fprintf(stderr, "error: invalid input to sqrt\n");
    return 3;
  }

  double s = sqrt(val);
  printf("%.2f\n", s);
  return 0;
}

int handle_anagram(int argc, char *argv[]) {
  if (argc != 4) {
    fprintf(stderr, "error: wrong count of inputs to anagram\n");
    return 2;
  }

  char *str1 = argv[2];
  char *str2 = argv[3];

  if (!is_all_lowercase(str1) || !is_all_lowercase(str2)) {
    fprintf(stderr, "error: invalid input to anagram\n");
    return 3;
  }

  bool res = is_anagram(str1, str2);
  printf("%s\n", res ? "true" : "false");

  return 0;
}

int handle_gcd(int argc, char *argv[]) {
  if (argc < 3) {
    fprintf(stderr, "error: wrong count of inputs to gcd\n");
    return 2;
  }

  long ns[argc - 2];

  char *endptr;

  for (int i = 0; i < argc - 2; i++) {
    long n = strtol(argv[i + 2], &endptr, 10);

    if (*endptr != '\0' || n <= 0 || endptr == argv[i + 2]) {
      fprintf(stderr, "error: invalid input to gcd\n");
      return 3;
    }

    ns[i] = n;
  }

  long gcd = gcd_many(argc - 2, ns);
  printf("%li\n", gcd);

  return 0;
}

int main() {
	char buf[127];

	while (1){
    printf("> ");
		fgets(buf, 127, stdin);

    if (strcmp(buf, "\n") == 0) {
      continue;
    }

    uint argc = 2;

    for (int i = 0; i < strlen(buf); i++) {
      if (buf[i] == ' ') {
        argc++;
      }
      if (buf[i] == '\n') {
        buf[i] = '\0';
      }
    }

    char* argv[argc];

    char* token = strtok(buf, " ");

    for (int i = 0; token != NULL; i++) {
      argv[i + 1] = token;
      token = strtok(NULL, " ");
    }

    char *cmd = argv[1];

    if (strcmp(cmd, "sqrt") == 0) {
      handle_sqrt(argc, argv);
    } else if (strcmp(cmd, "gcd") == 0) {
      handle_gcd(argc, argv);
    } else if (strcmp(cmd, "anagram") == 0) {
      handle_anagram(argc, argv);
    } else if (strcmp(cmd, "exit") == 0) {
      return 0;
    } else {
      fprintf(stderr, "error: unknown command ");
      fprintf(stderr, "%s\n", cmd);
    }
	}
}
