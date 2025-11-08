#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	if (2 != argc) {
		fprintf(stderr, "usage: ./meow LIMIT\n");
		return 1;
	}
	char *endptr;
	long limit = strtol(argv[1], &endptr, 10);
	if (endptr == argv[1]) {
		fprintf(stderr, "fatal: LIMIT not a number\n");
		return 1;
	}

	char buf[256];

	// YOUR CODE BELOW HERE //
	// You're given some lines to do particular things.
	// You'll need to reassemble them and introduce control structures to
	// accomplish the task described below.

	if (limit <= 0){
		return 0;
	}

	int i = 0;
	while (fgets(buf, sizeof(buf), stdin) != NULL) {
		i++;
		printf("%s", buf);

		if (i >= limit) {
			return 0;
		}
	}

	printf("Meow~\n");
	// This reads a line from stdin, storing it in buf.
	// The call to `fgets` returns the special value `NULL` in case reading
	// fails or there is no more input to read.

	// This prints the string `buf` to stdout.
	// printf("%s", buf);

	// YOUR TASK:
	// 1. Use a loop to read lines from stdin until either there is nothing
	//    left to read, or the program has performed `limit` iterations of
	//    the loop.
	// 2. If the program ran out of input to read BEFORE reaching the limit
	//    it should print out "Meow~" followed by a newline character
	//    before exiting.
}
