(** assert a = b from the given predicate with a custom to_string function *)
let assert_to_string_pred a b pred to_string =
  if pred a b then ()
  else failwith (Printf.sprintf "%s != %s" (to_string a) (to_string b))

(** assert a = b with a custom to_string function *)
let assert_to_string a b to_string =
  assert_to_string_pred a b (fun x y -> x = y) to_string

(** assert the two given bool are equal *)
let assert_bool a b = assert_to_string a b string_of_bool

(** assert the two given int are equal *)
let assert_int a b = assert_to_string a b string_of_int

(** assert the two given float are equal *)
let assert_float a b = assert_to_string a b string_of_float
