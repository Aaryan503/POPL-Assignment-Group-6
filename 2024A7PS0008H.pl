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