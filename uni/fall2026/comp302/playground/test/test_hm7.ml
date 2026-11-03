open Playground
open Test
open Printf
open Hm7

let next (s : 'a Hm7.stream ref) =
  let cur = !s.head in
  s := Hm7.force !s.tail;
  cur

let run (t : T.t) = ()
(* printf "%s\n" (Print.arr_to_string (take 100 s) string_of_int) *)
