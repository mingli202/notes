(** wraps the test runner with some strings to seperate each other *)
let w (f : unit -> unit) =
 fun (name : string) ->
  let s =
    Printf.sprintf "================= Testing %s =================" name
  in
  Printf.printf "%s\n" s;
  f ()

let () =
  w Test_hm1.run "hm1";
  w Test_hm2.run "hm2"
