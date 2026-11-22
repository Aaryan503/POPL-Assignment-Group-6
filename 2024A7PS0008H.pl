:- use_module(library(lists)).

% split(List, Left, Right) holds when Left and Right are both non-empty and
% appending Left to Right gives List, i.e. Left is the first j elements of
% List and Right is the rest, for some 1 =< j < length(List).
% Mode: split(+List, ?Left, ?Right).
split(List, Left, Right) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List).

% expr(Nums, Tree, Value) holds when Tree is an expression tree that uses
% every number of the non-empty list Nums exactly once, in order, and Value
% is the integer value of Tree. A single number X gives n(X). Otherwise Nums
% splits into two non-empty parts, each part has a tree, and the trees are
% combined as op(Op, L, R) with Op one of +, -, *, /.
% Mode: expr(+List, -Tree, -Int).
expr([X], n(X), X).
expr(Nums, op(Op, L, R), Value) :-
    split(Nums, Left, Right),
    expr(Left, L, LV),
    expr(Right, R, RV),
    apply_op(Op, LV, RV, Value).

% apply_op(Op, A, B, V) holds when V is the integer result of A Op B.
% Division is allowed only when B is not 0 and A divides exactly by B.
% Mode: apply_op(?Op, +Int, +Int, -Int).
apply_op(+, A, B, V) :- V is A + B.
apply_op(-, A, B, V) :- V is A - B.
apply_op(*, A, B, V) :- V is A * B.
apply_op(/, A, B, V) :- B =\= 0, A mod B =:= 0, V is A // B.

% tree_string(Tree, Str) holds when Str is the SWI-Prolog string with no
% spaces that writes Tree in canonical form: * and / bind tighter than + and -,
% a left operand is parenthesised only if its top operator has lower
% precedence than its parent, a right operand is parenthesised if its top
% operator has the same or lower precedence, and a number never is.
% Mode: tree_string(+Tree, -String).
tree_string(n(X), Str) :-
    format(string(Str), "~d", [X]).
tree_string(op(Op, L, R), Str) :-
    prec(Op, P),
    top_prec(L, LP),
    top_prec(R, RP),
    tree_string(L, LS0),
    tree_string(R, RS0),
    wrap_if(LP < P, LS0, LS),
    wrap_if(RP =< P, RS0, RS),
    format(string(Str), "~w~w~w", [LS, Op, RS]).

% prec(Op, P) holds when P is the precedence level of operator Op.
% Mode: prec(+Op, -Int).
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

% top_prec(Tree, P) holds when P is the precedence of the top operator of
% Tree; a number counts as 3, higher than every operator, so it is never wrapped.
% Mode: top_prec(+Tree, -Int).
top_prec(n(_), 3).
top_prec(op(Op, _, _), P) :- prec(Op, P).

% wrap_if(Cond, S0, S) holds when S is S0 in parentheses if the arithmetic
% comparison Cond is true, and S0 unchanged otherwise.
% Mode: wrap_if(+Goal, +String, -String).
wrap_if(Cond, S0, S) :-
    (   call(Cond)
    ->  format(string(S), "(~w)", [S0])
    ;   S = S0
    ).

% generate_equation(List, Equation) holds when Equation is the SWI-Prolog
% string "L=R" where List splits into two non-empty contiguous parts, L is
% the canonical string of an expression over the left part, R is the canonical
% string of an expression over the right part, and both have the same value.
% Mode: generate_equation(+List, -String).
generate_equation(List, Equation) :-
    split(List, Left, Right),
    expr(Left, LTree, Value),
    expr(Right, RTree, Value),
    tree_string(LTree, LStr),
    tree_string(RTree, RStr),
    format(string(Equation), "~w=~w", [LStr, RStr]).

% all_equations(List, Equations) holds when Equations is the sorted list
% (by sort/2, so without duplicates) of all strings E such that
% generate_equation(List, E) holds; it is [] when there is none.
% Mode: all_equations(+List, -Strings).
all_equations(List, Equations) :-
    findall(E, generate_equation(List, E), All),
    sort(All, Equations).

% count_equations(List, N) holds when N is the number of equations in
% all_equations(List, Equations).
% Mode: count_equations(+List, -Int).
count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).