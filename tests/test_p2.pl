% tests/test_q2.pl: plunit tests for P2 (code/6_q2.pl).
% Run from the repository root:
%   swipl -q -f tests/test_q2.pl -g run_tests -t halt
% (The consult path below is relative to this file, so any directory works.)

:- use_module(library(plunit)).
:- use_module(library(lists)).
:- consult('../code/6_q2.pl').

% eval_ok(Tree, V) is an independent evaluator used only by the tests: it
% fails when any division inside Tree has a zero divisor or a remainder.
eval_ok(n(X), X).
eval_ok(op(+, L, R), V) :- eval_ok(L, A), eval_ok(R, B), V is A + B.
eval_ok(op(-, L, R), V) :- eval_ok(L, A), eval_ok(R, B), V is A - B.
eval_ok(op(*, L, R), V) :- eval_ok(L, A), eval_ok(R, B), V is A * B.
eval_ok(op(/, L, R), V) :-
    eval_ok(L, A), eval_ok(R, B), B =\= 0, A mod B =:= 0, V is A // B.

% good_strings(List) holds when every equation for List is a string, has no
% space, and contains exactly one '='.
good_strings(List) :-
    all_equations(List, Es),
    forall(member(E, Es),
           (   string(E),
               \+ sub_string(E, _, _, _, " "),
               split_string(E, "=", "", [_, _])
           )).

% no_zero_division(List) holds when every tree expr/3 builds for List
% re-evaluates cleanly (no zero divisor, no inexact division) to its Value.
no_zero_division(List) :-
    forall(expr(List, T, V), eval_ok(T, V)).

:- begin_tests(examples).

test(four_numbers, [true(Es == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                                "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"])]) :-
    all_equations([4,2,5,3], Es).
test(no_equation, [true(Es == [])]) :-
    all_equations([2,3,4], Es).
test(simple_product, [true(Es == ["2*4=8"])]) :-
    all_equations([2,4,8], Es).
test(generate_is_one_of_seven, [nondet]) :-
    generate_equation([4,2,5,3], E),
    memberchk(E, ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                  "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).
test(count_seven, [true(N =:= 7)]) :-
    count_equations([4,2,5,3], N).
test(count_none, [true(N =:= 0)]) :-
    count_equations([2,3,4], N).
test(count_one, [true(N =:= 1)]) :-
    count_equations([2,4,8], N).

:- end_tests(examples).

:- begin_tests(failure_cases).

test(empty, [fail]) :- generate_equation([], _).
test(single, [fail]) :- generate_equation([5], _).
test(no_solution, [fail]) :- generate_equation([2,3,4], _).
test(all_empty, [true(Es == [])]) :- all_equations([], Es).
test(all_single, [true(Es == [])]) :- all_equations([5], Es).
test(count_empty, [true(N =:= 0)]) :- count_equations([], N).
test(count_single, [true(N =:= 0)]) :- count_equations([5], N).

:- end_tests(failure_cases).

:- begin_tests(strings).

test(generate_is_string, [nondet]) :-
    generate_equation([4,2,5,3], E), string(E).
test(every_result_good_4253) :- good_strings([4,2,5,3]).
test(every_result_good_248)  :- good_strings([2,4,8]).
test(every_result_good_1111) :- good_strings([1,1,1,1]).
test(every_result_good_6num) :- good_strings([1,2,3,4,5,6]).
test(multi_digit_numbers_kept, [true(Es == ["10-5=5", "10=5+5"])]) :-
    all_equations([10,5,5], Es).

:- end_tests(strings).

:- begin_tests(division_by_zero).

test(zero_zero, [true(Es == ["0=0"])]) :- all_equations([0,0], Es).
% Only 6*0=0 works: 6 never equals 0+0, 0-0 or 0*0, and 6/0 is not allowed.
test(six_zero_zero, [true(Es == ["6*0=0"])]) :- all_equations([6,0,0], Es).
% 0/5 is exact (0), so "0/5=0" is valid; 5/0 and 0/0 are never produced.
test(zero_five_zero, [true(Es == ["0*5=0", "0/5=0", "0=5*0"])]) :-
    all_equations([0,5,0], Es).
test(no_bad_division_00)  :- no_zero_division([0,0]).
test(no_bad_division_600) :- no_zero_division([6,0,0]).
test(no_bad_division_050) :- no_zero_division([0,5,0]).
test(no_bad_division_5num) :- no_zero_division([8,0,4,0,2]).
test(no_error_on_zero_divisor, [fail]) :- expr([5,0], op(/, _, _), _).
test(no_error_on_zero_expr_divisor, [fail]) :-
    expr([6,3,3], op(/, n(6), op(-, n(3), n(3))), _).

:- end_tests(division_by_zero).

:- begin_tests(tree_string).

t(op(*, op(+, n(4), n(2)), n(3)), "(4+2)*3").
t(op(+, n(4), op(*, n(2), n(3))), "4+2*3").
t(op(*, op(/, n(8), n(4)), n(2)), "8/4*2").
t(op(/, n(8), op(*, n(4), n(2))), "8/(4*2)").
t(op(-, op(-, n(1), n(2)), n(3)), "1-2-3").
t(op(-, n(1), op(-, n(2), n(3))), "1-(2-3)").
t(op(+, n(1), op(+, n(2), n(3))), "1+(2+3)").
t(op(+, op(+, n(1), n(2)), n(3)), "1+2+3").

test(eight_examples, [forall(t(T, Exp)), true(S == Exp)]) :-
    tree_string(T, S).
test(result_is_string, [forall(t(T, _))]) :-
    tree_string(T, S), string(S).
test(single_number, [true(S == "7")]) :- tree_string(n(7), S).
test(zero, [true(S == "0")]) :- tree_string(n(0), S).
test(multi_digit, [true(S == "10-25")]) :-
    tree_string(op(-, n(10), n(25)), S).
test(distinct_trees_distinct_strings) :-
    findall(S, (expr([1,2,3,4], T, _), tree_string(T, S)), Ss),
    length(Ss, N), sort(Ss, U), length(U, N).

:- end_tests(tree_string).

:- begin_tests(split_and_expr).

test(split_four, [true(Xs == [[a]-[b,c,d], [a,b]-[c,d], [a,b,c]-[d]])]) :-
    findall(L-R, split([a,b,c,d], L, R), Xs).
test(split_empty, [fail]) :- split([], _, _).
test(split_single, [fail]) :- split([a], _, _).
test(expr_single, [nondet, true(T-V == n(7)-7)]) :- expr([7], T, V).
test(expr_counts, [true(Ns == [1, 3, 20, 153])]) :-
    findall(N, (member(L, [[1],[1,2],[1,2,3],[1,2,3,4]]),
                findall(x, expr(L, _, _), Xs), length(Xs, N)), Ns).

:- end_tests(split_and_expr).

:- begin_tests(timing).

test(six_numbers_fast) :-
    statistics(cputime, T0),
    count_equations([1,2,3,4,5,6], _),
    statistics(cputime, T1),
    Elapsed is T1 - T0,
    Elapsed < 5.
test(eight_numbers_fast, [nondet]) :-
    statistics(cputime, T0),
    generate_equation([9,8,7,6,5,4,3,2], _),
    statistics(cputime, T1),
    Elapsed is T1 - T0,
    Elapsed < 5.

:- end_tests(timing).