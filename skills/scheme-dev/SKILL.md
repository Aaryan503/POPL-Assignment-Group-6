---
name: scheme-dev
description: Use when writing, testing or reviewing Racket 8.x (#lang racket/base) code for CS F301 Assignment 2 (S1 tree traversals, S2 nested insert) under the restricted built-in list.
---

# scheme-dev

## 1. Language and version
- Racket 8.x. Every file starts with `#lang racket/base` (check with `racket --version`).
- Only the built-ins in section 2 may be used. Nothing else from `racket/base`, and no `require` of other libraries in solution files.

## 2. Allowed built-ins (exact list)
- Binding and control: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`.
- Data: `quote` (written `'`), `cons`, `car`, `cdr`, `list`, and every `c[ad]r` composition up to four levels (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, ...).
- Predicates and lookup: `null?`, `pair?`, `eq?`, `assq`, `assoc`.
- Arithmetic and comparison: `+ - * < > <= >= =`, `max`.
- Output: `display`, `newline`.
- Input: `read` (S2 only).

## 3. Forbidden (write your own helpers instead)
- Mutation: `set!` and relatives (`set-car!`, `set-cdr!`, `set-box!`, ...).
- Data structures: vectors, hash tables, strings (and string/char/symbol conversion functions), boxes.
- Loops: `do`, `for` and all `for/...` forms.
- List library: `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`, `foldl`, `foldr`, `apply`, `list?`, `equal?`.
- Own helpers to write when needed: `my-reverse`, `my-length`, `my-map` (and any others, built only from section 2).

## 4. Conventions
- Names are `kebab-case`; predicates end in `?` (`empty-tree?`); helpers use a `my-` or descriptive prefix.
- Above every function, a comment giving its recursive reading: the base case, then the recursive case.

      ; (my-length lst): 0 for '(); otherwise 1 + length of the rest.
      ; Tail-recursive with accumulator acc.

- Pass all state through function arguments (accumulators). Prefer tail recursion where it is natural.
- Define helpers before use or inside `letrec`/named `let`. One definition per name (no duplicates).

## 5. File and run rules
- The file contains only definitions. No top-level calls, no top-level `display`, nothing printed on load. The grader appends its own calls.
- Run: `racket file.rkt`.
- Quick check of one call: `racket -e '(require (file "id_q3.rkt"))'` only works if a `provide` exists; for tests, copy the definitions into the test file or `load` them. Never leave test calls in the solution file.

## 6. Self-review checklist (apply before every answer)
1. First line is `#lang racket/base`; no `require` in solution files.
2. Every identifier used is in section 2 or defined in the file. Search for `length`, `append`, `reverse`, `map`, `filter`, `member`, `list-ref`, `set!`, `for`, `vector`, `string`.
3. Nothing runs or prints at load. Output only through the required functions.
4. Each function has a comment with base case and recursive case.
5. Empty tree `'()` and empty list `'()` are handled, including as the top-level input.
6. Recursion depth is safe on 10,000 elements and nesting depth 100: use accumulators and `my-reverse` for list building.
7. Output functions end with `(newline)` and match the exact format (parentheses, single spaces).
8. `else` appears only as the last clause of a `cond`.
9. Run it with `racket` on the assignment examples and compare output character by character.
10. Change only the unit requested; say what was left untouched.

## 7. Known AI failure modes in Scheme/Racket
- Sneaking in forbidden built-ins (`length`, `append`, `map`, `reverse`, `foldl`, `apply`, `equal?`, `list-ref`) because they are habitual. Write `my-` versions.
- Non-tail recursion (`(cons (f (car l)) (my-map f (cdr l)))`) that overflows or is slow on 10,000 elements. Accumulate, then `my-reverse`.
- Wrong base case: testing `(null? lst)` after `(car lst)`, or treating `'()` as an atom. In this assignment `'()` is a list of length 0, not an atom.
- Confusing `null?` and `pair?` when telling atoms from sublists: an element is a sublist if `(or (null? e) (pair? e))`.
- Using `eq?` on numbers or lists; `eq?` is fine for symbols only. For numbers use `=`.
- Forgetting the final `(newline)`, or printing extra text or a prompt.
- `display` of a quoted list prints `(1 2 3)` without the quote; do not add quote marks yourself.
- Using `else` outside `cond`, or `else` not last; using `if` without an else branch (an error in Racket).
- Measuring list length after insertion instead of on the original list (S2).
- Leaving top-level test calls or a `(main)` call in the file.
- Claiming code works without running it.
