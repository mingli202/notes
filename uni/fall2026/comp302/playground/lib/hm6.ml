exception NotImplemented
exception Msg of string

type password = string

type bank_account = {
  withdraw : password -> int -> unit;
  deposit : password -> int -> unit;
  show_balance : password -> int;
}

(* Errors. Please use these. *)
let negative_amount = Msg "Money amount below 0"
let wrong_pass = Msg "Wrong password"
let account_locked = Msg "Account locked, please contact bank"
let not_enough_balance = Msg "Insufficient balance"

let open_account (pass : password) : bank_account =
  (* TODO: create any helper variables and/or functions *)
  let password_attempts = ref 0 in
  let amount = ref 0 in
  let assert_pass p =
    if !password_attempts = 3 then raise account_locked;
    if p <> pass then begin
      password_attempts := !password_attempts + 1;
      raise wrong_pass
    end
    else password_attempts := 0
  in
  let assert_pos_amt amt = if amt < 0 then raise negative_amount in
  let assert_enough_balance amt =
    if amt > !amount then raise not_enough_balance
  in

  (* deposit the given amt if p is the right password *)
  let deposit p amt =
    assert_pass p;
    assert_pos_amt amt;
    amount := !amount + amt
  in
  (* show the account balance *)
  let show_balance p =
    assert_pass p;
    !amount
  in
  (* withdraw the given amount *)
  let withdraw p amt =
    assert_pass p;
    assert_pos_amt amt;
    assert_enough_balance amt;
    amount := !amount - amt
  in
  { deposit; show_balance; withdraw }
