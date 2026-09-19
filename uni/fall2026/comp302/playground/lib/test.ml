type testResult = Fail of string | Skip of string | Success

let red_ascii = "\027[31m"
let green_ascii = "\027[32m"
let reset_ascii = "\027[0m"

let colored (s : string) (color : string) : string =
  Printf.sprintf "%s%s%s" color s reset_ascii

let red (s : string) = colored s red_ascii
let green (s : string) = colored s green_ascii

(** returns the given result formatted for colored terminal printing *)
let format_result (result : testResult) : string =
  match result with
  | Fail reason -> Printf.sprintf "%s: %s" (red "FAIL") reason
  | Skip reason -> Printf.sprintf "%s: %s" "SKIP" reason
  | Success -> Printf.sprintf "%s" (green "SUCCESS")

(** prints the given [result] with the given [title] *)
let print_test_result (title : string) (result : testResult) : unit =
  Printf.printf "%s...%s\n" title (format_result result)

(** wraps the given [f], returning [Success] if no error was raised. otherwise
    return a [Fail] with the raised description *)
let with_error_handling (f : unit -> unit) : testResult =
  try
    f ();
    Success
  with exn -> Fail (Printexc.to_string exn)

(** tests the given function [f], fails if the function raises an error
    @param title The title of the test
    @param f
      The function that is testing stuff. The test fails if the predicate raises
      an error *)
let test (title : string) (f : unit -> unit) : unit =
  print_test_result title (with_error_handling f)

(** runs a function [f] against the list of given [test_cases]
    @param name The name of the test
    @param test_cases The list of test cases
    @param f
      The function that takes as argument a [test_case]. The test will be
      considered failed if the predicate raises an error *)
let testList (test_cases : 'a list) (name : string) (f : 'a -> unit) : unit =
  let len = List.length test_cases in
  List.iteri
    (fun i x -> test (Printf.sprintf "%s [%d/%d]" name i len) (fun () -> f x))
    test_cases

(** raise an error with the given reason *)
let fail (reason : string) = failwith reason

(** @raise Failure "assert failed" if [b] is false *)
let assert_bool (b : bool) = if b then () else failwith "eq failed"

(** assert whether the two given values are equal
    @raise Failure if not equal *)
let eq a b = assert_bool (a == b)

(** assert whether the two given values are equal with the given predicate that
    takes in a and b
    @raise Failure if predicate is false *)
let eq_f (a : 'a) (b : 'a) (pred : 'a -> 'a -> bool) = assert_bool (pred a b)

(** returns a function to assert whether the two given arguments are equal *)
let a_eq a b = fun _ -> eq a b

(** returns a function to assert whether the two given arguments are equal with
    the given predicate *)
let a_eq_f a b f = fun _ -> eq_f a b f

(** a simple equality check *)
let test_eq (title : string) a b : unit = test title (a_eq a b)
