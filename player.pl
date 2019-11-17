:- dynamic(player_status/1).
:- dynamic(player_position/2).
% :- dynamic(player_inv1/3).
% :- dynamic(player_inv2/3).
% :- dynamic(player_inv3/3).
% :- dynamic(player_inv4/3).
% :- dynamic(player_inv5/3).
% :- dynamic(player_inv6/3).
:- dynamic(inventory/7).                /* inventory(nama,max health, nattack,sattack,namasatack,type,id) */
:- dynamic(maxInventory/1).             /* maxInventory(Maks) */

:- include('tokemon.pl').
:- include('utility.pl').

init_player :-
	asserta(gameMain(1)),
	% lebarPeta(L),
	% tinggiPeta(T),
	% random(1,L,X),
	% random(1,T,Y),
	% asserta(player(X,Y)),
	% asserta(healthpoint(100)),
	% asserta(armor(0)),
	% asserta(senjata(sniper_rifle,40,3)),
	asserta(maxInventory(6)),
	generateTokemon
    % 
    .


cekPanjangInv(Panjang) :-
	findall(B,inventory(B,_,_,_,_,_,_),ListBanyak),
	length(ListBanyak,Panjang).

addToInventory(_) :-
	cekPanjangInv(Panjang),
	maxInventory(Maks),
    (Panjang+1) > Maks,
    write("Inventory full!"),
    nl,
    !,
    fail.

addToInventory(Tokemon) :-
    /*Inventory muat*/
    tokemon(Tokemon,H,N,S,NS,T,I),  
	asserta(inventory(Tokemon,H,N,S,NS,T,I)),!.


delFromInventory(Tokemon) :-
	\+inventory(Tokemon,_,_,_,_,_,_),!,fail.
delFromInventory(Tokemon) :-
	inventory(Tokemon,_,_,_,_,_,_),
	retract(inventory(Tokemon,_,_,_,_,_,_)),
	!.

generateTokemon:-
	random(1,12,X),
	tokemon(Tokemon,_,_,_,_,_,X),
	addToInventory(Tokemon),
	!.