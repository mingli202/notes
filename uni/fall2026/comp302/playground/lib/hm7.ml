exception NotImplemented

type 'a susp = Susp of (unit -> 'a)
type 'a stream = { head : 'a; tail : 'a stream susp }

let force (Susp f : 'a susp) = f ()

let rec take n (s : 'a stream) : 'a list =
  if n = 0 then [] else s.head :: take (n - 1) (force s.tail)

let rec zip_with (f : 'a -> 'b -> 'c) (s1 : 'a stream) (s2 : 'b stream) :
    'c stream =
  {
    head = f s1.head s2.head;
    tail = Susp (fun () -> zip_with f (force s1.tail) (force s2.tail));
  }

let rec map (f : 'a -> 'b) (s : 'a stream) : 'b stream =
  { head = f s.head; tail = Susp (fun () -> (map f) (force s.tail)) }

let rec iterate (f : 'a -> 'a) (x : 'a) : 'a stream =
  { head = x; tail = Susp (fun () -> iterate f (f x)) }

let rec merge (s1 : 'a stream) (s2 : 'a stream) : 'a stream =
  if s1.head < s2.head then
    { head = s1.head; tail = Susp (fun () -> merge (force s1.tail) s2) }
  else if s1.head > s2.head then
    { head = s2.head; tail = Susp (fun () -> merge s1 (force s2.tail)) }
  else
    {
      head = s1.head;
      tail = Susp (fun () -> merge (force s1.tail) (force s2.tail));
    }

let int_stream_not_implemented : int stream =
  { head = 0; tail = Susp (fun () -> raise NotImplemented) }

(* SECTION 1 *)

(*  Question 1.1 *)
let rec repeat (x : 'a) : 'a stream =
  { head = x; tail = Susp (fun () -> repeat x) }

(* Question 1.2 *)
let rec filter (f : 'a -> bool) (s : 'a stream) : 'a stream =
  if f s.head then
    { head = s.head; tail = Susp (fun () -> filter f (force s.tail)) }
  else filter f (force s.tail)

(* Question 1.3 *)
let rec lucas1 =
  {
    (* You should fix these *)
    head = 2;
    tail = Susp (fun () -> lucas2);
  }

and lucas2 =
  {
    (* You should fix these *)
    head = 1;
    tail = Susp (fun () -> zip_with (fun a b -> a + b) lucas1 lucas2);
  }

(* Question 1.4 *)
let unfold (f : 'a -> 'b * 'a) (seed : 'a) : 'b stream =
  map (fun x -> fst (f x)) (iterate (fun x -> snd (f x)) seed)

(* Question 1.5 *)
let unfold_lucas : int stream = unfold (fun (a, b) -> (a, (b, a + b))) (2, 1)

(* SECTION 2 *)

(* Question 2.1 *)
let rec scale (s1 : int stream) (n : int) : int stream = map (fun x -> x * n) s1

(* Question 2.2 *)
let rec s =
  {
    head = 1;
    tail = Susp (fun () -> merge (merge (scale s 2) (scale s 3)) (scale s 5));
  }
