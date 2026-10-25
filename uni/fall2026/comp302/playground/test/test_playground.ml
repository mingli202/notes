open Test

let t = T.create ()

let () =
  T.branch t "hm1" Test_hm1.run;
  T.branch t "hm2" Test_hm2.run;
  T.branch t "hm3" Test_hm3.run;
  T.branch t "hm4" Test_hm4.run;
  T.branch t "hm5" Test_hm5.run;

  T.run t
(* let args = parse_args () in *)
