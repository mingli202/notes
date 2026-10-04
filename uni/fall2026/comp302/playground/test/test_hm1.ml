open Playground
open Test

let run (t : TestRunner.t) =
  TestRunner.test_list t "test distances" Hm1.distance_tests (fun ((a, b), expected) ->
      Assert.assert_int (Hm1.distance a b) expected);

  TestRunner.test_list t "test binomial" Hm1.binomial_tests (fun ((a, b), expected) ->
      Assert.assert_int (Hm1.binomial a b) expected);

  TestRunner.test_list t "test lucas" Hm1.lucas_tests (fun (a, expected) ->
      Assert.assert_int (Hm1.lucas a) expected)
