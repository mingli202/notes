#include <cmath>
#include <stdio.h>

#define PI 3.141592653589793

double integral(double start, double end, double function(double x)) {
  double dx = 0.0000001;

  double area = 0;
  for (double x = start; x < end; x += dx) {
    area += function(x) * dx;
  }

  return area;
}

double fn(double x) { return sqrt(2 + 1 / (2 * x)); }

int main(int argc, char *argv[]) {
  printf("%f\n", integral(0, 1, fn));
  return 0;
}
