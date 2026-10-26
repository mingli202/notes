open Test
open Playground
open Hm5
open Printf

let formula_to_string f =
  let rec formula_to_string_h f cont =
    match f with
    | Variable var -> cont var
    | Conjunction (l, r) ->
        formula_to_string_h l (fun l_str ->
            formula_to_string_h r (fun r_str ->
                cont (sprintf "(%s & %s)" l_str r_str)))
    | Disjunction (l, r) ->
        formula_to_string_h l (fun l_str ->
            formula_to_string_h r (fun r_str ->
                cont (sprintf "(%s | %s)" l_str r_str)))
    | Negation f ->
        formula_to_string_h f (fun f_str -> cont (sprintf "(~%s)" f_str))
  in
  formula_to_string_h f (fun x -> x)

let assert_formula fa fb = Assert.assert_to_string fa fb formula_to_string

let run t =
  T.test_list t "formula_to_string"
    [
      (Conjunction (Variable "x", Variable "y"), "(x & y)");
      ( Conjunction
          (Disjunction (Variable "x", Variable "y"), Negation (Variable "z")),
        "((x | y) & (~z))" );
      (Negation (Negation (Negation (Variable "x"))), "(~(~(~x)))");
      ( Conjunction (Variable "y", Negation (Negation (Negation (Variable "x")))),
        "(y & (~(~(~x))))" );
    ]
    (fun (a, b) -> Assert.assert_string (formula_to_string a) b);

  T.test_list t "parse formula"
    [
      ("x", Variable "x");
      ("~x", Negation (Variable "x"));
      ("x | y", Disjunction (Variable "x", Variable "y"));
      ( "x | y & z",
        Disjunction (Variable "x", Conjunction (Variable "y", Variable "z")) );
      ("x | ~y", Disjunction (Variable "x", Negation (Variable "y")));
      ("~x | y", Disjunction (Negation (Variable "x"), Variable "y"));
      ( "x | ~~~y",
        Disjunction (Variable "x", Negation (Negation (Negation (Variable "y"))))
      );
      ( "x | ~~~y & z",
        Conjunction
          ( Disjunction
              (Variable "x", Negation (Negation (Negation (Variable "y")))),
            Variable "z" ) );
    ]
    (fun (a, b) -> assert_formula (parse_formula a) b);

  T.test_list t "collect_variables"
    [
      ("x", [ "x" ]);
      ("x | y", [ "x"; "y" ]);
      ("~x | y | x & y & z | u & a & u", [ "x"; "y"; "z"; "u"; "a" ]);
    ]
    (fun (a, b) ->
      Assert.assert_arr
        (collect_variables (parse_formula a))
        (List.sort compare b)
        (fun x -> x));

  T.test_list t "eval"
    [
      ("x", Variable_map.empty |> Variable_map.add "x" true, true);
      ("~x", Variable_map.empty |> Variable_map.add "x" false, true);
      ("x", Variable_map.empty |> Variable_map.add "x" false, false);
      ( "x | y",
        Variable_map.empty |> Variable_map.add "x" false
        |> Variable_map.add "y" true,
        true );
      ( "x & y",
        Variable_map.empty |> Variable_map.add "x" false
        |> Variable_map.add "y" true,
        false );
      ( "x & y",
        Variable_map.empty |> Variable_map.add "x" true
        |> Variable_map.add "y" true,
        true );
      ( "x & y & ~z | z | p & q",
        Variable_map.empty |> Variable_map.add "x" true
        |> Variable_map.add "y" true |> Variable_map.add "z" true
        |> Variable_map.add "p" true |> Variable_map.add "q" true,
        true );
    ]
    (fun (f_str, ass, res) ->
      Assert.assert_bool (eval ass (parse_formula f_str)) res)
