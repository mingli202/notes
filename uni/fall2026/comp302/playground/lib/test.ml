type testResult = Fail of string | Skip of string | Success

let red_ascii = "\027[31m"
let green_ascii = "\027[32m"
let reset_ascii = "\027[0m"

let _colored (s : string) (color : string) : string =
  Printf.sprintf "%s%s%s" color s reset_ascii

let _red (s : string) = _colored s red_ascii
let _green (s : string) = _colored s green_ascii

(** returns the given result formatted for colored terminal printing *)
let _format_result (result : testResult) : string =
  match result with
  | Fail reason -> Printf.sprintf "%s: %s" (_red "FAIL") reason
  | Skip reason -> Printf.sprintf "%s: %s" "SKIP" reason
  | Success -> Printf.sprintf "%s" (_green "SUCCESS")

(** prints the given [result] with the given [title] *)
let _print_test_result (title : string) (result : testResult) : unit =
  Printf.printf "%s...%s\n" title (_format_result result)

(** wraps the given [f], returning [Success] if no error was raised. otherwise
    return a [Fail] with the raised description *)
let _with_error_handling (f : unit -> unit) : testResult =
  try
    f ();
    Success
  with exn -> Fail (Printexc.to_string exn)

(* PUBLIC INTERFACE *)
(* docs in the mli file *)

let test (title : string) (f : unit -> unit) : unit =
  _print_test_result title (_with_error_handling f)

let test_list (test_cases : 'a list) (name : string) (f : 'a -> unit) : unit =
  let len = List.length test_cases in
  List.iteri
    (fun i x ->
      test (Printf.sprintf "%s [%d/%d]" name (i + 1) len) (fun () -> f x))
    test_cases

let eq a b = Assert.assert_bool (a == b) true

let eq_f (a : 'a) (b : 'a) (pred : 'a -> 'a -> bool) =
  Assert.assert_bool (pred a b) true

let a_eq a b = fun _ -> eq a b
let a_eq_f a b f = fun _ -> eq_f a b f
let test_eq (title : string) a b : unit = test title (a_eq a b)
