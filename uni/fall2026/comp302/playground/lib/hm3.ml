(* The code here will be added to the top of your code automatically.
   You do NOT need to copy it into your code if you use LearnOCaml.
*)

exception NotImplemented

let domain () =
  failwith "REMINDER: You should not be writing tests for undefined values."

type 'b church = ('b -> 'b) -> 'b -> 'b

let zero : 'b church = fun s z -> z
let one : 'b church = fun s z -> s z
let two : 'b church = fun s z -> s (s z)

(* Hi everyone. All of these problems are generally "one-liners" and have slick solutions. They're quite cute to think
   about but are certainly confusing without the appropriate time and experience that you devote towards reasoning about
   this style. Good luck! :-) *)

(* For example, if you wanted to use the encoding of five in your test cases, you could define: *)
let five : 'b church = fun s z -> s (s (s (s (s z))))
(* and use 'five' like a constant. You could also just use
   'fun z s -> s (s (s (s (s z))))' directly in the test cases too. *)

(* If you define a personal helper function like int_to_church, use it for your test cases, and see things break, you should
   suspect it and consider hard coding the input cases instead *)

let int_to_church (n : int) : 'b church =
 fun s z ->
  let rec apply_s n' = if n' = 0 then z else s (apply_s (n' - 1)) in
  apply_s n

let six s z = int_to_church 6 s z
let ten s z = int_to_church 10 s z
let eleven s z = int_to_church 11 s z
let fifteen s z = int_to_church 15 s z

(*---------------------------------------------------------------*)
(* QUESTION 1 *)

(* Question 1a: Church numeral to integer *)

(** tests for to_int *)
let to_int_tests : (int church * int) list =
  List.map (fun a -> (int_to_church a, a)) [ 0; 1; 3; 5; 7; 10; 12 ]

(** converts a int church to an Ocaml int *)
let to_int (n : int church) : int = n (fun x -> x + 1) 0

(* Question 1b: Determine if a church numeral is zero *)

(** tests for is_zero *)
let is_zero_tests : ('b church * bool) list =
  [
    (zero, true);
    (one, false);
    (two, false);
    (five, false);
    (ten, false);
    (fifteen, false);
  ]

(** whether the given n is zero *)
let is_zero (n : 'b church) : bool = n (fun x -> false) true

(* Question 1c: Add two church numerals *)

(** test casese for add*)
let add_tests : (('b church * 'b church) * 'b church) list =
  [
    ((zero, zero), zero);
    ((zero, one), one);
    ((one, five), six);
    ((five, one), six);
    ((five, five), ten);
    ((five, six), eleven);
  ]

(** adds the two given church *)
let add (n1 : 'b church) (n2 : 'b church) : 'b church = fun s z -> n1 s (n2 s z)

(*---------------------------------------------------------------*)
(* QUESTION 2 *)

(* Question 2a: Multiply two church numerals *)

(** tests for mult *)
let mult_tests : (('b church * 'b church) * 'b church) list =
  [
    ((zero, zero), zero);
    ((zero, one), zero);
    ((one, two), two);
    ((two, five), ten);
    ((five, two), ten);
  ]

(** multiply the two given n1 and n2 *)
let mult (n1 : 'b church) (n2 : 'b church) : 'b church =
 fun s z -> n1 (fun x -> n2 s x) z

(* Question 2b: Compute the power of a church numeral given an int as the power *)

(** test cases for int_pow_church *)
let int_pow_church_tests : ((int * 'b church) * int) list =
  [
    ((1, zero), 1);
    ((0, zero), 1);
    ((2, zero), 1);
    ((2, one), 2);
    ((2, two), 4);
    ((2, five), 32);
  ]

(** raise x to the power of n *)
let int_pow_church (x : int) (n : 'b church) : int = n (fun y -> y * x) 1
