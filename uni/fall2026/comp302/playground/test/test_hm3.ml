open Playground
open Printf

let run =
 fun () ->
  Test.test_list Hm3.to_int_tests "church to int" (fun (inp, exp) ->
      Assert.assert_int (Hm3.to_int inp) exp);

  Test.test_list Hm3.is_zero_tests "church is_zero" (fun (inp, exp) ->
      Assert.assert_bool (Hm3.is_zero inp) exp);

  Test.test_list Hm3.add_tests "church add" (fun ((inp1, inp2), exp) ->
      Assert.assert_int (Hm3.to_int (Hm3.add inp1 inp2)) (Hm3.to_int exp));

  Test.test_list Hm3.mult_tests "church multiplication"
    (fun ((inp1, inp2), exp) ->
      Assert.assert_int (Hm3.to_int (Hm3.mult inp1 inp2)) (Hm3.to_int exp));

  Test.test_list Hm3.int_pow_church_tests "chuch pow"
    (fun ((inp1, inp2), exp) ->
      Assert.assert_int (Hm3.int_pow_church inp1 inp2) exp)
