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
        Conjunction (Disjunction (Variable "x", Variable "y"), Variable "z") );
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
    (fun (a, b) -> assert_formula (parse_formula a) b)
