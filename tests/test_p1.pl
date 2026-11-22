% Tests for P1 (6_q1.pl).
% Run from the repository root:
%   swipl -q -f tests/test_q1.pl -g run_tests -t halt

:- use_module(library(plunit)).
:- consult('../code/6_q1').

% main_solution(S): the solution main/0 prints (first one found for clues 1-8).
main_solution([p('Alex',design,java,'AI'),
               p('Ben',development,javascript,web),
               p('Carla',research,'c++',data),
               p('Dana',testing,python,embedded)]).

% unique_solution(S): the only solution once clue 9 is added.
unique_solution([p('Alex',design,java,embedded),
                 p('Ben',development,javascript,web),
                 p('Carla',testing,python,'AI'),
                 p('Dana',research,'c++',data)]).

:- begin_tests(q1).

% --- each clue 1-8 holds on the solution main prints ---
test(clue1) :- main_solution(S), clue(1, S).
test(clue2) :- main_solution(S), clue(2, S).
test(clue3) :- main_solution(S), clue(3, S).
test(clue4) :- main_solution(S), clue(4, S).
test(clue5) :- main_solution(S), clue(5, S).
test(clue6) :- main_solution(S), clue(6, S).
test(clue7) :- main_solution(S), clue(7, S).
test(clue8) :- main_solution(S), clue(8, S).

% a clue must fail on a solution that breaks it (clue 3: testing friend likes Python)
test(clue3_fails_on_wrong, [fail]) :-
    clue(3, [p('Alex',design,java,'AI'),
             p('Ben',development,javascript,web),
             p('Carla',research,python,data),
             p('Dana',testing,'c++',embedded)]).

% each clue succeeds at most once (no duplicate answers)
test(clues_deterministic) :-
    main_solution(S),
    forall(between(1, 8, N),
           findall(x, clue(N, S), [x])).

% --- counting ---
% 4! * 4! * 4! = 13824 candidates (no clues active)
test(count_no_clues, [true(N == 13824)]) :- count_solutions([], N).
test(count_clues_1_to_8, [true(N == 3)]) :- count_solutions([1,2,3,4,5,6,7,8], N).
test(count_clues_1_to_9, [true(N == 1)]) :- count_solutions([1,2,3,4,5,6,7,8,9], N).
test(count_clues_1_to_9_holds) :- count_solutions([1,2,3,4,5,6,7,8,9], 1).

% --- clue 9 keeps exactly one of the solutions of clues 1-8 ---
test(clue9_true_on_unique) :- unique_solution(S), clue(9, S).
test(clue9_false_on_all_others) :-
    unique_solution(U),
    all_solutions([1,2,3,4,5,6,7,8], All),
    length(All, 3),
    memberchk(U, All),
    forall(( member(S, All), S \== U ), \+ clue(9, S)).

% --- main output: exactly four lines in the required format ---
test(main_output) :-
    with_output_to(string(Out), main),
    Expected = "Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n",
    Out == Expected.

:- end_tests(q1).