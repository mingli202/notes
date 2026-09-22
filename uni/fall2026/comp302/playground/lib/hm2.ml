open Printf

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

let rec exp_to_string exp =
  match exp with
  | Const value -> sprintf "%f" value
  | Var -> "x"
  | Plus (exp1, exp2) ->
      sprintf "(%s + %s)" (exp_to_string exp1) (exp_to_string exp2)
  | Times (exp1, exp2) ->
      sprintf "(%s * %s)" (exp_to_string exp1) (exp_to_string exp2)
  | Div (exp1, exp2) ->
      sprintf "(%s / %s)" (exp_to_string exp1) (exp_to_string exp2)

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
let rec find_number (s : string) (i : int) : string * int =
  if i = String.length s then ("", i)
  else
    match s.[i] with
    | ('0' .. '9' | '.') as c ->
        let rest_of_n, final_rest = find_number s (i + 1) in
        (String.of_char c ^ rest_of_n, final_rest)
    | _ -> ("", i)

(** finds the number and return the index to the rest of the string to parse

    Example:
    {[
    (* (Const 123.1) 5 *)
    parse_number "123.1";

    (* (Const 123.1) 5 *)
    parse_number "123.1 + x"
    ]} *)
let parse_number (s : string) (i : int) : exp * int =
  let str_n, rest = find_number s i in
  try (Const (float_of_string str_n), rest)
  with _ ->
    raise
      (Invalid_exp
         (Printf.sprintf "the number found could not be parsed: %s" str_n))

type op = TimesOp | DivOpt

(** parses the string of equation while carrying the previous expression

    [parse_times_and_div] handles the times and divisions. these two operations
    have a higher priority than plus and minus, we want to evaluate the longest
    string of times/div or higher first before returning to the original
    parse_eq_acc so that we can ensure the higher priority operations get
    computed first

    Example:
    {[
    (* Div (Const 4, Times (Const 1, Const 2)) 10 *)
    parse_times_and_div "1 * 2 / 4 + 1"
    ]} *)
let rec parse_eq_acc (s : string) (i : int) (prev : exp option) : exp * int =
  let rec parse_times_and_div (s : string) (i : int) (prev : exp option)
      (op : op) : exp * int =
    if String.length s = 0 then raise (Invalid_exp "empty exp")
    else if i >= String.length s then (Option.get prev, i)
    else
      match s.[i] with
      | '0' .. '9' | '.' ->
          let e, rest_i = parse_number s i in
          let op_exp =
            match op with
            | TimesOp -> Times (Option.get prev, e)
            | DivOpt -> Div (Option.get prev, e)
          in
          parse_times_and_div s rest_i (Some op_exp) op
      | 'x' ->
          let op_exp =
            match op with
            | TimesOp -> Times (Option.get prev, Var)
            | DivOpt -> Div (Option.get prev, Var)
          in
          parse_times_and_div s (i + 1) (Some op_exp) op
      | '(' ->
          let e, rest_i = parse_eq_acc s (i + 1) None in
          let op_exp =
            match op with
            | TimesOp -> Times (Option.get prev, e)
            | DivOpt -> Div (Option.get prev, e)
          in
          parse_times_and_div s rest_i (Some op_exp) op
      | ')' -> (Option.get prev, i + 1)
      | '*' -> parse_times_and_div s (i + 1) prev TimesOp
      | '/' -> parse_times_and_div s (i + 1) prev DivOpt
      | ' ' -> parse_times_and_div s (i + 1) prev op
      | _ -> (Option.get prev, i)
  in

  if String.length s = 0 then raise (Invalid_exp "empty exp")
  else if i >= String.length s then (Option.get prev, i)
  else
    match s.[i] with
    | '0' .. '9' | '.' ->
        let e, rest_i = parse_number s i in
        parse_eq_acc s rest_i (Some e)
    | '(' ->
        let e, rest_i = parse_eq_acc s (i + 1) None in
        parse_eq_acc s rest_i (Some e)
    | ')' -> (Option.get prev, i + 1)
    | 'x' -> parse_eq_acc s (i + 1) (Some Var)
    | '*' ->
        let e, rest_i = parse_times_and_div s i prev TimesOp in
        parse_eq_acc s rest_i (Some e)
    | '/' ->
        let e, rest_i = parse_times_and_div s i prev DivOpt in
        parse_eq_acc s rest_i (Some e)
    | '+' ->
        let e, rest_i = parse_eq_acc s (i + 1) None in
        (Plus (Option.get prev, e), rest_i)
    | '-' -> (
        match prev with
        | None ->
            let e, rest_i =
              parse_times_and_div s (i + 1) (Some (Const (-1.0))) TimesOp
            in
            parse_eq_acc s rest_i (Some e)
        | Some prev_e ->
            let e, rest_i = parse_eq_acc s (i + 1) None in
            (Plus (prev_e, Times (Const (-1.0), e)), rest_i))
    | ' ' -> parse_eq_acc s (i + 1) prev
    | c -> raise (Invalid_token (Printf.sprintf "unknown token %c" c))

(** parse the equation string into an exp so I can feed it to tests without
    having to write out the chain of exp. also, multiplications and divisions
    are grouped from left to right. however, additions and substractions are
    grouped from right to left since substractions gets converted into addition
    of (-1 * exp), there is no need to group as the order doesn't matter.

    All of these cases are happy path, I don't really want to spend time
    detecting every edge cases and wrong inputs.

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
    parse_eq "10 * x + 5";

    (* Plus (Times (Const 10, Var), Const 5) *)
    parse_eq "10 * (x + 5)";
    parse_eq "10 * (x + 5";

    (* it will not collapse 2 + 8 since *)
    parse_eq "(2 + 8) * (x + 5)";
    parse_eq "(2 * 5) * (x + 5)"
    ]} *)
let parse_eq (s : string) : exp = fst (parse_eq_acc s 0 None)

let q2a_neg_tests =
  List.map
    (fun (a, b) -> (parse_eq a, parse_eq b))
    [
      ("1", "-1");
      ("2 * x + 1", "-(2 * x + 1)");
      ("3 * x - 2 - (5 * x + 1)", "-(3 * x - 2 - (5 * x + 1))");
    ]

(** negate the given expression e, but don't resolve the parathensis.

    Example:

    {[
    q2a_neg 1 (* -1 *);
    q2a_neg ((2 * x) + 1) (* -(2 * x + 1) *);
    q2a_neg ((3 * x) - 2 - (5 * (x + 1)))
    (* -(3x - 2 - 5 * (x + 1)) *)
    ]} *)
let q2a_neg (e : exp) : exp = Times (Const (-1.0), e)

let q2b_minus_tests =
  List.map
    (fun ((a, b), c) -> ((parse_eq a, parse_eq b), parse_eq c))
    [
      (("1", "2"), "1 - 2");
      (("1", "x"), "1 - x");
      (("1", "3 * 5"), "1 - (3 * 5)");
      (("3 * 5", "1"), "(3 * 5) - 1");
    ]

(** returns the substraction of e2 to e1

    Example:

    {[
    q2b_minus 1 2 (* 1 - 2 *);
    q2b_minus 1 x (* 1 - x *);
    q2b_minus 1 (3 * 5) (* 1 - (3 * 5) *);
    q2b_minus (3 * 5) 1 (* (3 * 5) - 1 *)
    ]} *)
let q2b_minus (e1 : exp) (e2 : exp) : exp = Plus (e1, q2a_neg e2)

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
