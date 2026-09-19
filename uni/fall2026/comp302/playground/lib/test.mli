val test : string -> (unit -> unit) -> unit
(** tests the given function [f], fails if the function raises an error

    Example:
    {[
    (* factorial 3...SUCCESS *)
    Test.test "factorial 3" (fun () -> assert (Hm1.factorial 3 == 6));

    (* factorial 3...FAIL: File "test/test_hm1.ml", line 16, characters 37-43: Assertion failed *)
    Test.test "factorial 3" (fun () -> assert (Hm1.factorial 3 == 5))
    ]}

    @param title The title of the test
    @param f
      The function that is testing stuff. The test fails if the predicate raises
      an error *)

val test_list : 'a list -> string -> ('a -> unit) -> unit
(** runs a function [f] against the list of given [test_cases]

    Example:
    {[
    Test.test_list Hm1.distance_tests "test distances"
      (fun ((a, b), expected) -> assert (Hm1.distance a b == expected))
    ]}

    @param name The name of the test
    @param test_cases The list of test cases
    @param f
      The function that takes as argument a [test_case]. The test will be
      considered failed if the predicate raises an error *)

val test_eq : string -> 'a -> 'a -> unit
(** a simple equality check

    Example:
    {[
    (* factorial 0...SUCCESS *)
    Test.test_eq "factorial 0" (Hm1.factorial 0) 1;

    Test.test_eq "factorial 3" (Hm1.factorial 3) 5
    (* factorial 3...FAIL: Failure("eq failed") *)
    ]} *)

val assert_bool : bool -> unit
(** @raise Failure "assert failed" if [b] is false *)

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
