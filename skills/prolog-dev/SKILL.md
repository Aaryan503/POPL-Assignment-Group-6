---
name: prolog-dev
description: Use when writing, testing or reviewing SWI-Prolog 9.x code for CS F301 Assignment 2 (P1 puzzle, P2 equations); enforces the assignment's coding rules and checklist.
---

# prolog-dev

## 1. Language and version
- SWI-Prolog 9.x (`swipl --version` to confirm). Standard Prolog plus SWI strings.
- Files contain only definitions (clauses and comments). No directives except `:- use_module(library(...))`.

## 2. Conventions
- Predicate and atom names are `snake_case`; variables are `CamelCase`; `_` for unused ones.
- Every predicate gets a comment directly above it with (a) its declarative reading and (b) its mode:

      % clue(N, S) holds when clue number N is true in the fully ground solution S.
      % Mode: clue(+Int, +List).

- Mode symbols: `+` must be bound on call, `-` unbound on call, `?` either.
- Read each clause declaratively ("H holds if B1 and B2"), then check the recursive case and the base case separately.
- One clause per case. Put base cases first. Keep clauses of one predicate together.
- Prefer pure relations (`append/3`, `select/3`, `permutation/2`, `nth0/3`) over hand-written loops.
- Quote atoms that are not plain lowercase words: `'Alex'`, `'c++'`, `'AI'`.

## 3. How to run
- Run `main`: `swipl -q -f file.pl -g main -t halt`
- Run any goal: `swipl -q -f file.pl -g "<goal>" -t halt`
- Example: `swipl -q -f id_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), print(N), nl" -t halt`
- Tests: `swipl -q -f tests/test_q1.pl -g run_tests -t halt` (plunit, `:- use_module(library(plunit))`).
- Always run the code before declaring it done. Paste the real output, never a guessed one.

## 4. Hard rules (assignment)
- No `halt/0` in the file. No `initialization/1,2` or `:- initialization`.
- No `assert*`, `retract*`, `b_setval`, `nb_setval`, or other global state.
- Allowed libraries only: `lists`, `apply`, `yall`, `aggregate` (plunit only in `tests/`).
- Print nothing except what the task specifies. No debug output, no prompts, nothing on load.
- P2: do not build a string and parse it back to evaluate it. Evaluate on the tree.
- P2 equations are SWI-Prolog strings (not atoms, not code lists).
- Do not hard-code answers that the task says must be derived.

## 5. Self-review checklist (apply before every answer)
1. Does the file load with no output and no warnings (singleton variables, discontiguous clauses)?
2. Any forbidden predicate or library (section 4)? Search the file for `assert`, `retract`, `halt`, `initialization`, `nb_`, `b_setval`.
3. Does each predicate have a declarative comment and a mode line?
4. Did I run the examples from the assignment and compare the output exactly (spaces, quotes, order)?
5. Does it terminate on `[]`, one-element lists and failing inputs? Does it fail cleanly instead of raising an error?
6. Does the query leave choicepoints or give duplicate answers? Check with `findall` counts and `sort/2` against the expected count.
7. Are all arithmetic arguments bound before `is/2` or `=:=`?
8. Are atoms quoted correctly and compared with `==`, not `=` or `=:=`?
9. Is the change limited to the one unit requested? Say what was not touched.

## 6. Known AI failure modes in Prolog
- Left recursion that loops (`p(X) :- p(Y), ...`). Recurse on a strictly smaller argument, consume input first.
- Leftover choicepoints and duplicate answers: `member/2` where `memberchk/2` is meant, or overlapping clauses. Fix the clauses; do not paper over with `!` unless justified.
- Mixing `=` (unify), `==` (identical), `\==`, `=:=` (arithmetic equal) and `is` (evaluate). `X = 2+3` does not compute; `X == Y` binds nothing.
- `is/2` on an unbound variable raises an instantiation error. Bind inputs first, generate before testing.
- Atoms vs strings vs code lists: `"abc"` is a string in SWI-Prolog 7+. Use `format(string(S), ...)`, `string_concat/3`; do not use `atom_concat` when a string is required.
- Capitalised or special atoms written without quotes (`Alex`, `c++`, `AI`) become variables or syntax errors. Quote them.
- Integer vs float division: `/` may yield a float (depends on `prefer_rationals` and `iso` flags); use `//` or test `X mod Y =:= 0` first and guard against a zero divisor.
- Printing with `print/1` or `write_canonical/1` shows quotes (`'AI'`); use `write/1` or `format("~w", [X])` when the task wants them unquoted.
- Calling `halt/0` or adding `:- initialization(main).` out of habit: forbidden here.
- Negation by failure (`\+`) with unbound variables gives wrong answers. Make the argument ground first.
- Claiming code works without running it.
