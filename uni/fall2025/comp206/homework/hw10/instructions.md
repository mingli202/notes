# Fall 2024 - COMP 206 - Homework 8: information security

Due: Thursday, 28 November 2024, 11:59pm.

This assignment consists of two parts.

1. Short-answer questions about encryption. You can expect similar types of
   questions on the upcoming midterm and final.
2. Two hacking challenges. We would ask theoretical questions about these
   topics on a test.

## Infosec theory and encryption (4 points)

Write your answers to these questions in a file `crypto.txt`

1. What are the three pillars of information security? Describe each in a sentence.
   - A hacker breaks into a hospital system and encrypts all patient records
     until receipt of payment. This is known as a _ransomware_ attack. What
     pillar of information security is undermined by this attack?
   - A hacker breaks into a payment processor's database, extracts all its
     information, and sells it to criminals. What pillar of information
     security is undermined by this attack?
3. Explain to what end and under what circumstances two parties would use the
   Diffie-Hellman key exchange algorithm.
4. Explain how the RSA algorithm can be used to prove ownership of a private key.
5. Assume that you and I have a preshared key K. Explain how you can use this
   key to attach an authentication code to a message that certifies to me that
   you authored the message *without encrypting the message.*

## Hacking Challenges

These challenges are inspired from
[Capture-the-Flag](https://en.wikipedia.org/wiki/Capture_the_flag_(cybersecurity)) (CTF)
cybersecurity contests.

In these contests, organizers create purposefully vulnerable programs in which
are hidden special text strings called "flags". Contestants typically race to
discover and exploit the vulnerabilities in these programs to uncover the
flags.

We have designed the two CTF-like challenges in this assignment not as a
competition, so there is no reward for completing them early. **We expect you to
collaborate with one or two peers** in solving these puzzles.

**You must not hack these vulnerable programs beyond what is asked for in the
assignment.**

**You must not "break" the challenges so that others can no longer complete
them.**

### Challenge 1: injection attack

Visit [this web page](https://cs.mcgill.ca/~jerrin1/calc.html)

It is a simple calculator that evaluates integer arithmetic expressions in a stupidly unsafe
way.

In a file `injection.txt`, write a small journal entry that answers the
following:
1. By what means are the expressions being evaluated by the server? How did you
   find that out?
2. What is the general shape of a malicious string that executes an arbitrary
   command of your choosing?
3. What is the flag?

### Challenge 2: reverse engineering / buffer overflow attack

Visit [this web page](https://cs.mcgill.ca/~jerrin1/login.html) The username
and password that you supply on this page are passed each as a separate line of
standard input to a (vulnerable) C program.

**Your objective is to break this login program,** logging in as the admin user
without even figuring out what the admin password is! Logging in as the admin
user prints out the flag.

Typically in a reverse engineering challenge, one only gets the compiled binary
file of the vulnerable program. However, that would make this challenge
exceedingly difficult for you, who has probably not taken COMP 273 (yet!). That
course introduces you to the inner workings of the CPU and to assembly language
programming.

However, to introduce you to binary reverse engineering in this assignment, I'm
giving you (redacted) source code of the vulnerable C program, giving you a
quick intro to assembly language, and giving you some explicit instructions
that will invite you to compare the C source code with its compiled,
assembly-language version.

#### Small intro to assembly language

The primitive, intrinsic programming language of the CPU at the heart of a
computer is called _machine code._ Machine code is written in binary, so it is
unreadable by humans without herculean effort. A human-readable form of machine
code exists, called _assembly language._ This is a textual format in which each
line of code directly corresponds to a machine code instruction.

Each different CPU architecture has its own machine code and hence its own
assembly language. In the rest of this description, I'll focus on the Intel
x86_64 architecture and I'll write assembly code in the so-called Intel syntax.

Each instruction in assembly language looks something like:

```
mnemonic op1, op2
```

- The "mnemonic" identifies what kind of operation the CPU should perform.
  This can be operations like "add numbers", "jump execution to a different
  location", or "check if two numbers are equal".
- `op1` `op2` are the operands of the operation.
  Depending on the operation, the operands can be literal integer values
  (called _immediate values_), memory addresses from which data should be read
  or written, or internal CPU variables called _registers._
  Different operations can vary in how many operands they use; they do not all
  use 2 operands.

A few example operations you'll see:
* `sub rsp, 0x40` subtracts the literal value `0x40` from the value in the
  register `rsp`.
* `mov dword ptr [rbp-4], 0` moves (copies) the literal value 0 to the memory
  address `rbp-4`.
  * Square brackets indicate a memory address. So `0` is the literal 0, but
    `[0]` is the memory address 0.
  * The `dword ptr` part is called a _size modifier_ and specifies that `rbp-4`
    should be understood as a "double-word pointer". A "word" in Intel assembly
    means 16 bits, so a double-word is 32 bits.

**Aside: hexadecimal notation**

- When numbers are written with the prefix `0x`, this indicates that they are
  written in _heXadecimal_ notation -- that's base 16.
- The digits A thru F represent numbers 10 thru 15 respectively. So `0xA` is
  how we write `10` in hex.
- Hexadecimal notation is convenient because with exactly two digits we can
  represent all possible values of a single byte: `0x00` is zero and `0xFF` is
  255.
- You should know from a math class how to convert between different number
  bases by hand, but you can use bash to quickly convert from hex to base10
  simply with `echo $((0x4A2))`.
  This outputs `1186`, = `4 x 16^2 + 10 x 16^1 + 2 x 16^0`, = `1024 + 160 + 2`.

A x86_64 CPU has many registers; see
[here](https://math.hws.edu/eck/cs220/f22/registers.html) for a table
summarizing the basic ones.

**Of particular importance** are the `rbp` and `rsp` registers. These are
called the _base pointer_ and _stack pointer,_ respectively. The `rbp` holds
the address of the top of the current stack frame, whereas `rsp` holds the
address fo the bottom of the current stack frame.

Remember how local variables go on the stack C?
At the beginning of a function in assembly, we usually see `sub rsp, 0xHH` --
this is how `0xHH` bytes of space is allocated on the stack, to hold the values
of all the local variables of our function. (Recall from [the video you
watched](https://www.youtube.com/watch?v=1S0aBV-Waeo) that the stack grows
downwards.) Then, local variables are referred to in the assembly code by an
offset from the base pointer `rbp`. For example, if a function has only two
local variables `int a, b;` then the address of `a` is `rbp-4` and `b`'s is
`rbp-8`.

#### Your instructions

In a file called `re.txt`, write another small journal entry about how you
broke the `vulnerable` program. Follow the below procedure to do so, and be
sure to write answers for the parts in **boldface.**

0. Read the source code `vulnerable.c`.
   **Which part of the program is unsafe? Why?**
1. Run `make` to compile the vulnerable program.
2. Run `gdb ./vulnerable` to load the program in the GNU debugger (gdb).
3. The debugger is an interactive command-line program.
    - If you get a prompt "Enable debuginfod for this session" just say no.
    - Run `set disassembly-flavor intel` to use Intel syntax for assembly code.
    - Run `disassemble main` to show the assembly code for the `main` function.
4. Compare the assembly code for `main` with the source code.
    - **Which instructions correspond to initializing the variables `admin` and
      `login_successful` with zero?**
    - **Why is there no instruction that initializes `buf`?**
    - The `call` instruction is used to call the function at the specified
      address.  GDB shows in angle-brackets the name of the function at that
      address.
    - **What value is passed as input to the `read_stdin_line` function?**
      Express your answer as an offset of `rbp`. (Refer back
      [here](https://math.hws.edu/eck/cs220/f22/registers.html) to see what
      registers are used to pass arguments to functions.)
5. **Make a small textual diagram of the RAM in this function, indicating which
   ranges of bytes (as offsets of `rbp`) store the values of the `admin`,
   `login_successful`, and `buf`.**
6. Quit gdb.
7. Run `./vulnerable`. Following your above investigation, find an input string
   triggering a buffer overflow to print `FLAG: REDACTED`.
   **Explain why your chosen string prints the flag. Refer to your diagram in
your explanation.**
8. Use your string in the web site to get the real flag. **What is the flag?**
9. **Describe a small change one could make to `vulnerable.c`, without
   addressing the buffer overflow vulnerability, that would defeat the approach
you used.**

#### Small bonus (no marks)

Can you find a simple way to use the injection attack from the previous part to uncover the flag
for the reverse engineering part? (Hint: look up the `strings` program.)

## Submission instructions

The text files `crypto.txt`, `injection.txt`, and `re.txt`.

The autograder can't verify that your answers make sense, but I urge you to
take the assignment seriously as preparation for the upcoming quiz.
