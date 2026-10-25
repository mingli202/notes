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

exception Unknown_token

type truth_assignment = bool Variable_map.t
type op = And | Or | Not of op | None

let parse_formula (s : string) : formula =
  let len = String.length s in
  let rec parse_formula_helper (i : int) (prev : formula option) (op : op) =
    if i >= len then Option.get prev
    else
      match s.[i] with
      | 'a' .. 'z' as var -> (
          match op with
          | And ->
              parse_formula_helper (i + 1)
                (Some
                   (Conjunction (Option.get prev, Variable (String.of_char var))))
                None
          | Or ->
              parse_formula_helper (i + 1)
                (Some
                   (Disjunction (Option.get prev, Variable (String.of_char var))))
                None
          | Not prev_op ->
              let rec handle_not_op not_op acc =
                match not_op with
                | And -> Conjunction (Option.get prev, acc)
                | Or -> Disjunction (Option.get prev, acc)
                | Not prev_op_2 -> handle_not_op prev_op_2 (Negation acc)
                | None -> acc
              in
              let neg_formula =
                handle_not_op prev_op (Negation (Variable (String.of_char var)))
              in
              parse_formula_helper (i + 1) (Some neg_formula) None
          | None ->
              parse_formula_helper (i + 1)
                (Some (Variable (String.of_char var)))
                None)
      | ' ' -> parse_formula_helper (i + 1) prev op
      | '~' -> parse_formula_helper (i + 1) prev (Not op)
      | '&' -> parse_formula_helper (i + 1) prev And
      | '|' -> parse_formula_helper (i + 1) prev Or
      | _ -> raise Unknown_token
  in
  parse_formula_helper 0 None None

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
