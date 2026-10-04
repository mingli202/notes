module TestRunner : sig
  type t

  val create : unit -> t
  val branch : t -> string -> (t -> unit) -> unit
  val run : t -> unit
  val test : t -> string -> (unit -> unit) -> unit
  val test_list : t -> string -> 'a list -> ('a -> unit) -> unit
  val eq : 'a -> 'a -> unit
  val eq_f : 'a -> 'a -> ('a -> 'a -> bool) -> unit
  val a_eq : 'a -> 'a -> 'b -> unit
  val a_eq_f : 'a -> 'a -> ('a -> 'a -> bool) -> 'b -> unit
  val test_eq : t -> string -> 'a -> 'a -> unit
  val test_eq_a : t -> string -> 'a -> 'a -> ('a -> 'a -> unit) -> unit
end = struct
  type testResult = Fail of string | Skip of string | Success
  type ('a, 'b, 'c) fn_or_list = Fn of ('a -> 'b) | List of 'c list

  type t = {
    mutable fn : (unit, testResult, t) fn_or_list;
    mutable name : string option;
  }

  type cli_test_args = { verbose : bool; testnames : string list }

  let red_ascii = "\027[31m"
  let green_ascii = "\027[32m"
  let reset_ascii = "\027[0m"

  let _colored (s : string) (color : string) : string =
    Printf.sprintf "%s%s%s" color s reset_ascii

  let _red (s : string) = _colored s red_ascii
  let _green (s : string) = _colored s green_ascii

  (** returns the given result formatted for colored terminal printing *)
  let _format_result (result : testResult) : string =
    match result with
    | Fail reason -> Printf.sprintf "%s: %s" (_red "FAIL") reason
    | Skip reason -> Printf.sprintf "%s: %s" "SKIP" reason
    | Success -> Printf.sprintf "%s" (_green "SUCCESS")

  (** prints the given [result] with the given [title] *)
  let _print_test_result (title : string) (result : testResult) : unit =
    Printf.printf "%s...%s\n" title (_format_result result)

  (** wraps the given [f], returning [Success] if no error was raised. otherwise
      return a [Fail] with the raised description *)
  let _with_error_handling (f : unit -> unit) : unit -> testResult =
   fun () ->
    try
      f ();
      Success
    with exn -> Fail (Printexc.to_string exn)

  (** whether s matches any of the given regexes *)
  let _has_match (s : string option) (regexes : Re.re list) =
    if List.length regexes = 0 then true
    else
      match s with
      | None -> true
      | Some s -> List.exists (fun r -> Re.execp r s) regexes

  let rec _run_with_testnames (testnames : Re.re list)
      (parent_prefix : string option) (testrunner : t) : unit =
    let prefix =
      Option.value (Option.map (fun n -> n ^ "/") parent_prefix) ~default:""
    in
    let full_name = Option.map (fun n -> prefix ^ n) testrunner.name in
    match testrunner.fn with
    | Fn f ->
        if _has_match full_name testnames then
          _print_test_result (Option.value full_name ~default:"") (f ())
    | List children ->
        List.iter (_run_with_testnames testnames full_name) children

  (** parses the cli arguments for testing *)
  let _parse_test_args () : cli_test_args =
    let verbose = ref false in
    let testnames = ref [] in
    let usage_msg = "dune exec test.exe -- [--verbose] [<test1>...]" in
    let speclist =
      [ ("--verbose", Arg.Set verbose, "Ouput debug information") ]
    in
    let anon_fun testname = testnames := testname :: !testnames in
    let () = Arg.parse speclist anon_fun usage_msg in
    { verbose = !verbose; testnames = !testnames }

  (** map string to regex *)
  let _test_names_to_regex (testnames : string list) =
    List.map Re.Perl.compile_pat testnames

  (** runs the all the testcases that matches the testnames *)
  let _run_with_cli_args (testcase : t) (testnames : Re.re list) : unit =
    _run_with_testnames testnames None testcase

  let _get_list fn = match fn with Fn _ -> [] | List c -> c

  (* PUBLIC INTERFACE *)
  (* docs in the mli file *)

  (** creates a new test runner *)
  let create () = { name = None; fn = List [] }

  (** creates a sub runner *)
  let branch self (name : string) (subrunner : t -> unit) =
    let new_t =
      { name = Some (String.replace_all ~sub:" " ~by:"_" name); fn = List [] }
    in
    let () = self.fn <- List (_get_list self.fn @ [ new_t ]) in
    subrunner new_t

  (** run the test runner *)
  let run self : unit =
    _run_with_cli_args self
      (_test_names_to_regex (_parse_test_args ()).testnames)

  (** tests the given function [f], fails if the function raises an error

      Example:
      {[
      let t = TestRunner.create ();;

      (* factorial 3...SUCCESS *)
      TestRunner.test t "factorial 3" (fun () ->
          Assert.assert_int (Hm1.factorial 3) 6);

      (* factorial 3...FAIL: Failure("6 != 5") *)
      TestRunner.test t "factorial 3" (fun () ->
          Assert.assert_int (Hm1.factorial 3) 5);

      TestRunner.run t "test examples"
      ]}

      @param title The title of the test
      @param f
        The function that is testing stuff. The test fails if the predicate
        raises an error *)
  let test self (title : string) (f : unit -> unit) : unit =
    let children = _get_list self.fn in
    self.fn <-
      List
        (children
        @ [
            {
              name = Some (String.replace_all ~sub:" " ~by:"_" title);
              fn = Fn (_with_error_handling f);
            };
          ])

  (** runs a function [f] against the list of given [test_cases]

      Example:
      {[
      let t = TestRunner.create ();;

      (*
      test binomial [0/5]...SUCCESS
      test binomial [1/5]...SUCCESS
      test binomial [2/5]...SUCCESS
      test binomial [3/5]...SUCCESS
      test binomial [4/5]...FAIL: Failure("120 != 12")
      *)
      TestRunner.test_list t Hm1.binomial_tests "test binomial"
        (fun ((a, b), expected) ->
          Assert.assert_int (Hm1.binomial a b) expected);

      TestRunner.run t "test_list example"
      ]}

      @param name The name of the test
      @param test_cases The list of test cases
      @param f
        The function that takes as argument a [test_case]. The test will be
        considered failed if the predicate raises an error *)
  let test_list self (name : string) (test_cases : 'a list) (f : 'a -> unit) :
      unit =
    let len = List.length test_cases in
    List.iteri
      (fun i x ->
        test self (Printf.sprintf "%s [%d/%d]" name (i + 1) len) (fun () -> f x))
      test_cases

  (** assert whether the two given values are equal
      @raise Failure if not equal *)
  let eq a b = Assert.assert_bool (a = b) true

  (** assert whether the two given values are equal with the given predicate
      that takes in a and b
      @raise Failure if predicate is false *)
  let eq_f (a : 'a) (b : 'a) (pred : 'a -> 'a -> bool) =
    Assert.assert_bool (pred a b) true

  (** returns a function to assert whether the two given arguments are equal

      Example:
      {[
      let t = TestRunner.create ();;

      (* factorial 3...SUCCESS *)
      TestRunner.test t "factorial 3" (Test.a_eq (Hm1.factorial 3) 6);

      TestRunner.run t "a_eq examples"
      ]} *)
  let a_eq a b = fun _ -> eq a b

  let a_eq_f a b f = fun _ -> eq_f a b f

  (** a simple equality check about whether the two given arguments are equal.
      It will not tell you the result of either. Instead, use [test] with
      [Assert.assert_*]. See [test]

      Example:
      {[
      let t = TestRunner.create ();;

      (* factorial 0...SUCCESS *)
      TestRunner.test_eq t "factorial 0" (Hm1.factorial 0) 1;

      (* factorial 3...FAIL: Failure("false != true") *)
      TestRunner.test_eq t "factorial 3" (Hm1.factorial 3) 5;

      TestRunner.run t "a_eq examples"
      ]} *)
  let test_eq self (title : string) a b : unit = test self title (a_eq a b)

  (** a simple equality check about whether the two given arguments are equal
      with a given equality function. It tell you the result if your assert
      function prints them

      Example:
      {[
      let t = TestRunner.create ()

      let rec exp_to_string exp =
        match exp with
        | Hm2.Const value -> sprintf "%f" value
        | Hm2.Var -> sprintf "%s" "x"
        | Hm2.Plus (exp1, exp2) ->
            sprintf "%s + %s" (exp_to_string exp1) (exp_to_string exp2)
        | Hm2.Times (exp1, exp2) ->
            sprintf "%s * %s" (exp_to_string exp1) (exp_to_string exp2)
        | Hm2.Div (exp1, exp2) ->
            sprintf "%s / %s" (exp_to_string exp1) (exp_to_string exp2)

      let assert_exp e1 e2 = Assert.assert_to_string e1 e2 exp_to_string;;

      TestRunner.test_eq_a t "parse number"
        (fst (Hm2.parse_number [ '1' ]))
        (Hm2.Const 1.0) assert_exp;

      TestRunner.run t "test_eq_a examples"
      ]} *)
  let test_eq_a self (title : string) a b (f : 'a -> 'a -> unit) : unit =
    test self title (fun () -> f a b)
end
