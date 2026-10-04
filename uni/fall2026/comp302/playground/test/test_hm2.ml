open Playground
open Printf
open Hm2
open Test

let nat_to_string nat =
  let rec nat_to_string_h nat s =
    match nat with S rest -> nat_to_string_h rest (sprintf "S %s" s) | Z -> s
  in
  nat_to_string_h nat "Z"

let assert_nat nat1 nat2 = Assert.assert_to_string nat1 nat2 nat_to_string
let assert_exp e1 e2 = Assert.assert_to_string e1 e2 exp_to_string

let run_hm_tests (t : T.t) =
  T.test_list t "int to unary" q1a_nat_of_int_tests (fun (inp, exp) ->
      assert_nat (q1a_nat_of_int inp) exp);

  T.test_list t "unary to int" q1b_int_of_nat_tests (fun (inp, exp) ->
      Assert.assert_int (q1b_int_of_nat inp) exp);

  T.test_list t "unary add" q1c_add_tests (fun ((in1, in2), exp) ->
      assert_nat (q1c_add in1 in2) exp);

  T.test_list t "test neg" Hm2.q2a_neg_tests (fun (inp, exp) ->
      assert_exp (Hm2.q2a_neg inp) exp);

  T.test_list t "test minus" Hm2.q2b_minus_tests (fun ((inp1, inp2), exp) ->
      assert_exp (Hm2.q2b_minus inp1 inp2) exp);

  T.test_list t "test pow" Hm2.q2c_pow_tests (fun ((inp1, inp2), exp) ->
      assert_exp (Hm2.q2c_pow inp1 inp2) exp);

  T.test_list t "test eval" Hm2.eval_tests (fun ((inp1, inp2), exp) ->
      Assert.assert_float (Hm2.eval inp1 inp2) exp);

  T.test_list t "test diff" Hm2.diff_tests (fun (inp1, exp) ->
      assert_exp (Hm2.diff inp1) exp)

let run_parse_eq_cont (t : T.t) =
  T.test_list t "parse simple operations with cont"
    [
      ("1", Const 1.0);
      ("10 + 5", Plus (Const 10.0, Const 5.0));
      ("10 - 5", Plus (Const 10.0, Times (Const (-1.0), Const 5.0)));
      ("10*5", Times (Const 10.0, Const 5.0));
      ("10 / 5", Div (Const 10.0, Const 5.0));
      ("10 + 5 + 6", Plus (Plus (Const 10.0, Const 5.0), Const 6.0));
      ( "10 + 5 - 6",
        Plus (Plus (Const 10.0, Const 5.0), Times (Const (-1.0), Const 6.0)) );
      ("10 + 5 * 6", Plus (Const 10.0, Times (Const 5.0, Const 6.0)));
      ("10 * 5 + 6", Plus (Times (Const 10.0, Const 5.0), Const 6.0));
      ("10 / 5 + 6", Plus (Div (Const 10.0, Const 5.0), Const 6.0));
      ("10 * 5 / 2", Div (Times (Const 10.0, Const 5.0), Const 2.0));
      ( "1 * 2 + 4 + 3",
        Plus (Plus (Times (Const 1.0, Const 2.0), Const 4.0), Const 3.0) );
      ( "1 + 2 / 4 * 3 * 5",
        Plus
          ( Const 1.0,
            Times (Times (Div (Const 2.0, Const 4.0), Const 3.0), Const 5.0) )
      );
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
      ( "2 * x - x / 3 + 10",
        Plus
          ( Plus
              ( Times (Const 2.0, Var),
                Times (Const (-1.0), Div (Var, Const 3.0)) ),
            Const 10.0 ) );
    ]
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) exp);

  T.test_list t "parse parenthesis with cont"
    [
      ("(10 + 5) * 2", Times (Plus (Const 10.0, Const 5.0), Const 2.0));
      ( "(10 - 5) * 2",
        Times (Plus (Const 10.0, Times (Const (-1.0), Const 5.0)), Const 2.0) );
      ( "1 + 2 + 3 + (4 * 2)",
        Plus
          ( Plus (Plus (Const 1.0, Const 2.0), Const 3.0),
            Times (Const 4.0, Const 2.0) ) );
      ("(10 / 5) * 2", Times (Div (Const 10.0, Const 5.0), Const 2.0));
      ("(10 * (5 / 2)", Times (Const 10.0, Div (Const 5.0, Const 2.0)));
      ( "7 * 10 * (5 / 2)",
        Times (Times (Const 7.0, Const 10.0), Div (Const 5.0, Const 2.0)) );
      ( "(10 + 5) * (5 / 2)",
        Times (Plus (Const 10.0, Const 5.0), Div (Const 5.0, Const 2.0)) );
      ( "10 * (1 + (3 * 4))",
        Times (Const 10.0, Plus (Const 1.0, Times (Const 3.0, Const 4.0))) );
    ]
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) exp);

  T.test_list t "parse variable with cont"
    [
      ("x", Var);
      ("10 * x", Times (Const 10.0, Var));
      ("10 * x * 90", Times (Times (Const 10.0, Var), Const 90.0));
    ]
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) exp);

  T.test_list t "parse 10 * (x + 5) with cont" [ "10 * (x + 5)" ] (fun inp ->
      assert_exp (Hm2.parse_eq inp) (Times (Const 10.0, Plus (Var, Const 5.0))));

  T.test_list t "first negative"
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
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) exp);

  T.test_eq_a t "parse many parenthesis"
    (parse_eq "(1 + 2) * ((3 + 4) * ((5 + 6) * 7))")
    (Times
       ( Plus (Const 1.0, Const 2.0),
         Times
           ( Plus (Const 3.0, Const 4.0),
             Times (Plus (Const 5.0, Const 6.0), Const 7.0) ) ))
    assert_exp;

  T.test_eq_a t "parse pow result"
    (parse_eq "(2 + 5) * ((2 + 5) * ((2 + 5) * 1))")
    (Times
       ( Plus (Const 2.0, Const 5.0),
         Times
           ( Plus (Const 2.0, Const 5.0),
             Times (Plus (Const 2.0, Const 5.0), Const 1.0) ) ))
    assert_exp;

  T.test_list t "parse pow operator"
    [
      ("2 ^ 4", "2 * (2 * (2 * (2 * 1)))");
      ("1 * 2 ^ 4 + 4", "(1 * (2 * (2 * (2 * (2 * 1)))) + 4)");
      ("(2 + 5) ^ 3", "(2 + 5) * ((2 + 5) * ((2 + 5) * 1))");
    ]
    (fun (inp, exp) -> assert_exp (Hm2.parse_eq inp) (Hm2.parse_eq exp))

let run (t : T.t) =
  T.branch t "parse eq with cont" run_parse_eq_cont;
  run_hm_tests t
