#!/usr/bin/env bash
# Runs all lab1 tests and reports PASS/FAIL for each.
# Usage: ./run_tests.sh [-v]   (-v shows diffs / output for failing tests)

cd "$(dirname "$0")" || exit 1

JAR="${LOGISIM_JAR:-$HOME/Downloads/logisim-evolution-3.9.0dev-all.jar}"
JDK="$HOME/.local/state/logisim-jdk"
CIRC="cpu.circ"
T="testfiles"
VERBOSE=0
[[ "$1" == "-v" ]] && VERBOSE=1

if [[ ! -f "$JAR" ]]; then
	echo "Logisim jar not found at $JAR" >&2
	exit 2
fi

if [[ -x "$JDK/bin/java" ]]; then
	JAVA="$JDK/bin/java"
elif command -v java >/dev/null; then
	JAVA="java"
else
	nix build nixpkgs#openjdk --out-link "$JDK" || exit 1
	JAVA="$JDK/bin/java"
fi

logisim() { "$JAVA" -jar "$JAR" --no-splash "$@"; }

GREEN=$'\e[32m'; RED=$'\e[31m'; RESET=$'\e[0m'
pass=0; fail=0
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

report() { # name status
	if [[ "$2" == 0 ]]; then
		echo "${GREEN}PASS${RESET}  $1"; ((pass++))
	else
		echo "${RED}FAIL${RESET}  $1"; ((fail++))
	fi
}

# Task 1: ALU (test vector)
logisim --test-vector ALU "$T/alu_test.vec" "$CIRC" >"$tmp" 2>&1
grep -q "Passed: 28, Failed: 0" "$tmp"; st=$?
report "Task 1: ALU" $st
[[ $st != 0 && $VERBOSE == 1 ]] && tail -5 "$tmp"

# Compare tty table output against a golden file
run_table() { # name golden args...
	local name="$1" golden="$2"; shift 2
	logisim "$CIRC" --tty table "$@" >"$tmp" 2>/dev/null
	diff -q --ignore-blank-lines <(awk 1 "$golden") <(awk 1 "$tmp") >/dev/null; local st=$?
	report "$name" $st
	if [[ $st != 0 && $VERBOSE == 1 ]]; then
		diff --ignore-blank-lines <(awk 1 "$golden") <(awk 1 "$tmp") --color=always
	fi
}

# Task 2: Register File
run_table "Task 2: Register File" "$T/rf_test_gold.out" --toplevel-circuit RegisterFileTester

# Tasks 3-5: CPU programs
for t in aluinstrtest linklisttest1 linklisttest2 multiplication1 multiplication2 multiplication3 multiplication4; do
	run_table "CPU: $t" "$T/$t.out" --toplevel-circuit CPU -l "$T/$t.rom" InsMem
done

echo
echo "Passed: $pass, Failed: $fail"
[[ $fail == 0 ]]
