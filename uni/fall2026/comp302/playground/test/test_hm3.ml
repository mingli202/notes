open Playground
open Printf
open Test

let another_run (t : TestRunner.t) =
  TestRunner.test_list t "chuch pow" Hm3.int_pow_church_tests
    (fun ((inp1, inp2), exp) ->
      Assert.assert_int (Hm3.int_pow_church inp1 inp2) exp)

let run (t : TestRunner.t) =
  TestRunner.test_list t "church to int" Hm3.to_int_tests (fun (inp, exp) ->
      Assert.assert_int (Hm3.to_int inp) exp);

  TestRunner.test_list t "church is_zero" Hm3.is_zero_tests (fun (inp, exp) ->
      Assert.assert_bool (Hm3.is_zero inp) exp);

  TestRunner.test_list t "church add" Hm3.add_tests (fun ((inp1, inp2), exp) ->
      Assert.assert_int (Hm3.to_int (Hm3.add inp1 inp2)) (Hm3.to_int exp));

  TestRunner.test_list t "church multiplication" Hm3.mult_tests
    (fun ((inp1, inp2), exp) ->
      Assert.assert_int (Hm3.to_int (Hm3.mult inp1 inp2)) (Hm3.to_int exp));

  TestRunner.branch t "some sub branch" another_run
