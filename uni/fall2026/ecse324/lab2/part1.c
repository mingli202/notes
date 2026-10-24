#include <stdbool.h>
#include <stdio.h>
int main(int argc, char *argv[]) {
  // the number of integers to search for primes (n > 0)
  const unsigned int n = 12;
  // numbers: the numbers to search for primes;
  // must be sequential integers starting at 2
  unsigned short numbers[12] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};
  // primes: storage for the primes that we find
  unsigned short primes[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  unsigned int num = 0, pri = 0; // indices for numbers and primes
  unsigned short prime = 1;      // keep track of recently found prime
  bool done = false;             // keep track of our progress
  // search numbers until all values equal 0
  while (!done) {
    // next location from the last prime number
    num = prime - 1;
    // get first non-zero element in numbers and put it in primes
    while (num < n && numbers[num] == 0)
      num++; // it was zero; check the next
    // if we've found a non-zero element,
    // save it, and mark off divisible integers
    if (num >= n) {
      done = true;
    } else {
      prime = numbers[num]; // save it
      primes[pri] = prime;  // put it in the list
      pri++;                // increment list index
      // mark off all divisible elements by stepping through the list
      while (num < n) {
        // it's divisible, not prime, mark it off
        numbers[num] = 0;
        // step to next divisible location
        num += prime;
      } // while
    } // if
  } // while
  //

  for (int i = 0; i < n; i++) {
    printf("%d\n", primes[i]);
  }

  return 0;
} // main
