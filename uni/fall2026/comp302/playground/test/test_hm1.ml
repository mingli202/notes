open Playground

let run =
 fun _ ->
  Test.testList Hm1.distance_tests "test distances" (fun ((a, b), expected) ->
      assert (Hm1.distance a b == expected));
  Test.testList Hm1.distance_tests "test distances" (fun ((a, b), expected) ->
      assert (Hm1.distance a b == expected))
