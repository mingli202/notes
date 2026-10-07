let arr_to_string arr to_string =
  let rec to_string_acc ar acc =
    match ar with
    | [] -> acc
    | a :: rest -> to_string_acc rest (acc ^ ", " ^ to_string a)
  in
  match arr with
  | [] -> ""
  | a :: rest -> "[" ^ to_string_acc rest (to_string a) ^ "]"
