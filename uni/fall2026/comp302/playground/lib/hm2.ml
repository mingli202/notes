exception Not_implemented

exception Invalid_test_case
(** The exception raised when a test case has an input outside the domain of the
    tested function. *)

type nat = Z | S of nat

type exp =
  | Const of float
  | Var
  | Plus of exp * exp
  | Times of exp * exp
  | Div of exp * exp

(* Question 1 *)

(** tests for q1a_nat_of_int *)
let q1a_nat_of_int_tests : (int * nat) list =
  [ (0, Z); (1, S Z); (5, S (S (S (S (S Z))))) ]

(** Returns the unary representation if given ocaml integer n

    Example:
    {[
    q1a_nat_of_int 0 (* Z *);
    q1a_nat_of_int 1 (* S Z *);
    q1a_nat_of_int 5 (* S ( S ( S ( S ( S Z )))) *)
    ]} *)
let q1a_nat_of_int (n : int) : nat =
  let rec q1a_nat_of_int_helper (n : int) (acc : nat) =
    if n = 0 then acc else q1a_nat_of_int_helper (n - 1) (S acc)
  in
  q1a_nat_of_int_helper n Z

(** tests for q1b_int_of_nat *)
let q1b_int_of_nat_tests : (nat * int) list =
  [ (Z, 0); (S Z, 1); (S (S (S (S (S Z)))), 5) ]

(** Returns the ocaml integer representation of the given nat n *)
let q1b_int_of_nat (n : nat) : int =
  let rec q1b_int_of_nat_h (n : nat) (acc : int) =
    match n with Z -> acc | S rest -> q1b_int_of_nat_h rest (acc + 1)
  in
  q1b_int_of_nat_h n 0

(** tests for q1c_add *)
let q1c_add_tests : ((nat * nat) * nat) list =
  [
    ((Z, Z), Z);
    ((S Z, Z), S Z);
    ((Z, S Z), S Z);
    ((S (S Z), S (S (S (S Z)))), S (S (S (S (S (S Z))))));
  ]

(** adds the two given nat

    Example:
    {[
    q1c_add Z Z (* Z *);
    q1c_add (S Z) Z (* S Z *);
    q1c_add Z (S Z) (* S Z *);
    q1c_add (S S Z) (S S S S Z) (* S S S S S S Z *)
    ]} *)
let rec q1c_add (n : nat) (m : nat) : nat =
  match n with Z -> m | S rest -> q1c_add rest (S m)

(* Question 2 *)

(* TODO: Implement {!q2a_neg}. *)
let q2a_neg (e : exp) : exp = raise Not_implemented

(* TODO: Implement {!q2b_minus}. *)
let q2b_minus (e1 : exp) (e2 : exp) : exp = raise Not_implemented

(* TODO: Implement {!q2c_pow}. *)
let q2c_pow (e1 : exp) (p : nat) : exp = raise Not_implemented

(* Question 3 *)

(* TODO: Write a good set of tests for {!eval}. *)
let eval_tests : ((exp * float) * float) list = []

(* TODO: Implement {!eval}. *)
let rec eval (e : exp) (a : float) : float = raise Not_implemented

(* Question 4 *)

(* TODO: Write a good set of tests for {!diff_tests}. *)
let diff_tests : (exp * exp) list = []

(* TODO: Implement {!diff}. *)
let rec diff (e : exp) : exp = raise Not_implemented
