:- dynamic(player_position/2).
:- dynamic(inventory/8).                
:- dynamic(maxInventory/1). 
:- discontiguous(maxInventory/1).           
:- dynamic(gameMain/1).

/* inventory(nama, current health, nattack, sattack, namasatack, type, id, lvl) */
/* maxInventory(Maks) */

:- include('tokemon.pl').
:- include('utility.pl').

check_inv(X):-
	inventory(X,_,_,_,_,_,_,_).

cekPanjangInv(Panjang) :-
	findall(B,inventory(B,_),ListBanyak),
	length(ListBanyak,Panjang).

printInventory :-
	forall(inventory(A,B,C,D,E,F,G,H),
	(write('Tokemon: '),write(A),nl,
	 write('   Health: '),write(B),nl,
	 write('   Normal attack: '),write(C),nl,
	 write('   Special attack: '),write(D),nl,
	 write('   Nama Special attack: '),write(E),nl,
	 write('   Type: '),write(F),nl,
	 write('   ID: '),write(G),nl,
	 write('   Level: '),write(H),nl,nl)),!.

init_player :-
	asserta(gameMain(1)),
	asserta(maxInventory(0)),
	asserta(lagi_ketemu(0)),
	asserta(battle_status(0)),
	write('Prof. Rila memberikanmu tokemon! Silahkan cek inventory-mu!'),nl,
	generateTokemon,!.

addToInventory(Tokemon) :-
	maxInventory(X),
	X2 is X+1,
	retract(maxInventory(X)),
	asserta(maxInventory(X2)),
    tokemon(Tokemon,H,N,S,NS,T,I),  
	assertz(inventory(Tokemon,H,N,S,NS,T,I,1)),!.

delFromInventory(Tokemon) :-
 \+inventory(Tokemon,_,_,_,_,_,_,_),
 write('u have no such tokemon dude'),nl,!,fail.

drop(X) :- delFromInventory(X),!.

delFromInventory(_) :-
    maxInventory(X),
	X =:= 1,
	write('u cannot dump ur only pokemon sir'),nl, !.
 

delFromInventory(Tokemon) :-
    maxInventory(X),
 X2 is X-1,
 retract(maxInventory(X)),
 asserta(maxInventory(X2)),
 inventory(Tokemon,_,_,_,_,_,_,_),
 retract(inventory(Tokemon,_,_,_,_,_,_,_)),
 !.

generateTokemon :-
	random(1,12,X),
	tokemon(Tokemon,_,_,_,_,_,X),
	write(Tokemon),write(' added to your inventory!'),nl,
	addToInventory(Tokemon),
	!.