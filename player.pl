:- include('tokemon.pl').
:- include('utility.pl').

:- dynamic(player_status/1).
:- dynamic(player_position/2).
:- dynamic(player_inv/6).
:- dynamic(inventory/7).
:- dynamic(inventory_used/1).        
:- dynamic(maxInventory/1).            
/* inventory(nama,max health, nattack,sattack,namasatack,type,id) */
/* maxInventory(Maks) */
/*

*/

init_player :-
	asserta(player_status(1)),
	asserta(inventory_used(0)),
	asserta(gameMain(1)),
	asserta(maxInventory(6)),
	generateTokemon.
  

cekPanjangInv(Panjang) :-
	findall(B,inventory(B,_,_,_,_,_,_),ListBanyak),
	length(ListBanyak,Panjang).

addToInventory(_) :-
	/* Memasukkan tokemon ke dalam inventory namun inventori sudah full */
	cekPanjangInv(Panjang),
	maxInventory(Maks),
    (Panjang+1) > Maks,
    write("Inventory full!"),
    nl,
    !,
    fail.

addToInventory(Tokemon) :-
    /* Memasukkan tokemon ke dalam inventory dan inventori belum full */
    tokemon(Tokemon,H,N,S,NS,T,I),  
	asserta(inventory(Tokemon,H,N,S,NS,T,I)),!.


delFromInventory(Tokemon) :-
	/*Menghapus tokemon dari inventory namun tidak ada tokemon dalam inventory*/
	\+inventory(Tokemon,_,_,_,_,_,_),!,fail.

delFromInventory(Tokemon) :-
	/* Menghapus tokemon dari inventory dan tokemon ada di inventory */
	inventory(Tokemon,_,_,_,_,_,_),
	retract(inventory(Tokemon,_,_,_,_,_,_)),
	!.

generateTokemon:-
	/* Menentukan Tokemon pada awal game secara random */
	random(1,12,X),
	tokemon(Tokemon,_,_,_,_,_,X),
    addToInventory(Tokemon),
	!.

/*drop(X):- .


capture(X):- .


check_inv(X) :- 
    \+player_inv(_,X,________),
    write("Tokemon tidak tersedia di inventory"),!.

check_inv(X) :- .
*/







