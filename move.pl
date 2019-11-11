include('init.pl').


n :-
	\+game_status(_),
	write("MULAI DULU BRAY"), nl, !.	


n :-
	retract(player_position(X,Y)),
	Y > 1,
	Y2 is Y-1,
	write([X,Y2]),nl,
	asserta(player_position(X,Y2)), !.

n :-
	player_position(_,Y),
	Y =:= 1,
	write("nabrak bos"), nl,
	!.
n :-
	player_position(X,Y),
	isRintangan(X,Y2),
	Y2 =:= Y-1,
	write("nabrak bos"), nl,
	!.

s :-
	\+game_status(_),
	write("MULAI DULU BRAY"), nl, !.	


s :-
	retract(player_position(X,Y)),
	isBottomBorder(_,YY),
	Y < YY-1,
	Y2 is Y+1,
	write([X,Y2]),nl,
	asserta(player_position(X,Y2)), !.

s :-
	player_position(_,Y),
	isBottomBorder(_,YY),
	Y =:= YY-1,
	Y =:= 1,
	write("nabrak bos"), nl,
	!.

e :-
	\+game_status(_),
	write("MULAI DULU BRAY"), nl, !.	


e :-
	retract(player_position(X,Y)),
	X > 1,
	X2 is X-1,
	write([X2,Y]),nl,
	asserta(player_position(X2,Y)), !.

e :-
	player_position(X,_),
	isRightBorder(X2,_),
	X =:= X2-1,
	write("nabrak bos"), nl,
	!.

e :-
	player_position(X,Y),
	isRintangan(X2,Y),
	X2 is X+1,
	write("nabrak bos"), nl,
	!.

w :-
	\+game_status(_),
	write("MULAI DULU BRAY"), nl, !.	


w :-
	retract(player_position(X,Y)),
	Y > 1,
	Y2 is Y-1,
	write([X,Y2]),nl,
	asserta(player_position(X,Y2)), !.

w :-
	player_position(_,Y),
	Y =:= 1,
	write("nabrak bos"), nl,
	!.

w :-
	player_position(X,Y),
	isRintangan(X2,Y),
	X2 is X-1,
	write("nabrak bos"), nl,
	!.


