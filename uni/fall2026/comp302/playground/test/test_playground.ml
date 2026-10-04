open Test

(** wraps the test runner with some strings to seperate each other *)
let w (f : unit -> unit) =
 fun (name : string) ->
  let s =
    Printf.sprintf "================= Testing %s =================" name
  in
  Printf.printf "%s\n" s;
  f ()

let t = TestRunner.create ()

let () =
  TestRunner.branch t "hm1" Test_hm1.run;
  TestRunner.branch t "hm2" Test_hm2.run;
  TestRunner.branch t "hm3" Test_hm3.run;

  TestRunner.run t
(* let args = parse_args () in *)
