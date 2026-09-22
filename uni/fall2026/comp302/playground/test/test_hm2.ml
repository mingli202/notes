open Playground
open Printf
open Hm2

let nat_to_string nat =
  let rec nat_to_string_h nat s =
    match nat with S rest -> nat_to_string_h rest (sprintf "S %s" s) | Z -> s
  in
  nat_to_string_h nat "Z"

let assert_nat nat1 nat2 = Assert.assert_to_string nat1 nat2 nat_to_string
let assert_exp e1 e2 = Assert.assert_to_string e1 e2 exp_to_string

let run =
 fun () ->
  Test.test_list q1a_nat_of_int_tests "int to unary" (fun (inp, exp) ->
      assert_nat (q1a_nat_of_int inp) exp);

  Test.test_list q1b_int_of_nat_tests "unary to int" (fun (inp, exp) ->
      Assert.assert_int (q1b_int_of_nat inp) exp);

  Test.test_list q1c_add_tests "unary add" (fun ((in1, in2), exp) ->
      assert_nat (q1c_add in1 in2) exp);

  Test.test_eq "string_split" (string_split "23 .40*")
    [ '2'; '3'; ' '; '.'; '4'; '0'; '*' ];

  Test.test_list
    [
      ("1", 1.0);
      ("123.4", 123.4);
      ("023.4", 23.4);
      ("023.40", 23.4);
      ("23 .40 ", 23.0);
      ("23 .40*", 23.0);
      (".98", 0.98);
    ]
    "parse number"
    (fun (inp, exp) -> assert_exp (fst (parse_number inp 0)) (Const exp));

  Test.test "parse number with rest" (fun () ->
      let e, rest = parse_number "12.0 * 3" 0 in
      Assert.assert_int rest 4;
      assert_exp e (Const 12.0));

  Test.test_list
    [
      ("1", Const 1.0);
      ("10 + 5", Plus (Const 10.0, Const 5.0));
      ("10*5", Times (Const 10.0, Const 5.0));
      ("10 / 5", Div (Const 10.0, Const 5.0));
      ( "10 + 5 - 6",
        Plus (Const 10.0, Plus (Const 5.0, Times (Const (-1.0), Const 6.0))) );
      ("10 + 5 * 6", Plus (Const 10.0, Times (Const 5.0, Const 6.0)));
      ("10 * 5 + 6", Plus (Times (Const 10.0, Const 5.0), Const 6.0));
      ("10 / 5 + 6", Plus (Div (Const 10.0, Const 5.0), Const 6.0));
      ("10 * 5 / 2", Div (Times (Const 10.0, Const 5.0), Const 2.0));
      ( "1 * 2 / 4 + 1",
        Plus (Div (Times (Const 1.0, Const 2.0), Const 4.0), Const 1.0) );
      ( "1 * 2 - 4 / 2",
        Plus
          ( Times (Const 1.0, Const 2.0),
            Times (Const (-1.0), Div (Const 4.0, Const 2.0)) ) );
      ( "1 * 2 * 5.3 - 4 / 2",
        Plus
          ( Times (Times (Const 1.0, Const 2.0), Const 5.3),
            Times (Const (-1.0), Div (Const 4.0, Const 2.0)) ) );
    ]
    "parse simple operations"
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) exp);

  Test.test_list
    [
      ("(10 + 5) * 2", Times (Plus (Const 10.0, Const 5.0), Const 2.0));
      ( "(10 - 5) * 2",
        Times (Plus (Const 10.0, Times (Const (-1.0), Const 5.0)), Const 2.0) );
      ("(10 / 5) * 2", Times (Div (Const 10.0, Const 5.0), Const 2.0));
      ("(10 * (5 / 2)", Times (Const 10.0, Div (Const 5.0, Const 2.0)));
      ( "(10 + 5) * (5 / 2)",
        Times (Plus (Const 10.0, Const 5.0), Div (Const 5.0, Const 2.0)) );
      ( "10 * (1 + (3 * 4))",
        Times (Const 10.0, Plus (Const 1.0, Times (Const 3.0, Const 4.0))) );
    ]
    "parse parenthesis"
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) exp);

  Test.test_list
    [
      ("x", Var);
      ("10 * x", Times (Const 10.0, Var));
      ("10 * x * 90", Times (Times (Const 10.0, Var), Const 90.0));
    ]
    "parse variable"
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) exp);

  Test.test_list [ "10 * (x + 5)"; "10 * (x + 5" ] "parse 10 * (x + 5)"
    (fun inp ->
      assert_exp (Hm2.parse_eq inp) (Times (Const 10.0, Plus (Var, Const 5.0))));

  Test.test_list
    [
      ("-1", Times (Const (-1.0), Const 1.0));
      ("-(1 + 2)", Times (Const (-1.0), Plus (Const 1.0, Const 2.0)));
      ( "-(1 + -2)",
        Times (Const (-1.0), Plus (Const 1.0, Times (Const (-1.0), Const 2.0)))
      );
      ( "-1 + -2)",
        Plus (Times (Const (-1.0), Const 1.0), Times (Const (-1.0), Const 2.0))
      );
      ( "-1 - -2)",
        Plus
          ( Times (Const (-1.0), Const 1.0),
            Times (Const (-1.0), Times (Const (-1.0), Const 2.0)) ) );
    ]
    "first negative"
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) exp);

  Test.test_list Hm2.q2a_neg_tests "test neg" (fun (inp, exp) ->
      assert_exp (Hm2.q2a_neg inp) exp);

  Test.test_list Hm2.q2b_minus_tests "test minus" (fun ((inp1, inp2), exp) ->
      assert_exp (Hm2.q2b_minus inp1 inp2) exp);

  Test.test_list Hm2.q2c_pow_tests "test pow" (fun ((inp1, inp2), exp) ->
      assert_exp (Hm2.q2c_pow inp1 inp2) exp)
