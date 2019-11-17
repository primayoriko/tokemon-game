:- include('player.pl').

:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(posisiGym/2).
:- dynamic(rintangan/2).
:- dynamic(exploring_status/1).
:- dynamic(ctrheal/1).

init_map :-
    exploring_status(1),
    random(10,50,X),
    random(10,50,Y),
    random(1,X,XGym),
    random(1,Y,YGym),
    asserta(ctrheal(0)),
    asserta(lebarPeta(X)),
    asserta(tinggiPeta(Y)),
    asserta(posisiXGym(XGym,YGym)),
    asserta(player_position(1,1)),
    generateRintangan,
    !.
    
isTopBorder(_,Y) :- 
    Y=:=0,!.

isLeftBorder(X,_) :-
    X=:=0,!.

isRightBorder(X,_) :-
    lebarPeta(A),
    XRight is A+1,
    X =:= XRight,
    !.

isBottomBorder(_,Y) :-
    tinggiPeta(A),
    YRight is A+1,
    Y =:= YRight,
    !.

isGym(X,Y) :-
    posisiGym(A,B),
    X =:= A,
    Y =:= B,
    !.

isRintangan(X,Y) :-
    rintangan(A,B),
    X =:= A,
    Y =:= B,
    !.



printMap(X,Y) :-
    player_position(X,Y), !, write('P').
printMap(X,Y) :-
    isGym(X,Y), !, write('G').
printMap(X,Y) :-
    isRightBorder(X,Y), !, write('X').
printMap(X,Y) :-
    isLeftBorder(X,Y), !, write('X').
printMap(X,Y) :-
    isTopBorder(X,Y), !, write('X').
printMap(X,Y) :-
    isBottomBorder(X,Y), !, write('X').
printMap(X,Y) :-
    rintangan(X,Y), !, write('X').
printMap(_,_) :-
	write('-').

generateRintangan :-
    lebarPeta(X),
    tinggiPeta(Y),
    XMin is 2,
	XMax is X,
	YMin is 2,
    YMax is Y,
    Sum is round(X*Y/10),
        
    forall(between(1,Sum,_), (
        random(XMin,XMax, A),
        random(YMin,YMax, B),
        asserta(rintangan(A,B))
        )),
    !.

printTheWholeMap :-
    lebarPeta(X),
    tinggiPeta(Y),
    XXX is X +1,
    YYY is Y +1,
    forall(between(0,YYY,YY),
        (forall(between(0,XXX,XX),
            printMap(XX,YY)
        ),nl)
    ),!.


posi :-
    player_position(X,Y),
    write(X), nl,
    write(Y), ! .

n :-
    player_position(X,Y),
    Y > 1,
	Y2 is Y-1,
    X2 is X,
    write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)), !.


s :-
    player_position(X,Y),
    tinggiPeta(YY),
	Y < YY,
	Y2 is Y+1,
    X2 is X,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)), !.

e :-
    player_position(X,Y),
    lebarPeta(XX),
	X < XX,
    Y2 is Y,
	X2 is X+1,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)), !.

w :-
    player_position(X,Y),
	X > 1,
	Y2 is Y,
    X2 is X-1,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)), !.

/* BUAT DEBUGGGGGG DOANGGGGG */

goToGym :-
    posisiGym(A,B),
    X2 is A,
    Y2 is B,
    retract(player_position(_,_)),
	asserta(player_position(X2,Y2)), !.

setHealthTo0 :- 
    Y is 0,
    retract(inventory(Tokemon,_,N,S,NS,T,I)),
    asserta(inventory(Tokemon,Y,N,S,NS,T,I)). 

setHealthToFull :- 
    inventory(Tokemon,Health,N,S,NS,T,I),
    tokemon(Tokemon,Health1,_,_,_,_,_),
    Y is Health1,
    retract(inventory(Tokemon,Health,N,S,NS,T,I)),
    asserta(inventory(Tokemon,Y,N,S,NS,T,I)). 

heal :-
    /* Pemain sudah pernah melakukan heal */
    ctrheal(1),
    write("Tokemon gagal disembuhkan. Anda sudah menggunakan fitur ini."),
    nl,
    !. 
heal :-
    /* Pemain belum pernah melakukan heal dan TIDAK berada di posisi Gym*/
    ctrheal(0),
    player_position(X,_),
    posisiGym(A,_),
    X =\= A,
    write("Anda tidak bisa menggunakan fitur ini karena tidak berada pada posisi Gym."),
    nl,
    !.

heal :-
    /* Pemain belum pernah melakukan heal dan TIDAK berada di posisi Gym*/
    ctrheal(0),
    player_position(_,Y),
    posisiGym(_,B),
    Y =\= B,
    write("Anda tidak bisa menggunakan fitur ini karena tidak berada pada posisi Gym."),
    nl,
    !.


heal :-
    /* Pemain belum pernah melakukan heal dan berada di posisi Gym*/
    ctrheal(0),
    player_position(X,Y),
    posisiGym(A,B),
    X =:= A,
    Y =:= B,
    setHealthToFull,
    write("Tokemon anda sudah disembuhkan!"),
    nl,
    retract(ctrheal(_)),
    asserta(ctrheal(1)) 
    . 