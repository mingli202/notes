open Playground

let run =
 fun _ ->
  Test.test_list Hm1.distance_tests "test distances" (fun ((a, b), expected) ->
      assert (Hm1.distance a b == expected));

  Test.test_list Hm1.binomial_tests "test binomial" (fun ((a, b), expected) ->
      assert (Hm1.binomial a b == expected));

  Test.test_list Hm1.lucas_tests "test lucas" (fun (a, expected) ->
      assert (Hm1.lucas a == expected));

  Test.test_eq "factorial 0" (Hm1.factorial 0) 1;
  Test.test_eq "factorial 1" (Hm1.factorial 1) 1;
  Test.test "factorial 3" (fun () -> assert (Hm1.factorial 3 == 6));
  Test.test "factorial 3" (Test.a_eq (Hm1.factorial 3) 6);
  Test.test_eq "factorial 10" (Hm1.factorial 10)
    (1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 1)
