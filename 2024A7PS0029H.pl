% clue(N, Solution) holds when clue number N is true in the fully ground Solution.
% Solution = [p('Alex',D,L,P), p('Ben',D,L,P), p('Carla',D,L,P), p('Dana',D,L,P)].
% Mode: clue(+Int, +List).
% Each value occurs exactly once, so memberchk/2 finds "the friend who ..."
% deterministically and every clause succeeds at most once.

% CLUE 1: The AI-project friend does not work in research and is not Dana.
clue(1, S) :-
    memberchk(p(Name, Dept, _, 'AI'), S),
    Dept \== research,
    Name \== 'Dana'.

% CLUE 2: Alex does not work in development and does not prefer C++.
clue(2, S) :-
    memberchk(p('Alex', Dept, Lang, _), S),
    Dept \== development,
    Lang \== 'c++'.

% CLUE 3: The friend working in the testing department likes Python.
clue(3, S) :-
    memberchk(p(_, testing, Lang, _), S),
    Lang == python.

% CLUE 4: Ben prefers web projects and does not work in testing.
clue(4, S) :-
    memberchk(p('Ben', Dept, _, Proj), S),
    Proj == web,
    Dept \== testing.

% CLUE 5: The friend whose favorite language is Java works in the design department.
clue(5, S) :-
    memberchk(p(_, Dept, java, _), S),
    Dept == design.

% CLUE 6: Carla's project preference is not embedded, and her department is not development.
clue(6, S) :-
    memberchk(p('Carla', Dept, _, Proj), S),
    Proj \== embedded,
    Dept \== development.

% CLUE 7: Dana's favorite language is not Java, and she works in research or testing.
clue(7, S) :-
    memberchk(p('Dana', Dept, Lang, _), S),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% CLUE 8: The friend who prefers data projects works in research and does not use JavaScript.
clue(8, S) :-
    memberchk(p(_, Dept, Lang, data), S),
    Dept == research,
    Lang \== javascript.

% solution(S) holds when S is a candidate: Alex, Ben, Carla and Dana (in this order)
% each get a department, language and project, with every value of each attribute
% used exactly once. No clue is checked here.
% Mode: solution(-List).
solution([p('Alex', D1, L1, P1),
          p('Ben', D2, L2, P2),
          p('Carla', D3, L3, P3),
          p('Dana', D4, L4, P4)]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript], [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data], [P1, P2, P3, P4]).

% satisfies(Active, S) holds when clue(N, S) holds for every clue number N in Active.
% An empty Active holds for any S (no clue applies).
% Mode: satisfies(+List, +List).
satisfies(Active, S) :-
    forall(member(N, Active), clue(N, S)).

% count_solutions(Active, N) holds when N is the number of candidates S (from solution/1)
% that satisfy exactly the clues in Active; all other clues are ignored.
% Mode: count_solutions(+List, -Int).
count_solutions(Active, N) :-
    findall(S, (solution(S), satisfies(Active, S)), Solutions),
    length(Solutions, N).

% main holds after printing one solution of clues 1-8, one line per friend in the
% order Alex, Ben, Carla, Dana, as: Name = [Dept, Lang, Project] (atoms unquoted).
% Fails (prints nothing) if no solution exists.
% Mode: main.
main :-
    once(( solution(S), satisfies([1,2,3,4,5,6,7,8], S) )),
    forall(member(p(Name, Dept, Lang, Proj), S),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Proj])).