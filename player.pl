:- dynamic(player_status/1).
:- dynamic(player_position/2).
:- dynamic(inventory/8).                
:- dynamic(maxInventory/1).             
:- dynamic(gameMain/1).

/* inventory(nama, current health, nattack, sattack, namasatack, type, id, lvl) */
/* maxInventory(Maks) */

:- include('tokemon.pl').
:- include('utility.pl').

check_inv(X):-
	inventory(X,_,_,_,_,_,_,_).

printInventory :-
	forall(inventory(A,B,C,D,E,F,G,H),
	(write(A),nl,
	write(B),nl,
	write(C),nl,
	write(D),nl,
	write(E),nl,
	write(F),nl,
	write(G),nl,
	write(H),nl)),!.

init_player :-
	asserta(gameMain(1)),
	asserta(maxInventory(0)),
	asserta(lagi_ketemu(0)),
	asserta(battle_status(0)),
	write('Prof. Rila memberikanmu tokemon! Silahkan cek inventory-mu!'),nl,
	generateTokemon,generateTokemon,!.

addToInventory(Tokemon) :-
	maxInventory(X),
	X2 is X+1,
	retract(maxInventory(X)),
	asserta(maxInventory(X2)),
    tokemon(Tokemon,H,N,S,NS,T,I),  
	assertz(inventory(Tokemon,H,N,S,NS,T,I,1)),!.

delFromInventory(Tokemon) :-
	\+inventory(Tokemon,_,_,_,_,_,_,_),!,fail.

delFromInventory(Tokemon) :-
	inventory(Tokemon,_,_,_,_,_,_,_),
	retract(inventory(Tokemon,_,_,_,_,_,_,_)),
	!.

generateTokemon :-
	random(1,12,X),
	tokemon(Tokemon,_,_,_,_,_,X,_),
	write(Tokemon),write(' added to your inventory!'),nl,
	addToInventory(Tokemon),
	!.