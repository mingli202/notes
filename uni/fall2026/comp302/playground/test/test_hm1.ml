open Playground

let run =
 fun _ ->
  Test.test_list Hm1.distance_tests "test distances" (fun ((a, b), expected) ->
      Assert.assert_int (Hm1.distance a b) expected);

  Test.test_list Hm1.binomial_tests "test binomial" (fun ((a, b), expected) ->
      Assert.assert_int (Hm1.binomial a b) expected);

  Test.test_list Hm1.lucas_tests "test lucas" (fun (a, expected) ->
      Assert.assert_int (Hm1.lucas a) expected)
