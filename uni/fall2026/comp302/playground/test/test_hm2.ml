open Playground
open Printf

let nat_to_string nat =
  let rec nat_to_string_h nat s =
    match nat with
    | Hm2.S rest -> nat_to_string_h rest (sprintf "S %s" s)
    | Hm2.Z -> s
  in
  nat_to_string_h nat "Z"

let assert_nat nat1 nat2 = Assert.assert_to_string nat1 nat2 nat_to_string

let rec exp_to_string exp =
  match exp with
  | Hm2.Const value -> sprintf "%f" value
  | Hm2.Var -> sprintf "%s" "x"
  | Hm2.Plus (exp1, exp2) ->
      sprintf "%s + %s" (exp_to_string exp1) (exp_to_string exp2)
  | Hm2.Times (exp1, exp2) ->
      sprintf "%s * %s" (exp_to_string exp1) (exp_to_string exp2)
  | Hm2.Div (exp1, exp2) ->
      sprintf "%s / %s" (exp_to_string exp1) (exp_to_string exp2)

let assert_exp e1 e2 = Assert.assert_to_string e1 e2 exp_to_string

let run =
 fun () ->
  Test.test_list Hm2.q1a_nat_of_int_tests "int to unary" (fun (inp, exp) ->
      assert_nat (Hm2.q1a_nat_of_int inp) exp);

  Test.test_list Hm2.q1b_int_of_nat_tests "unary to int" (fun (inp, exp) ->
      Assert.assert_int (Hm2.q1b_int_of_nat inp) exp);

  Test.test_list Hm2.q1c_add_tests "unary add" (fun ((in1, in2), exp) ->
      assert_nat (Hm2.q1c_add in1 in2) exp);

  Test.test_list
    [
      ([ '1' ], 1.0);
      ([ '1'; '2'; '3'; '.'; '4' ], 123.4);
      ([ '0'; '2'; '3'; '.'; '4' ], 23.4);
      ([ '0'; '2'; '3'; '.'; '4'; '0' ], 23.4);
      ([ '2'; '3'; ' '; '.'; '4'; '0'; ' ' ], 23.0);
    ]
    "parse number"
    (fun (inp, exp) -> assert_exp (fst (Hm2.parse_number inp)) (Hm2.Const exp))
