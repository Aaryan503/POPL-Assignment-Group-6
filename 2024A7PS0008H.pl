:- use_module(library(lists)).

% split(List, Left, Right) holds when Left and Right are both non-empty and
% appending Left to Right gives List, i.e. Left is the first j elements of
% List and Right is the rest, for some 1 =< j < length(List).
% Mode: split(+List, ?Left, ?Right).
split(List, Left, Right) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List).