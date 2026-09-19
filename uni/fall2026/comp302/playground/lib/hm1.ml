(* Question 1: Manhattan Distance *)
(* TODO: Write a good set of tests for distance. *)
let distance_tests =
  [
    ( ((0, 0), (0, 0)),
      (* input: two inputs, each a pair, so we have a pair of pairs *)
      0
      (* output: the distance between (0,0) and (0,0) is 0 *) );
    (* end each case with a semicolon *)
    (* Your test cases go here *)
    (* happy path *)
    (((2, 4), (5, 6)), 5);
    (* negative numbers and negative distance if no abs *)
    (((-3, -5), (-1, -2)), 5);
    (* symmetry with the above statement *)
    (((-1, -2), (-3, -5)), 5);
  ]

(** returns the Manhattan distance between the two given points
    @param (x1,y1) the first point
    @param (x2,y2) the second point
    @return the Manhattan distance*)
let distance ((x1, y1) : int * int) ((x2, y2) : int * int) : int =
  abs (x1 - x2) + abs (y1 - y2)

(* Question 2: Binomial *)
(* TODO: Write your own tests for the binomial function.
         See the provided test for how to write test cases.
         Remember that we assume that  n >= k >= 0; you should not write test cases where this assumption is violated.
*)
let binomial_tests =
  [
    (* Your test cases go here. Correct this incorrect test case for the function. *)
    ((0, 0), 1);
    ((1, 0), 1);
    ((3, 2), 3);
    ((4, 4), 1);
    ((10, 3), 120);
    ((10, 7), 120);
  ]

(** implements the binomial operation n choose k
    @param n number of objects
    @param k sample size
    @return
      the number of possible combinasion of size []k to choose from [n] objects
*)
let binomial (n : int) (k : int) : int =
  if n < k then 0
  else
    let factorial (n : int) =
      let rec fac (n : int) (acc : int) =
        if n <= 1 then acc else fac (n - 1) (acc * n)
      in
      fac n 1
    in
    factorial n / (factorial k * factorial (n - k))

(* Question 3: Lucas Numbers *)

(* TODO: Write a good set of tests for lucas_tests. *)
let lucas_tests = [ (0, 2); (1, 1); (2, 3); (3, 4); (4, 7) ]

(** tail recursive helper to compute the lucas number sequence
    @param n the number of remaining calls to [lucas_helper]
    @param a the (n - 1)th number in the sequence
    @param b the nth number in the sequence
    @return the nth number in the sequence *)
let rec lucas_helper n a b = if n = 0 then b else lucas_helper (n - 1) b (a + b)

(** returns the nth number in the lucas number sequence *)
let lucas n = if n = 0 then 2 else if n = 1 then 1 else lucas_helper (n - 1) 2 1
