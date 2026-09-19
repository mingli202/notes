open Playground

let rec nat_eq a b =
  match (a, b) with
  | Hm2.S rest_a, Hm2.S rest_b -> nat_eq rest_a rest_b
  | Z, Z -> true
  | _, _ -> false

let nat_to_string nat =
  let rec nat_to_string_h nat s =
    match nat with
    | Hm2.S rest -> nat_to_string_h rest (Printf.sprintf "S %s" s)
    | Hm2.Z -> s
  in
  nat_to_string_h nat "Z"

let assert_nat nat1 nat2 =
  Assert.assert_to_string_pred nat1 nat2 nat_eq nat_to_string

let run =
 fun () ->
  Test.test_list Hm2.q1a_nat_of_int_tests "int to unary" (fun (inp, exp) ->
      assert_nat (Hm2.q1a_nat_of_int inp) exp)
