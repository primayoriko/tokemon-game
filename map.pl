:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(posisiGym/2).
:- dynamic(rintangan/2).
:- dynamic(ctrheal/1).
:- dynamic(posisiLegendary/3).


:- include('battle.pl').
/*UNTUK DEBUG*/
posisiLegendary(inkmon,10,10).
posisiLegendary(yorikomon,20,20).
posisiLegendary(iqbalmon,11,11).
posisiLegendary(malmon,21,21).
posisiLegendary(ascalon,22,22).

init_map :-
    random(10,20,X),
    random(10,20,Y),
    asserta(ctrheal(0)),
    asserta(lebarPeta(X)),
    asserta(tinggiPeta(Y)),
    asserta(player_position(1,1)),
    generateGym,
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
/* BUAT DEBUGGGGGG DOANGGGGG */

goToGym :-
    posisiGym(A,B),
    X2 is A,
    Y2 is B,
    retract(player_position(_,_)),
	asserta(player_position(X2,Y2)), !.

setHealthTo0 :-
    /* BUAT DEBUGGGGGG DOANGGGGG */
    forall(retract(inventory(Tokemon,_,N,S,NS,T,I,J)),asserta(inventory(Tokemon,0,N,S,NS,T,I,J))).

setHealthToFull :-
    /* Prosedur untuk mengheal semua tokemon */
    forall(inventory(Tokemon,Health,N,S,NS,T,I,J),
    forall(tokemon(Tokemon,Health1,_,_,_,_,_),
    forall(Y is Health1,
    forall(retract(inventory(Tokemon,Health,N,S,NS,T,I,J)),
    asserta(inventory(Tokemon,Y,N,S,NS,T,I,J)))))).

heal :-
    /* Pemain belum pernah melakukan heal dan berada di posisi Gym*/
    ctrheal(0),
    player_position(X,Y),
    posisiGym(A,B),
    X is A,
    Y is B, 
    setHealthToFull,
    write('Tokemon anda sudah disembuhkan!'),
    nl,
    retract(ctrheal(_)),
    asserta(ctrheal(1)) ,!. 
    
heal :-
    /* Pemain sudah pernah melakukan heal */
    ctrheal(1), ! ,write('udah heal'),
    write('Tokemon gagal disembuhkan. Anda sudah menggunakan fitur ini.'),
    nl. 


heal :-
    /* Pemain belum pernah melakukan heal dan TIDAK berada di posisi Gym*/
    ctrheal(0),
    player_position(X,Y),
    posisiGym(A,B),
    (Y =\= B; X  =\= A),
    write('Anda tidak bisa menggunakan fitur ini karena tidak berada pada posisi Gym.'),
    nl,
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
generateGym :-
    lebarPeta(X),
    tinggiPeta(Y),
    XMin is 2,
    XMax is X,
    YMin is 2,
    YMax is Y,
    Sum is round(X*Y/100),

    forall(between(1,Sum,_),(
        random(XMin,XMax,A),
        random(YMin,YMax,B),
        asserta(posisiGym(A,B))
    )),
    !.
map :-
    lebarPeta(X),
    tinggiPeta(Y),
    XXX is X+1,
    YYY is Y+1,
    forall(between(0,YYY,YY),
        (forall(between(0,XXX,XX),
            printMap(XX,YY)
        ),nl)
    ),!.


posi :-
    player_position(X,Y),
    write(X), nl,
    write(Y), ! .

n:-
    gameMain(1),
    (lagi_ketemu(1);battle_status(1)),
    write('lagi ada pokemon jgn caw dong'),nl, !.

n :-
    gameMain(1),
    player_position(_,Y),
    Y < 2,
    write('nabrak bray'),nl,
    !.

n:-
    gameMain(1),
    player_position(X,Y),
	Y2 is Y-1,
    X2 is X,
    isRintangan(X2,Y2),
    write('gabisa cuy ada rintangan'),!.

n :-
    gameMain(1),
    tangkaptime(J),
    retract(tangkaptime(J)),asserta(tangkaptime(0)),
    (J =:= 1 -> (write('u have left the pokemon'),nl) ; nl),
    player_position(X,Y),
	Y2 is Y-1,
    X2 is X,
    write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)),roll, !.


s :-
    gameMain(1),
    (lagi_ketemu(1);battle_status(1)),
    write('lagi ada pokemon jgn caw dong'),nl, !.

s :-
    gameMain(1),
    player_position(_,Y),
    tinggiPeta(YY),
    YYY is YY-1,
    Y > YYY,
    write('nabrak bray'),nl,
    !.

s :-
    gameMain(1),
    player_position(X,Y),
	Y2 is Y+1,
    X2 is X,
    isRintangan(X2,Y2),
    write('gabisa cuy ada rintangan'),!.

s :-
    gameMain(1),
    tangkaptime(J),
    retract(tangkaptime(J)),asserta(tangkaptime(0)),
    (J =:= 1 -> (write('u have left the pokemon'),(current_tokemon2(L,K,O,P),retract(current_tokemon2(L,K,O,P))),nl) ; nl),
    player_position(X,Y),
    tinggiPeta(YY),
	Y < YY,
	Y2 is Y+1,
    X2 is X,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)),
    roll, !.

e:-
    gameMain(1),
    (lagi_ketemu(1);battle_status(1)),
    write('lagi ada pokemon jgn caw dong'),nl, !.

e :-
    gameMain(1),
    player_position(X,_),
    lebarPeta(XX),
    XXX is XX-1,
    X > XXX,
    write('nabrak bray'),nl,
    !.

e :-
    gameMain(1),
    player_position(X,Y),
	Y2 is Y,
    X2 is X+1,
    isRintangan(X2,Y2),
    write('gabisa cuy ada rintangan'),!.

e :-
    gameMain(1),
    tangkaptime(J),
    retract(tangkaptime(J)),asserta(tangkaptime(0)),
    (J =:= 1 -> (write('u have left the pokemon'),(current_tokemon2(L,K,O,P),retract(current_tokemon2(L,K,O,P))),nl) ; nl),
    player_position(X,Y),
    lebarPeta(XX),
	X < XX,
    Y2 is Y,
	X2 is X+1,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)),
    roll, !.

w :-
    gameMain(1),
    (lagi_ketemu(1);battle_status(1)),
    write('lagi ada pokemon jgn caw dong'),nl, !.

w :-
    gameMain(1),
    player_position(X,_),
    X < 2,
    write('nabrak bray'),nl,
    !.

w :-
    gameMain(1),
    player_position(X,Y),
	Y2 is Y,
    X2 is X-1,
    isRintangan(X2,Y2),
    write('gabisa cuy ada rintangan'),!.

w :-
    gameMain(1),
    tangkaptime(J),
    retract(tangkaptime(J)),asserta(tangkaptime(0)),
    (J =:= 1 -> (write('u have left the pokemon'),nl) ; nl),
    player_position(X,Y),
	X > 1,
	Y2 is Y,
    X2 is X-1,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)), 
    roll, !.

roll :-
    posisiGym(A,B),
    player_position(X,Y),
    X =:= A, Y =:= B,
    write('welcome to the gym!'),nl, 
    write('do you wish to heal?'), ! .


roll :-
    posisiGym(A,B),
    player_position(X,Y),
    (B =\= Y; A =\= X),
    random(1,100,C), encounterroll(C),!.

encounterroll(X) :-
    X > 15 -> write('moved');
    (X < 12) -> battletest(X).


battletest(X) :- 
    retract(lagi_ketemu(0)),
    asserta(lagi_ketemu(1)),
    tokemon(A,B,C,D,E,F,X),
    write('anda bertemu '), write(A), write(' liar!'),
    asserta(current_tokemon2(X,B,1,C)),
    write('fight or run?'),nl,!.