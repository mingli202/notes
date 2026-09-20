val test : string -> (unit -> unit) -> unit
(** tests the given function [f], fails if the function raises an error

    Example:
    {[
    (* factorial 3...SUCCESS *)
    Test.test "factorial 3" (fun () -> Assert.assert_int (Hm1.factorial 3) 6);

    (* factorial 3...FAIL: Failure("6 != 5") *)
    Test.test "factorial 3" (fun () -> Assert.assert_int (Hm1.factorial 3) 5)
    ]}

    @param title The title of the test
    @param f
      The function that is testing stuff. The test fails if the predicate raises
      an error *)

val test_list : 'a list -> string -> ('a -> unit) -> unit
(** runs a function [f] against the list of given [test_cases]

    Example:
    {[
    (*
    test binomial [0/5]...SUCCESS
    test binomial [1/5]...SUCCESS
    test binomial [2/5]...SUCCESS
    test binomial [3/5]...SUCCESS
    test binomial [4/5]...FAIL: Failure("120 != 12")
    *)
    Test.test_list Hm1.binomial_tests "test binomial" (fun ((a, b), expected) ->
        Assert.assert_int (Hm1.binomial a b) expected)
    ]}

    @param name The name of the test
    @param test_cases The list of test cases
    @param f
      The function that takes as argument a [test_case]. The test will be
      considered failed if the predicate raises an error *)

val test_eq : string -> 'a -> 'a -> unit
(** a simple equality check about whether the two given arguments are equal. It
    will not tell you the result of either. Instead, use [test] with
    [Assert.assert_*]. See [test]

    Example:
    {[
    (* factorial 0...SUCCESS *)
    Test.test_eq "factorial 0" (Hm1.factorial 0) 1;

    (* factorial 3...FAIL: Failure("false != true") *)
    Test.test_eq "factorial 3" (Hm1.factorial 3) 5
    ]} *)

val test_eq_a : string -> 'a -> 'a -> ('a -> 'a -> unit) -> unit
(** a simple equality check about whether the two given arguments are equal with
    a given equality function. It tell you the result if your assert function
    prints them

    Example:
    {[
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

    let () =
      Test.test_eq_a "parse number"
        (fst (Hm2.parse_number [ '1' ]))
        (Hm2.Const 1.0) assert_exp
    ]} *)

val eq : 'a -> 'a -> unit
(** assert whether the two given values are equal
    @raise Failure if not equal *)

val eq_f : 'a -> 'a -> ('a -> 'a -> bool) -> unit
(** assert whether the two given values are equal with the given predicate that
    takes in a and b
    @raise Failure if predicate is false *)

val a_eq : 'a -> 'a -> 'b -> unit
(** returns a function to assert whether the two given arguments are equal

    Example:
    {[
    (* factorial 3...SUCCESS *)
    Test.test "factorial 3" (Test.a_eq (Hm1.factorial 3) 6)
    ]} *)
