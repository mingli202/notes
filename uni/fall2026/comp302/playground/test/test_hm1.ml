open Playground

let run =
 fun _ ->
  Test.testList Hm1.distance_tests "test distances" (fun ((a, b), expected) ->
      assert (Hm1.distance a b == expected));

  Test.testList Hm1.binomial_tests "test binomial" (fun ((a, b), expected) ->
      assert (Hm1.binomial a b == expected));

  Test.testList Hm1.lucas_tests "test lucas" (fun (a, expected) ->
      assert (Hm1.lucas a == expected))
