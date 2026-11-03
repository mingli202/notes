open Test
open Playground
open Printf

type 'a stream = { head : 'a option; tail : 'a stream susp }
and 'a susp = Susp of (unit -> 'a)

let rec end_of_stream = { head = None; tail = Susp (fun () -> end_of_stream) }
let force (Susp f : 'a susp) = f ()

let next (s : 'a stream ref) =
  match !s.head with
  | None -> None
  | Some v -> begin
      s := force !s.tail;
      Some v
    end

let rec lconcat s1 s2 =
  match s1.head with
  | None ->
      begin match s2.head with
      | None -> { head = None; tail = Susp (fun () -> lconcat s1 s2) }
      | Some v ->
          { head = Some v; tail = Susp (fun () -> lconcat (force s2.tail) s1) }
      end
  | Some v ->
      { head = Some v; tail = Susp (fun () -> lconcat (force s1.tail) s2) }

let rec range start step limit =
  if start >= limit then
    { head = None; tail = Susp (fun () -> range start step limit) }
  else
    {
      head = Some start;
      tail = Susp (fun () -> range (start + step) step limit);
    }

let rec iter f s =
  match s.head with
  | None -> ()
  | Some v -> begin
      f v;
      iter f (force s.tail)
    end

type 'a set = 'a list

(* [sample] is an exact cover of [x] iff every element of [x] appears in
   exactly one set of [sample], and no set contains anything outside [x]. *)
let check_x3c (x : 'a set) (sample : 'a set list) : bool =
  let all = List.concat sample in
  List.for_all (fun e -> List.mem e x) all
  && List.for_all (fun e -> List.length (List.filter (( = ) e) all) = 1) x

let rec x3c (x : 'a set) (l : 'a set list) : 'a set list stream =
  let rec find_sample l (sample : 'a set list)
      (success :
        'a set list -> (unit -> 'a set list stream) -> 'a set list stream)
      (fail : unit -> 'a set list stream) =
    match l with
    | [] -> if check_x3c x sample then success sample fail else fail ()
    | c :: cs ->
        find_sample cs (c :: sample) success (fun () ->
            find_sample cs sample success fail)
  in
  find_sample l []
    (fun sample fail -> { head = Some sample; tail = Susp fail })
    (fun () -> end_of_stream)

let run (t : T.t) =
  let s1 = range 0 1 10 in
  let s2 = range 11 3 30 in
  iter (fun x -> printf "%d\n" x) (lconcat s1 s2);
  let show s =
    String.concat " "
      (List.map
         (fun c -> "{" ^ String.concat "," (List.map string_of_int c) ^ "}")
         s)
  in
  let x = [ 1; 2; 3; 4; 5; 6 ] in
  let l =
    [
      [ 1; 2; 3 ];
      [ 4; 5; 6 ];
      [ 1; 4; 5 ];
      [ 2; 3; 6 ];
      [ 1; 2; 4 ];
      [ 3; 5; 6 ];
      [ 2; 3; 4 ];
    ]
  in
  iter (fun s -> printf "%s\n" (show s)) (x3c x l)
