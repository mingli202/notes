Here’s a backtracking search to solve a problem called ”exact cover by 3-sets.” It tries to find a subset
of l that partitions the set x. It does this by exhaustively checking whether each subset of l is a valid
solution to the overall set x.
```ocaml
exception Fail
let x3c (x : 'a set) (l : 'a set list) : 'a set list =
let rec go l sample =
match l with
| [] -> if check_x3c x sample then sample else raise Fail
| c :: cs ->
try go cs (c :: sample) with
| Fail -> go cs sample
in
go l []
```
The program above finds an arbitrary first solution to the problem instance (x, l). Translate this
program into a lazily generated sequence of all solutions to the problem instance. You
may use any model of lazy programming you like, just give the relevant type definitions.