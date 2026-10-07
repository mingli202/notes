open Test
open Playground

let run t =
  T.test_list t "tree depth" Hm4.tree_depth_cps_tests (fun ((tree, f), b) ->
      Assert.assert_int (Hm4.tree_depth_cps tree f) b);

  T.test_list t "tree traversal" Hm4.traverse_cps_tests (fun ((tree, f), b) ->
      Assert.assert_arr (Hm4.traverse_cps tree f) b string_of_int)
