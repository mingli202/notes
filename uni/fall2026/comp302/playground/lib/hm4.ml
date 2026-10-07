(* The code here will be added to the top of your code automatically.
   You do NOT need to copy it into your code if you use LearnOCaml.
*)

exception NotImplemented

let domain () =
  failwith "REMINDER: You should not be writing tests for undefined values."

type 'a tree = Empty | Tree of 'a tree * 'a * 'a tree

let maxk (x : int) (y : int) (k : int -> 'r) : 'r = if x > y then k x else k y

(* These are to make it easier for you to write tests.
   Remember that you only need to write tests for the
   "trivial" continuations: `id` and `some_k`/`none_k`. *)
let insert_test_continuations (tests : ('a * 'b) list) :
    (('a * ('b -> 'b)) * 'b) list =
  let id x = x in
  List.map (fun (a, b) -> ((a, id), b)) tests

(* Tree Depth *)

(** tests for tree_depth *)
let tree_depth_cps_test_cases : (int tree * int) list =
  [
    (Empty, 0);
    (Tree (Tree (Empty, 0, Empty), 0, Empty), 2);
    ( Tree
        ( Tree (Empty, 0, Tree (Tree (Empty, 0, Empty), 0, Empty)),
          0,
          Tree (Tree (Empty, 0, Tree (Empty, 0, Empty)), 0, Empty) ),
      4 );
  ]

(* These are the test cases that will actually be graded, but
   you don't have to modify this. Remember that you only need
   to test with the `id` continuation. `insert_test_continuations`
   (defined in the prelude) adds the `id` continuation to each of
   your test cases. *)
let tree_depth_cps_tests : ((int tree * (int -> int)) * int) list =
  insert_test_continuations tree_depth_cps_test_cases

(* An example of Non-CPS function to find depth of a tree: *)
let rec tree_depth (t : 'a tree) =
  match t with
  | Empty -> 0
  | Tree (l, _, r) -> 1 + max (tree_depth l) (tree_depth r)

(** gets the depth fo the tree with continuation *)
let rec tree_depth_cps (t : 'a tree) (return : int -> 'r) : 'r =
  match t with
  | Empty -> return 0
  | Tree (l, _, r) ->
      tree_depth_cps l (fun lv ->
          tree_depth_cps r (fun rv -> maxk lv rv (fun x -> return (x + 1))))

(* Question 2: Tree Traversal *)
(* TODO: Write a good set of tests for testing your tree traversal function. *)
let traverse_cps_test_cases : (int tree * int list) list =
  [
    (Tree (Tree (Empty, 2, Empty), 1, Tree (Empty, 3, Empty)), [ 1; 2; 3 ]);
    ( Tree
        ( Tree (Tree (Empty, 4, Empty), 2, Tree (Empty, 5, Empty)),
          1,
          Tree (Empty, 3, Empty) ),
      [ 1; 2; 4; 5; 3 ] );
    ( Tree
        ( Tree
            ( Tree (Empty, 2, Empty),
              7,
              Tree (Tree (Empty, 5, Empty), 6, Tree (Empty, 11, Empty)) ),
          1,
          Tree (Empty, 9, Tree (Empty, 9, Tree (Empty, 5, Empty))) ),
      [ 1; 7; 2; 6; 5; 11; 9; 9; 5 ] );
  ]

let traverse_cps_tests : ((int tree * (int list -> int list)) * int list) list =
  insert_test_continuations traverse_cps_test_cases

(* An example of non-CPS function to preorder traverse a tree *)
let rec tree_traverse (t : 'a tree) =
  match t with
  | Empty -> []
  | Tree (l, x, r) -> (x :: tree_traverse l) @ tree_traverse r

(** tree traversal with cps *)
let rec traverse_cps (t : 'a tree) (return : 'a list -> 'r) : 'r =
  match t with
  | Empty -> return []
  | Tree (l, v, r) ->
      traverse_cps l (fun ll ->
          traverse_cps r (fun rr -> return ((v :: ll) @ rr)))
