:- include('tokemon.pl').
:- include('utility.pl').

:- dynamic(player_status/1).
:- dynamic(player_position/2).
:- dynamic(player_inv/6).

:- dynamic(inventory/7).                /* inventory(nama,max health, nattack,sattack,namasatack,type,id) */
:- dynamic(maxInventory/1).             /* maxInventory(Maks) */
/*


*/
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
    asserta(maxInventory(6)).
    % addToInventory(anangmon)
    /*generateTokemon*/


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

/*generateTokemon:-
	findall(Ter,tokemon(Ter,_,_,_,_,_,Y),Y<=12,ListTokemon),
    length(ListTokemon, Panjang),
    random(0,Panjang,NoTokemon),
    ambil(ListTokemon, NoTokemon, Tokemon),
    addToInventory(Tokemon),
	!. */

/*drop(X):- .


capture(X):- .


check_inv(X) :- 
    \+player_inv(_,X,________),
    write("Tokemon tidak tersedia di inventory"),!.

check_inv(X) :- .
*/







