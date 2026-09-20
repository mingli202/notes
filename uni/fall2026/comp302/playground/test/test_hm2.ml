open Playground
open Printf
open Hm2

let nat_to_string nat =
  let rec nat_to_string_h nat s =
    match nat with S rest -> nat_to_string_h rest (sprintf "S %s" s) | Z -> s
  in
  nat_to_string_h nat "Z"

let assert_nat nat1 nat2 = Assert.assert_to_string nat1 nat2 nat_to_string

let rec exp_to_string exp =
  match exp with
  | Const value -> sprintf "%f" value
  | Var -> sprintf "%s" "x"
  | Plus (exp1, exp2) ->
      sprintf "%s + %s" (exp_to_string exp1) (exp_to_string exp2)
  | Times (exp1, exp2) ->
      sprintf "%s * %s" (exp_to_string exp1) (exp_to_string exp2)
  | Div (exp1, exp2) ->
      sprintf "%s / %s" (exp_to_string exp1) (exp_to_string exp2)

let assert_exp e1 e2 = Assert.assert_to_string e1 e2 exp_to_string

let run =
 fun () ->
  Test.test_list q1a_nat_of_int_tests "int to unary" (fun (inp, exp) ->
      assert_nat (q1a_nat_of_int inp) exp);

  Test.test_list q1b_int_of_nat_tests "unary to int" (fun (inp, exp) ->
      Assert.assert_int (q1b_int_of_nat inp) exp);

  Test.test_list q1c_add_tests "unary add" (fun ((in1, in2), exp) ->
      assert_nat (q1c_add in1 in2) exp);

  Test.test_list
    [
      ([ '1' ], 1.0);
      ([ '1'; '2'; '3'; '.'; '4' ], 123.4);
      ([ '0'; '2'; '3'; '.'; '4' ], 23.4);
      ([ '0'; '2'; '3'; '.'; '4'; '0' ], 23.4);
      ([ '2'; '3'; ' '; '.'; '4'; '0'; ' ' ], 23.0);
    ]
    "parse number"
    (fun (inp, exp) -> assert_exp (fst (parse_number inp)) (Const exp));

  Test.test_list
    [
      (string_split "1", Const 1.0);
      (string_split "10 + 5", Plus (Const 10.0, Const 5.0));
      (string_split "10*5", Times (Const 10.0, Const 5.0));
      (string_split "10 / 5", Div (Const 10.0, Const 5.0));
      ( string_split "10 + 5 - 6",
        Plus (Const 10.0, Plus (Const 5.0, Times (Const (-1.0), Const 6.0))) );
      ( string_split "10 + 5 * 6",
        Plus (Const 10.0, Times (Const 5.0, Const 6.0)) );
    ]
    "parse operations"
    (fun (inp, exp) -> assert_exp (fst (Hm2.parse_number inp)) exp)
