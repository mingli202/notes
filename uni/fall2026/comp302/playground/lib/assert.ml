let assert_str_fn a b fn =
  if a == b then () else failwith (Printf.sprintf "%s != %s" (fn a) (fn b))

let assert_bool a b = assert_str_fn a b string_of_bool
let assert_int a b = assert_str_fn a b string_of_int
let assert_float a b = assert_str_fn a b string_of_float
