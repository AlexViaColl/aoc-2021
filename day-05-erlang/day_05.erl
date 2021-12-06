% erlc day_05.erl
% erl -noshell -s day_05 solve -s init stop

-module(day_05).
-export([solve/1, part_1/1, part_2/1]).

solve(PathsToSolve) ->
    lists:foreach(fun(Path) ->
        Content = read_file(Path),
        part_1(Content),
        part_2(Content)
    end, PathsToSolve).

part_1(Content) ->
    Lines = lists:filter(
        fun(Line) -> {X1, Y1, X2, Y2} = Line, (X1 == X2) or (Y1 == Y2) end,
        lists:map(
            fun(Line) ->
                [First, Second|_] = string:tokens(Line, " -> "),
                [X1, Y1|_] = lists:map(fun (S) -> {X, _} = string:to_integer(S), X end, string:tokens(First, ",")),
                [X2, Y2|_] = lists:map(fun (S) -> {X, _} = string:to_integer(S), X end, string:tokens(Second, ",")),
                {X1, Y1, X2, Y2}
            end,
            string:tokens(Content, "\n")
        )
    ),

    LinePositions = lists:map(
        fun(Line) ->
            {X1, Y1, X2, Y2} = Line,
            {X_Start, X_End} = case X1 =< X2 of
                true -> {X1, X2};
                false -> {X2, X1}
            end,
            {Y_Start, Y_End} = case Y1 =< Y2 of
                true -> {Y1, Y2};
                false -> {Y2, Y1}
            end,
            {X_Start, Y_Start, X_End, Y_End}
        end,
        Lines
    ),

    Positions = lists:flatten([{X, Y} ||
        {X_Start, Y_Start, X_End, Y_End} <- LinePositions,
        X <- lists:seq(X_Start, X_End),
        Y <- lists:seq(Y_Start, Y_End)
    ]),

    Duplicates = lists:usort(remove_unique(Positions)),
    io:format("Part 1: ~p~n", [length(Duplicates)]).

part_2(Content) ->
    Lines = lists:map(
        fun(Line) ->
            [First, Second|_] = string:tokens(Line, " -> "),
            [X1, Y1|_] = lists:map(fun (S) -> {X, _} = string:to_integer(S), X end, string:tokens(First, ",")),
            [X2, Y2|_] = lists:map(fun (S) -> {X, _} = string:to_integer(S), X end, string:tokens(Second, ",")),
            {X1, Y1, X2, Y2}
        end,
        string:tokens(Content, "\n")
    ),

    LinePositions = lists:map(
        fun(Line) ->
            {X1, Y1, X2, Y2} = Line,
            Incr_X = trunc((X2 - X1) / case abs(X2 - X1) == 0 of true -> 1; false -> abs(X2 - X1) end),
            Incr_Y = trunc((Y2 - Y1) / case abs(Y2 - Y1) == 0 of true -> 1; false -> abs(Y2 - Y1) end),
            {X1, Y1, X2, Y2, Incr_X, Incr_Y}
        end,
        Lines
    ),

    StraightPositions = lists:flatten([{X, Y} ||
        {X_Start, Y_Start, X_End, Y_End, Incr_X, Incr_Y} <- LinePositions,
        (X_Start == X_End) or (Y_Start == Y_End),
        X <- lists:seq(X_Start, X_End, Incr_X),
        Y <- lists:seq(Y_Start, Y_End, Incr_Y)
    ]),
    DiagonalPositions = [L ||
        {X_Start, Y_Start, X_End, Y_End, Incr_X, Incr_Y} <- LinePositions,
        (X_Start /= X_End) and (Y_Start /= Y_End),
        L <- lists:zip(
            lists:seq(X_Start, X_End, Incr_X),
            lists:seq(Y_Start, Y_End, Incr_Y)
        )
    ],
    Merged = StraightPositions ++ DiagonalPositions,

    Duplicates = lists:usort(remove_unique(Merged)),
    io:format("Part 2: ~p~n", [length(Duplicates)]).

remove_unique(L) ->
    Count = lists:foldl(fun count/2, #{}, L),
    lists:filter(fun(X) -> maps:get(X, Count) =/= 1 end, L).

count(X, M) ->
    maps:put(X, maps:get(X, M, 0) + 1, M).

read_file(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
      after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.
