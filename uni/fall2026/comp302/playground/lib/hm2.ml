exception Not_implemented

exception Invalid_test_case
(** The exception raised when a test case has an input outside the domain of the
    tested function. *)

exception Invalid_token of string
exception Invalid_exp of string

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

(** split the given string into a list of char *)
let string_split (s : string) : char list =
  let rec string_split_h (s : string) (i : int) =
    if i = String.length s then [] else s.[i] :: string_split_h s (i + 1)
  in
  string_split_h s 0

(** Finds a string of numbers and return the rest of the string to parse *)
let rec find_number (s : char list) : string * char list =
  match s with
  | (('0' .. '9' | '.') as c) :: rest ->
      let rest_of_n, final_rest = find_number rest in
      (String.of_char c ^ rest_of_n, final_rest)
  | _ -> ("", s)

(** finds the number and return the rest of the string to parse

    Example:
    {[
    (* (Const 123.1) [] *)
    parse_number "123.1";

    (* (Const 123.1) [" ", "+", " ", "x"] *)
    parse_number "123.1 + x"
    ]} *)
let parse_number (s : char list) : exp * char list =
  let str_n, rest = find_number s in
  try (Const (float_of_string str_n), rest)
  with _ ->
    raise
      (Invalid_exp
         (Printf.sprintf "the number found could not be parsed: %s" str_n))

let rec parse_eq_first (s : char list) : exp =
  let rec parse_eq_list (s : char list) (acc : exp) : exp =
    match s with
    | '(' :: r -> parse_eq_list r acc
    | ')' :: r -> Var
    | 'x' :: r -> Var
    | '*' :: r -> Times (acc, parse_eq_first r)
    | '/' :: r -> Times (acc, parse_eq_first r)
    | '+' :: r -> Plus (acc, parse_eq_first r)
    | '-' :: r -> Plus (acc, parse_eq_first r)
    | ('0' .. '9' | '.') :: _ ->
        let e, rest = parse_number s in
        parse_eq_list rest e
    | ' ' :: r -> parse_eq_list r acc
    | _ -> raise (Invalid_token "unknown token")
  in

  match s with
  | '(' :: rest -> parse_eq_first rest
  | ')' :: rest -> raise (Invalid_token "cannot start with ')'")
  | 'x' :: rest -> parse_eq_list rest Var
  | '*' :: rest -> raise (Invalid_token "cannot start with '*'")
  | '/' :: rest -> raise (Invalid_token "cannot start with '/'")
  | '+' :: rest -> raise (Invalid_token "cannot start with '+'")
  | '-' :: rest -> raise (Invalid_token "cannot start with '-'")
  | ('0' .. '9' | '.') :: _ ->
      let e, rest = parse_number s in
      parse_eq_list rest e
  | ' ' :: s -> parse_eq_first s
  | _ -> raise (Invalid_token "unknown token")

(** parse the equation string into an exp so I can feed it to tests without
    having to write out the chain of exp

    Example:
    {[
    (* Const 1 *)
    parse_eq "1";

    (* Const 12 *)
    parse_eq "12";
    parse_eq "12.";
    parse_eq "12.0";

    (* Const 12.5 *)
    parse_eq "12.5";

    (* Times (Const 10, Var) *)
    parse_eq "10x";

    (* Plus (Times (Const 10, Var), Const 5) *)
    parse_eq "10x + 5";

    (* Plus (Times (Const 10, Var), Const 5) *)
    parse_eq "10(x + 5)";
    parse_eq "10(x + 5";
    parse_eq "10 * (x + 5)";
    parse_eq "(2 + 8) * (x + 5)";
    parse_eq "(2 * 5) * (x + 5)"
    ]} *)
let parse_eq (s : string) : exp = parse_eq_first (string_split s)

(** negate the given expression e, but don't resolve the parathensis

    Example:

    {[
    q2a_neg 1 (* -(1) *);
    q2a_neg (2x + 1) (* 2x + 1 *);
    q2a_neg (3x - 2 - 5 (x + 1))
    (* -(3x - 2 - 5 (x + 1)) *)
    ]} *)
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
