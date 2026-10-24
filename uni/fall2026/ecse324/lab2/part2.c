#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int pell_rec(int n, int *memo) {
  if (n == 0) {
    return 0;
  }
  if (n == 1) {
    return 1;
  }

  int existing = memo[n];

  printf("existing: %d\n", existing);

  if (existing != -1) {
    return existing;
  }

  int val = 2 * pell_rec(n - 1, memo) + pell_rec(n - 2, memo);

  memo[n] = val;

  return val;
}

int *get_memo(int n) {
  int *memo = malloc((n + 1) * sizeof(int));
  memset(memo, -1, (n + 1) * sizeof(int));

  return memo;
}

int pell(int n) {
  int *memo = get_memo(n);
  return pell_rec(n, memo);
}

int main(int argc, char *argv[]) {
  int n = 10;

  int *memo = get_memo(n);

  printf("pell(%d) = %d\n", n, pell_rec(n, memo));
  printf("memo:\n");

  for (int i = 0; i < n + 1; i++) {
    printf("%d: %d\n", i, memo[i]);
  }

  free(memo);

  return EXIT_SUCCESS;
}
