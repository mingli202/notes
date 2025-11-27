#include <math.h>
#include <stdio.h>

#define PI 3.1415926535

long long factorial(int n) {
  long long product = 1;

  for (int i = n; i > 0; i--) {
    product *= i;
  }

  return product;
}

double s3(int n) {
  return (pow(-1, n) * pow(PI, 2 * n)) / (factorial(2 * n) * pow(36, n));
}

double s4(int n) { return (n + 1) / (pow(2, n)); }

double s5(int n) { return (pow(n, 2) + 3 * n) / pow(2, n); }

int main(int argc, char *argv[]) {

  double total = 0;

  long start = 1;
  long end = 100;

  for (long n = start; n < end; n++) {
    total += s5(n);
  }

  printf("%f\n", total);

  return 0;
}
