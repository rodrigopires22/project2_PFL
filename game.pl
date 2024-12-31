%%% game.pl

% Predicado principal
play :-
    write('Bem-vindo ao jogo Sight!'), nl,
    main_menu.

% Menu principal
main_menu :-
    write('1. Jogar Humano vs Humano'), nl,
    write('2. Jogar Humano vs Computador'), nl,
    write('3. Jogar Computador vs Computador'), nl,
    write('4. Sair'), nl,
    write('Escolha uma opção: '),
    read(Option),
    handle_option(Option).

handle_option(1) :- start_game(human, human).
handle_option(2) :- start_game(human, computer).
handle_option(3) :- start_game(computer, computer).
handle_option(4) :- write('Até logo!'), nl.
handle_option(_) :- write('Opção inválida.'), nl, main_menu.

% Inicializar e iniciar o jogo
start_game(Player1, Player2) :-
    initial_state(_, GameState),
    game_loop(GameState, Player1, Player2).

% Inicializar estado do jogo
initial_state(_, game_state(Board, white, [])) :-
    generate_board(5, Board).

% Gera um tabuleiro vazio
generate_board(Size, Board) :-
    findall(Row, (my_between(1, Size, _), create_row(Size, Row)), Board).

% Cria uma linha do tabuleiro com valores iniciais
create_row(Size, Row) :-
    create_row(Size, [], Row).
create_row(0, Acc, Acc).
create_row(N, Acc, Row) :-
    N > 0,
    N1 is N - 1,
    create_row(N1, [empty|Acc], Row).

% Implementação manual do predicado between/3
my_between(Low, High, Low) :- Low =< High.
my_between(Low, High, Value) :-
    Low < High,
    Next is Low + 1,
    my_between(Next, High, Value).

% Loop principal do jogo
game_loop(GameState, Player1, Player2) :-
    display_game(GameState),
    (game_over(GameState, Winner) ->
        format('O jogo terminou! O vencedor é: ~w~n', [Winner]);
        choose_action(GameState, Player1, Player2, NewGameState),
        switch_players(Player1, Player2, NewPlayer1, NewPlayer2),
        game_loop(NewGameState, NewPlayer1, NewPlayer2)).

% Escolher entre posicionar ou mover uma peça
choose_action(GameState, Player1, Player2, NewGameState) :-
    write('Escolha uma ação: 1. Posicionar peça, 2. Mover peça'), nl,
    read(Action),
    (integer(Action), Action = 1 -> place_piece(GameState, Player1, NewGameState);
     integer(Action), Action = 2 -> make_move(GameState, Player1, Player2, NewGameState);
     write('Ação inválida, tente novamente.'), nl,
     choose_action(GameState, Player1, Player2, NewGameState)).

% Posicionar uma peça no tabuleiro
place_piece(game_state(Board, Player, History), Player, game_state(NewBoard, Player, [place(X, Y)|History])) :-
    write('Insira a posição para posicionar a peça (X, Y): '),
    read((X, Y)),
    (valid_position(Board, X, Y) ->
        replace_piece(Board, X, Y, Player, NewBoard);
        write('Posição inválida ou já ocupada, tente novamente.'), nl,
        place_piece(game_state(Board, Player, History), Player, game_state(NewBoard, Player, History))).

% Verifica se a posição é válida para posicionar uma peça
valid_position(Board, X, Y) :-
    integer(X), integer(Y),
    X > 0, Y > 0,
    length(Board, Size),
    X =< Size, Y =< Size,
    piece_at(Board, X, Y, empty).

% Exibe o estado do jogo
display_game(game_state(Board, Player, _)) :-
    write('Jogador atual: '), write(Player), nl,
    print_board(Board).

print_board(Board) :-
    print_rows(Board).

% Implementação manual para iterar sobre as linhas do tabuleiro
print_rows([]).
print_rows([Row|Rows]) :-
    write(Row), nl,
    print_rows(Rows).

% Valida movimentos
valid_moves(game_state(Board, Player, _), Moves) :-
    findall(Move, valid_move(Board, Player, Move), Moves).

valid_move(Board, Player, move(FromX, FromY, ToX, ToY)) :-
    piece_at(Board, FromX, FromY, Player),
    adjacent_position(FromX, FromY, ToX, ToY),
    piece_at(Board, ToX, ToY, empty).

% Retorna a peça em uma posição
piece_at(Board, X, Y, Piece) :-
    get_nth(Y, Board, Row),
    get_nth(X, Row, Piece).

% Recupera o enésimo elemento de uma lista
get_nth(1, [H|_], H).
get_nth(N, [_|T], Elem) :-
    integer(N), N > 1,
    N1 is N - 1,
    get_nth(N1, T, Elem).

% Verifica posições adjacentes
adjacent_position(X, Y, X1, Y1) :-
    DX is abs(X - X1),
    DY is abs(Y - Y1),
    DX + DY =:= 1.

% Realiza o movimento
make_move(GameState, human, _, NewGameState) :-
    write('Insira o movimento (FromX, FromY, ToX, ToY): '),
    read(move(FromX, FromY, ToX, ToY)),
    (valid_move(GameState, FromX, FromY, ToX, ToY) ->
        move(GameState, move(FromX, FromY, ToX, ToY), NewGameState);
        write('Movimento inválido, tente novamente.'), nl,
        make_move(GameState, human, _, NewGameState)).

make_move(GameState, computer, _, NewGameState) :-
    valid_moves(GameState, Moves),
    random_member(Move, Moves),
    move(GameState, Move, NewGameState),
    format('Computador realizou o movimento: ~w~n', [Move]).

% Realiza a troca de jogadores
switch_players(human, computer, computer, human).
switch_players(computer, human, human, computer).
switch_players(human, human, human, human).
switch_players(computer, computer, computer, computer).

% Executa o movimento
move(game_state(Board, Player, History), move(FromX, FromY, ToX, ToY), game_state(NewBoard, NextPlayer, [move(FromX, FromY, ToX, ToY)|History])) :-
    replace_piece(Board, FromX, FromY, empty, TempBoard),
    replace_piece(TempBoard, ToX, ToY, Player, NewBoard),
    next_player(Player, NextPlayer).

replace_piece(Board, X, Y, NewPiece, NewBoard) :-
    get_nth(Y, Board, Row),
    replace_in_list(Row, X, NewPiece, NewRow),
    replace_in_list(Board, Y, NewRow, NewBoard).

replace_in_list([_|T], 1, NewElem, [NewElem|T]).
replace_in_list([H|T], Index, NewElem, [H|NewT]) :-
    integer(Index), Index > 1,
    Index1 is Index - 1,
    replace_in_list(T, Index1, NewElem, NewT).

% Alterna entre os jogadores
next_player(white, black).
next_player(black, white).

% Fim do jogo
game_over(game_state(Board, Player, _), Winner) :-
    \+ valid_moves(game_state(Board, Player, _), _),
    next_player(Player, Winner).
