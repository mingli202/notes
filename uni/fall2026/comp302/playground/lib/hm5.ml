open Printf

exception NotImplemented

(** Types and Exceptions for the Assignment *)

exception Unsatisfiable_formula
exception Unassigned_variable of string

type formula =
  | Variable of string
  | Conjunction of formula * formula
  | Disjunction of formula * formula
  | Negation of formula

module Variable_map = Map.Make (String)

exception Invalid_token

type truth_assignment = bool Variable_map.t
type token = Var of string | And | Or | Not | None

let importance tok =
  match tok with Var _ -> 4 | Not -> 3 | And -> 2 | Or -> 1 | None -> 0

let cmp tok_a tok_b = importance tok_a - importance tok_b

let token_from_str s =
  match s with
  | 'a' .. 'z' as s -> Var (String.of_char s)
  | '~' -> Not
  | '&' -> And
  | '|' -> Or
  | _ -> raise Invalid_token

let token_to_str s =
  match s with
  | Var v -> v
  | And -> "&"
  | Or -> "|"
  | Not -> "~"
  | None -> "NONE"

let arr_to_string arr to_string =
  let rec to_string_acc ar acc =
    match ar with
    | [] -> acc
    | a :: rest -> to_string_acc rest (acc ^ ", " ^ to_string a)
  in
  match arr with
  | [] -> ""
  | a :: rest -> "[" ^ to_string_acc rest (to_string a) ^ "]"

let formula_to_string f =
  let rec formula_to_string_h f cont =
    match f with
    | Variable var -> cont var
    | Conjunction (l, r) ->
        formula_to_string_h l (fun l_str ->
            formula_to_string_h r (fun r_str ->
                cont (sprintf "(%s & %s)" l_str r_str)))
    | Disjunction (l, r) ->
        formula_to_string_h l (fun l_str ->
            formula_to_string_h r (fun r_str ->
                cont (sprintf "(%s | %s)" l_str r_str)))
    | Negation f ->
        formula_to_string_h f (fun f_str -> cont (sprintf "(~%s)" f_str))
  in
  formula_to_string_h f (fun x -> x)

let parse_formula (s : string) : formula =
  let len = String.length s in
  let rec parse_formula_helper (i : int) (prev : formula option)
      (prev_tok : token) =
    if i < len && s.[i] != ' ' then
      Printf.printf "s[%d] = %s\n" i (String.drop_first i s);
    let return () =
      begin
        let f =
          match prev_tok with Var v -> Variable v | _ -> Option.get prev
        in
        printf "return %s %d\n" (formula_to_string f) i;
        (f, i)
      end
    in
    if i >= len then return ()
    else
      match s.[i] with
      | ' ' -> parse_formula_helper (i + 1) prev prev_tok
      | ('a' .. 'z' | '~' | '&' | '|') as tok_str ->
          let tok = token_from_str tok_str in
          let c = cmp prev_tok tok in
          Printf.printf "prev_tok: %s  tok: %s  c: %d\n" (token_to_str prev_tok)
            (token_to_str tok) c;
          Printf.printf "prev: %s\n"
            (match prev with None -> "None" | Some f -> formula_to_string f);
          if c < 0 then begin
            let rest_f, rest_i = parse_formula_helper (i + 1) prev tok in
            Printf.printf "rest_f: %s  rest_i: %d\n" (formula_to_string rest_f)
              rest_i;
            let new_f, new_i =
              parse_formula_helper rest_i (Some rest_f) prev_tok
            in

            let new_f =
              match prev_tok with
              | And -> Conjunction (Option.get prev, new_f)
              | Or -> Disjunction (Option.get prev, new_f)
              | Not -> Negation new_f
              | Var v -> raise Invalid_token
              | None -> new_f
            in
            Printf.printf "new_f: %s\n" (formula_to_string new_f);
            (new_f, new_i)
          end
          else if c > 0 then return ()
          else begin
            let rest_f, rest_i = parse_formula_helper (i + 1) prev tok in
            parse_formula_helper rest_i (Some rest_f) tok
          end
      | _ -> raise Invalid_token
  in
  fst (parse_formula_helper 0 None None)

let collect_variables f : string list =
  let seen = ref Variable_map.empty in
  let rec collect_variables_h f =
    match f with
    | Variable var -> seen := Variable_map.add var true !seen
    | Negation f -> collect_variables_h f
    | Conjunction (fa, fb) ->
        collect_variables_h fa;
        collect_variables_h fb
    | Disjunction (fa, fb) ->
        collect_variables_h fa;
        collect_variables_h fb
  in
  collect_variables_h f;
  List.map fst (Variable_map.bindings !seen)

let rec eval (assignment : truth_assignment) (f : formula) : bool =
  match f with
  | Variable var -> Variable_map.find var assignment
  | Disjunction (a, b) -> eval assignment a || eval assignment b
  | Conjunction (a, b) -> eval assignment a && eval assignment b
  | Negation ff -> not (eval assignment ff)

(* Question 1 *)
(*----------------------------------------*)

(* TODO: Implement the function. *)
let find_sat_assignment_exc (formula : formula) : truth_assignment =
  raise NotImplemented

(* Question 2 *)
(*----------------------------------------*)

(* TODO: Implement the function. *)
let rec find_sat_assignment_cps (formula : formula)
    (return : truth_assignment -> 'r) (fail : unit -> 'r) : 'r =
  raise NotImplemented

let satisfying_assignment_of formula =
  find_sat_assignment_cps formula (fun x -> Some x) (fun () -> None)

let is_satisfiable formula =
  find_sat_assignment_cps formula (fun _ -> true) (fun _ -> false)
