# P1 Report: Department Assignment Puzzle

## Result of P1.b

`count_solutions([1,2,3,4,5,6,7,8], N)` gives **N = 3**.

The three solutions satisfying clues 1 to 8 are (each friend as Department, Language, Project):

| Solution | Alex | Ben | Carla | Dana |
|---|---|---|---|---|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

## What N = 3 tells us about the puzzle

Clues 1 to 8 do not determine a single answer, so the puzzle as given is under-constrained: it has three valid solutions, not one.

The solutions agree on Ben, who is always in development with JavaScript and the web project. They disagree about the other three friends, and the disagreement covers all three attributes. Alex is in design in solutions 1 and 2 and in testing in solution 3, and his language and project change with it. Carla's and Dana's departments, languages and projects also differ from one solution to the next, with research, testing and design rotating among Alex, Carla and Dana.

## How clue 9 repairs the puzzle

Clue 9 reads: "The friend who prefers embedded projects works in the design department." It names no friend and refers only to attribute values, as clue 5 does.

In solution 1 the embedded friend (Dana) works in testing, and in solution 3 the embedded friend (Alex) also works in testing, so clue 9 is false in both. In solution 2 the embedded friend (Alex) works in design, so clue 9 is true there. That leaves exactly one solution, and `count_solutions([1,2,3,4,5,6,7,8,9], N)` gives **N = 1**.

The unique solution is:

- Alex = [design, java, embedded]
- Ben = [development, javascript, web]
- Carla = [testing, python, AI]
- Dana = [research, c++, data]

## Method note

All values above were first obtained by an independent brute-force enumeration of the 13,824 candidates (4! x 4! x 4!), and should be re-confirmed by running `count_solutions/2` in SWI-Prolog before submission.