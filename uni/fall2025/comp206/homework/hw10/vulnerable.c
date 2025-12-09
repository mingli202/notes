#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char const *USER_PASSWORD = "abc123";
char const *ADMIN_PASSWORD = "REDACTED";

void print_user_report() { printf("Keep it up. Jake believes in you.\n"); }

void print_admin_report() { printf("FLAG: REDACTED\n"); }

void read_stdin_line(char *dst) {
  int c;
  while (1) {
    c = fgetc(stdin);
    if ('\n' == c || EOF == c) {
      *dst = '\0';
      return;
    }
    *(dst++) = (char)c;
  }
}

int main() {
  int admin = 0;
  int login_successful = 0;
  char buf[40];
  read_stdin_line(buf);
  if (0 == strcmp(buf, "admin")) {
    admin = 1;
  }
  read_stdin_line(buf);
  if (admin && 0 == strcmp(buf, ADMIN_PASSWORD)) {
    login_successful = 1;
  } else if (!admin && 0 == strcmp(buf, USER_PASSWORD)) {
    login_successful = 1;
  }

  if (login_successful != 1) {
    printf("Login failed.\n");
    printf("%i", login_successful);
    return 0;
  }

  if (admin) {
    print_admin_report();
  } else {
    print_user_report();
  }

  return 0;
}
