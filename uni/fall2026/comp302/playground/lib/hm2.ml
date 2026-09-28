open Printf

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

let rec exp_to_string exp =
  match exp with
  | Const value -> string_of_float value
  | Var -> "x"
  | Plus (exp1, exp2) ->
      sprintf "(%s + %s)" (exp_to_string exp1) (exp_to_string exp2)
  | Times (exp1, exp2) ->
      sprintf "(%s * %s)" (exp_to_string exp1) (exp_to_string exp2)
  | Div (exp1, exp2) ->
      sprintf "(%s / %s)" (exp_to_string exp1) (exp_to_string exp2)

let exp_to_string_cont exp =
  let rec exp_to_string_cont_h exp ret =
    match exp with
    | Const value -> ret (string_of_float value)
    | Var -> ret "x"
    | Plus (exp1, exp2) ->
        exp_to_string_cont_h exp1 (fun a ->
            exp_to_string_cont_h exp2 (fun b -> ret (sprintf "(%s + %s)" a b)))
    | Times (exp1, exp2) ->
        exp_to_string_cont_h exp1 (fun a ->
            exp_to_string_cont_h exp2 (fun b -> ret (sprintf "(%s * %s)" a b)))
    | Div (exp1, exp2) ->
        exp_to_string_cont_h exp1 (fun a ->
            exp_to_string_cont_h exp2 (fun b -> ret (sprintf "(%s / %s)" a b)))
  in
  exp_to_string_cont_h exp (fun k -> k)

(* Question 1 *)

exception Invalid_token of string
exception Invalid_exp of string

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

let of_char c =
  match c with
  | '0' -> "0"
  | '1' -> "1"
  | '2' -> "2"
  | '3' -> "3"
  | '4' -> "4"
  | '5' -> "5"
  | '6' -> "6"
  | '7' -> "7"
  | '8' -> "8"
  | '9' -> "9"
  | '.' -> "."
  | _ -> failwith "Nahhhhhh"

(** Finds a string of numbers and return the rest of the string to parse *)
let rec find_number (s : string) (i : int) : string * int =
  if i = String.length s then ("", i)
  else
    match s.[i] with
    | ('0' .. '9' | '.') as c ->
        let rest_of_n, final_rest = find_number s (i + 1) in
        (of_char c ^ rest_of_n, final_rest)
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

type optType =
  | NegationOpType
  | ExponentOpType
  | TimesOpType
  | DivOpType
  | MinusOpType
  | AddOpType
  | None

type importance = Less | Equal | More

let priority op_type =
  match op_type with
  | NegationOpType -> 4
  | ExponentOpType -> 3
  | TimesOpType -> 2
  | DivOpType -> 2
  | AddOpType -> 1
  | MinusOpType -> 1
  | None -> 0

let importance_fn a b =
  match priority a - priority b with
  | n when n < 0 -> Less
  | n when n > 0 -> More
  | _ -> Equal

(** importance of a relative to b *)
let comp a b =
  match (a, b) with None, _ -> Less | aa, bb -> importance_fn aa bb

let minus a b = Plus (a, Times (Const (-1.0), b))
let add a b = Plus (a, b)
let times a b = Times (a, b)
let div a b = Div (a, b)

let pow base x =
  let rec pow_h base x acc =
    if x = 0 then acc else pow_h base (x - 1) (Times (base, acc))
  in
  pow_h base x (Const 1.0)

let is_const e =
  match e with
  | Const a -> int_of_float a
  | _ -> raise (Invalid_exp "exponent must be a const")

let op_from_type op_type (a : exp option) b =
  match a with
  | None ->
      begin match op_type with
      | NegationOpType -> Times (Const (-1.0), b)
      | _ ->
          raise (Invalid_argument "did not expect to not have a previous exp")
      end
  | Some a ->
      begin match op_type with
      | NegationOpType ->
          raise
            (Invalid_argument
               "negation should not have a previous expression to compute")
      | ExponentOpType -> pow a (is_const b)
      | TimesOpType -> Times (a, b)
      | DivOpType -> Div (a, b)
      | AddOpType -> Plus (a, b)
      | MinusOpType -> minus a b
      | None -> raise (Invalid_argument "no op for this argument")
      end

(** parse the equation string into an exp so I can feed it to tests without
    having to write out the chain of exp. operations are grouped from left to
    right

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

    (* it will not collapse 2 + 8 *)
    parse_eq "(2 + 8) * (x + 5)";
    parse_eq "(2 * 5) * (x + 5)"
    ]} *)
let parse_eq (s : string) : exp =
  let rec parse_eq_cont_h (s : string) (i : int) (prev_op_type : optType)
      (prev : exp option) prev_fn ret cont =
    let handle_op op_type =
      match comp prev_op_type op_type with
      | Less ->
          parse_eq_cont_h s (i + 1) op_type None
            (op_from_type op_type prev)
            (fun a -> ret (prev_fn a))
            cont
      | Equal ->
          parse_eq_cont_h s (i + 1) op_type None
            (op_from_type op_type (Some (prev_fn (Option.get prev))))
            ret cont
      | More ->
          parse_eq_cont_h s (i + 1) op_type None
            (op_from_type op_type (Some (ret (prev_fn (Option.get prev)))))
            (fun a -> a)
            cont
    in

    if String.length s = 0 then raise (Invalid_exp "empty exp")
    else if i >= String.length s then ret (prev_fn (Option.get prev))
    else
      match s.[i] with
      | '0' .. '9' | '.' ->
          let e, rest_i = parse_number s i in
          parse_eq_cont_h s rest_i prev_op_type (Some e) prev_fn ret cont
      | '(' ->
          parse_eq_cont_h s (i + 1) None None
            (fun a -> a)
            (fun a -> a)
            (fun a i ->
              parse_eq_cont_h s i prev_op_type (Some a) prev_fn ret cont)
      | ')' -> cont (ret (prev_fn (Option.get prev))) (i + 1)
      | 'x' ->
          parse_eq_cont_h s (i + 1) prev_op_type (Some Var) prev_fn ret cont
      | '^' -> handle_op ExponentOpType
      | '*' -> handle_op TimesOpType
      | '/' -> handle_op DivOpType
      | '+' -> handle_op AddOpType
      | '-' ->
          if prev = None then handle_op NegationOpType
          else handle_op MinusOpType
      | ' ' -> parse_eq_cont_h s (i + 1) prev_op_type prev prev_fn ret cont
      | c -> raise (Invalid_token (Printf.sprintf "unknown token %c" c))
  in
  parse_eq_cont_h s 0 None None (fun x -> x) (fun x -> x) (fun x i -> x)

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

let q2c_pow_tests =
  List.map
    (fun ((e, p), exp) -> ((parse_eq e, q1a_nat_of_int p), parse_eq exp))
    [
      (("2", 0), "1");
      (("2", 3), "2 * (2 * (2 * 1))");
      (("2 + 5", 3), "(2 + 5) * ((2 + 5) * ((2 + 5) * 1))");
    ]

(** returns e1 p times, right associated

    Example:
    {[
    q2c_pow 2 (Z) (* 1 *);
    q2c_pow 2 (S S S Z) (* 2 * (2 * (2 * 1)) *);
    q2c_pow (2 + 5) (S S S Z) (* (2 + 5) * ((2 + 5) * ((2 + 5) * 1)) *);
    ]} *)
let rec q2c_pow (e1 : exp) (p : nat) : exp =
  let rec q2c_pow_h (p : nat) (acc : exp) =
    match p with Z -> acc | S rest -> q2c_pow_h rest (Times (e1, acc))
  in
  q2c_pow_h p (Const 1.0)

(* Question 3 *)

(** tests for eval *)
let eval_tests : ((exp * float) * float) list =
  List.map
    (fun ((a, b), c) -> ((parse_eq a, b), c))
    [
      (("x", 2.0), 2.0);
      (("2 * x", 2.0), 4.0);
      (("2 + 4 * 5", 2.0), 22.0);
      (("2 * x - x / 3 + 10", 6.0), 20.0);
    ]

(** evaluate the given expression at the given variable x *)
let eval (e : exp) (x : float) : float =
  let rec eval_h (e : exp) (x : float) cont =
    match e with
    | Var -> cont x
    | Const l -> cont l
    | Div (l, r) -> eval_h l x (fun a -> cont (eval_h r x (fun b -> a /. b)))
    | Times (l, r) -> eval_h l x (fun a -> cont (eval_h r x (fun b -> a *. b)))
    | Plus (l, r) -> eval_h l x (fun a -> cont (eval_h r x (fun b -> a +. b)))
  in
  eval_h e x (fun a -> a)

(* Question 4 *)

(** tests for diff: one case per rule, plus composition *)
let diff_tests : (exp * exp) list =
  List.map
    (fun (a, b) -> (parse_eq a, parse_eq b))
    [
      ("2", "0");
      ("x", "1");
      ("x + 3", "1 + 0");
      ("x * 2", "1 * 2 + x * 0");
      ("2 * x + 3", "0 * x + 2 * 1 + 0");
      ("x * (x + 1)", "1 * (x + 1) + x * (1 + 0)");
      ("3 - x", "0 + (0 * x - 1)");
      ("1 / x", "(0 * x - 1 * 1) / (x * x)");
    ]

(** computes the derivative of the given expression e *)
let rec diff (e : exp) : exp =
  let rec diff_h (e : exp) cont =
    match e with
    | Var -> cont (Const 1.0)
    | Const l -> cont (Const 0.0)
    | Div (l, r) ->
        diff_h l (fun a ->
            diff_h r (fun b ->
                cont
                  (Div
                     ( Plus (Times (a, r), Times (Const (-1.0), Times (l, b))),
                       Times (r, r) ))))
    | Times (l, r) ->
        diff_h l (fun a ->
            diff_h r (fun b -> cont (Plus (Times (a, r), Times (l, b)))))
    | Plus (l, r) -> diff_h l (fun a -> diff_h r (fun b -> cont (Plus (a, b))))
  in
  diff_h e (fun a -> a)
