:- dynamic(udah_lari/1).
:- dynamic(lagi_ketemu/1).
:- dynamic(lagi_pick/1).
:- dynamic(battle_status/1).
:- dynamic(tangkaptime/1).
:- dynamic(pick_time/1).

:- include('player.pl').

:- dynamic(current_tokemon1/4). 
/*id tokemon kita, c_health, lvl*/
:- dynamic(current_tokemon2/4). 
/*id tokemon musuh, c_health, lvl*/

digym(0).
udahheal(0).
tangkaptime(0).
pick_time(0).

fight :- 
        lagi_ketemu(0),
        write('Tidak ada Tokemon yang bisa dilawan!'),nl,!.

fight :-
        retract(lagi_ketemu(1)), assert(lagi_ketemu(0)),
        retract(pick_time(0)),assert(pick_time(1)),
        retract(battle_status(0)), asserta(battle_status(1)),
        write('Pilih tokemonmu dari tokemon yang tersedia!').
          
run :-  lagi_ketemu(0),
        write('Tidak bisa lari jika pertarungannya tidak ada!'),nl,
        write('Jangan mencoba lari dari kenyataan!'),nl,!.

run :-  lagi_ketemu(1),
        write('anda berlari seperti pengecut'), nl,
        retract(lagi_ketemu(1)),asserta(lagi_ketemu(0)),
        retract(current_tokemon2(A,B,C,D)), !.

tulis_battle :-  tokemon(A,_,_,_,_,C,X), current_tokemon1(X,D,_,_), tokemon(B,_,_,_,_,E,Y), current_tokemon2(Y,F,_,_), 
                    write(A),nl, write('Health: '), write(D),nl, write('Type: '), write(C),nl,nl,
                    write(B),nl, write('Health: '), write(F),nl, write('Type: '), write(E),nl,!.

pick(X) :- battle_status(0),pick_time(0), write('Tidak ada pertarungan saat ini'),nl,!.

pick(X) :-  battle_status(1),pick_time(1),
            \+check_inv(X), write('Kamu tidak memiliki Tokemon itu!'),nl,
            write('pilih Tokemon lain!'),nl,!.

see_result(X, Y) :-
            /* melihat outcome dari battle */
            X=\=0, Y=\=0, !.

see_result(X, Y) :-
            /* melihat outcome dari battle */
            Y =:= 0, 
            write('Selamat anda berhasil mengalahkan tokemon!'), nl,
            write('Ingin mencoba untuk mencapture??'), nl,
            retractall(tangkaptime(_)), assert(tangkaptime(1)),
            !.

see_result(X, Y) :-
            /* melihat outcome dari battle */
            X =:= 0, 
            write('Tokemon anda mati!!'),
            !.
            
calc_health :-  
            /* menghitung health setelah suatu attack */
            current_tokemon1(X1,E,Y1), current_tokemon2(X2,F,Y2),
            retractall(current_tokemon1(_,_,_,_)),retractall(current_tokemon2(_,_,_,_)),
            (E < 0 -> (assert(current_tokemon1(X1,0,Y1)), assert(current_tokemon1(X1,F,Y1))); 
             (assert(current_tokemon1(X1,E,Y1)), assert(current_tokemon1(X1,F,Y1)))),
            (F < 0 ->(assert(current_tokemon1(X1,E,Y1)), assert(current_tokemon1(X1,0,Y1)));
            (assert(current_tokemon1(X1,E,Y1)), assert(current_tokemon1(X1,F,Y1)))),
            tulis_battle,
            see_result.
/*currentTokemon(id,health,lvl,na)*/
/*tokemon(nama,max health, nattack,sattack,namasatack,type,id)*/

attack :-
            battle_status(1),
            current_tokemon1(A,B,C,D), current_tokemon2(E,F,G,H),
            B2 is B - H, F2 is F-D, 
            ((B2 >0, F2 > 0) ->
            (retract(current_tokemon1(A,B,C,D)),retract(current_tokemon2(E,F,G,H)),
            asserta(current_tokemon1(A,B2,C,D)),asserta(current_tokemon2(E,F2,G,H)),tulis_battle) ;(
            ((B2 > 0 , F2 =< 0) ->  win;(
                    (B2 =< 0, F2 > 0) -> (lose,nl) ;write('seri'))
            )))
            ,!.

lose :-
        current_tokemon1(A,B,C,O),
        retract(current_tokemon1(A,B,C,O)),
        inventory(U,B,O,P,J,I,A),
        retract(inventory(U,B,O,P,J,I,A)),
        write(U),write(' has died, pick another'),nl,
        retract(pick_time(0)),assert(pick_time(1)),
        !.

win :-  
        write('YOU WONNNNNNN!!'),nl, retract(battle_status(1)), assert(battle_status(0)),
        current_tokemon1(A,B,L,P),
        retract(current_tokemon1(A,B,L,P)),
        inventory(D,E,F,G,H,I,A),
        retract(inventory(D,E,F,G,H,I,A)), asserta(inventory(D,B,F,G,H,I,A)),
        retract(tangkaptime(0)),assert(tangkaptime(1)),
        write('Do you want to capture the pokemon?, walk away if you dont'), nl, !.

capture :-
        \+tangkaptime(1),
        write('u need to win a fight'),nl,
        !.

capture :-
        tangkaptime(1),
        retract(tangkaptime(1)),assert(tangkaptime(0)),
        current_tokemon2(X,P,O,L),
        retract(current_tokemon2(X,P,O,L)),
        tokemon(A,B,C,D,E,F,X),
        assertz(inventory(A,B,C,D,E,F,X)),
        write('added' ),write(A),write(' to inventory'),!.
        
specialattack :- 
            battle_status(0),
            write('Tidak sedang bertempur mas, mbak'),nl,!.

specialattack :-
            /* super effective condtion */
            tokemon(Z,_,_,A,W,C,X), current_tokemon1(X,E,_), tokemon(_,_,B,_,_,D,Y), current_tokemon2(Y,F,_),
            (C == "Grass" , D == "Water"; C == "Water" , D == "Fire"; C == "Fire" , D == "Grass"),
            write(Z), write(" use "), write(W), write("!"),nl,
            write("Wow! Super Effective."), nl,
            dmg2 is A*15/10, E2 is E-B, F2 is F-dmg2,
            retractall(current_tokemon1(_,_,_,_)),retractall(current_tokemon2(_,_,_,_)),
            assert(current_tokemon1(X,E2,_)), assert(current_tokemon2(Y,F2,_)),
            calc_health,
            !.

specialattack :- 
            /* less effective condtion */
            tokemon(Z,_,_,A,W,C,X), current_tokemon1(X,E,_), tokemon(_,_,B,_,_,D,Y), current_tokemon2(Y,F,_),
            (C == "Grass" , D == "Water"; C == "Water" , D == "Fire"; C == "Fire" , D == "Grass"),
            write(Z), write(" use "), write(W), write("!"),nl,
            write("So sad! our attack isn't effective."), nl,
            dmg2 is A*5/10, E2 is E-B, F2 is F-dmg2,
            retractall(current_tokemon1(_,_,_,_)),retractall(current_tokemon2(_,_,_,_)),
            assert(current_tokemon1(X,E2,_)), assert(current_tokemon2(Y,F2,_)),
            calc_health,
            !.

specialattack :-
            /* normal condtion */
            tokemon(Z,_,_,A,W,C,X), current_tokemon1(X,E,_), tokemon(_,_,B,_,_,D,Y), current_tokemon2(Y,F,_),
            write(Z), write(" use "), write(W), write("!"),nl,
            E2 is E-B, F2 is F-A,
            retractall(current_tokemon1(_,_,_,_)),retractall(current_tokemon2(_,_,_,_)),
            assert(current_tokemon1(X,E2,_)), assert(current_tokemon2(Y,F2,_)),
            calc_health,
            !.
