:- dynamic(udah_lari/1).
:- dynamic(lagi_ketemu/1).
:- dynamic(battle_status/1).
:- dynamic(tangkaptime/1).
:- dynamic(pick_time/1).

:- include('player.pl').

:- dynamic(current_tokemon1/4). 
/*id tokemon kita, c_health, lvl, nattack*/
:- dynamic(current_tokemon2/4). 
/*id tokemon musuh, c_health, lvl, nattack*/

udahheal(0).
tangkaptime(0).
pick_time(0).

fight :- 
        lagi_ketemu(0),
        write('Tidak ada Tokemon yang bisa dilawan!'),nl,!.

fight :-
        retractall(lagi_ketemu(_)), asserta(lagi_ketemu(0)),
        retractall(pick_time(_)),asserta(pick_time(1)),
        write('Pilih tokemonmu dari tokemon yang tersedia!').
          
run :-  lagi_ketemu(0),
        write('Tidak bisa lari jika pertarungannya tidak ada!'),nl,
        write('Jangan mencoba lari dari kenyataan!'),nl,!.

run :-  lagi_ketemu(1),
        write('anda berlari seperti pengecut'), nl,
        retract(lagi_ketemu(1)),asserta(lagi_ketemu(0)),
        retract(current_tokemon2(A,B,C,D)), !.

tulis_battle :- battle_status(0),
                write(' kamu ngga lg bertempur mas!'), nl, !.

tulis_battle :-  tokemon(A,_,_,_,_,C,X), current_tokemon1(X,D,_,_), tokemon(B,_,_,_,_,E,Y), current_tokemon2(Y,F,_,_), 
                 write(A),nl, write('Health: '), write(D),nl, write('Type: '), write(C),nl,nl,
                 write(B),nl, write('Health: '), write(F),nl, write('Type: '), write(E),nl,!.

pick(X) :- pick_time(0), write('Bukan waktunya untuk mengeluarkan tokemon sekarang!!'),nl,!.

pick(X) :-  pick_time(1),
            \+check_inv(X), write('Kamu tidak memiliki Tokemon itu!'),nl,
            write('pilih Tokemon lain!'),nl,!.

pick(X) :-
        inventory(X,H,A,_,_,_,Z,L),
        asserta(current_tokemon1(Z,H,L,A)),
        write('Kamu memilih '), write(X),write(' untuk bertempur bersamamu!'),nl,
        generateEnemy(L), tulis_battle.

generateEnemy(L):-
        random(1,12,R),
        tokemon(Xe,He,Ae,_,_,_,R),
        retractall(current_tokemon2(_,_,_,_)),
        asserta(current_tokemon2(Xe,He,L,Ae)),
        write('Sekarang kamu menghadapi '), write(Xe),write('! Kalahkan dan semoga berhasil!'),nl,
        retractall(lagi_ketemu(_)), asserta(lagi_ketemu(0)),
        retractall(pick_time(_)), asserta(pick_time(0)),
        retractall(battle_status(_)), asserta(battle_status(1)).

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
attack :-  battle_status(0),
           write('klo ga berantem mau nyerang siapa?!!'), nl, !.

attack :-
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
        inventory(U,B,O,P,J,I,A,C),
        retract(inventory(U,B,O,P,J,I,A,C)),
        write(U),write(' has died, pick another tokemon please!'),nl,
        retract(pick_time(0)),assert(pick_time(1)),
        !.

win :-  
        write('YOU WONNNNNNN!!'),nl, retract(battle_status(1)), assert(battle_status(0)),
        current_tokemon1(A,B,L,P),
        retract(current_tokemon1(A,B,L,P)),
        inventory(D,E,F,G,H,I,A,L),retract(inventory(D,E,F,G,H,I,A,L)), 
        (L=:=30 -> LN is 30 ; LN is L+1), asserta(inventory(D,B,F,G,H,I,A,LN)),
        retract(tangkaptime(0)),assert(tangkaptime(1)),
        write('Do you want to capture the pokemon?, walk away if you dont'), nl, !.

capture :-
        \+tangkaptime(1),
        write('u need to win a fight!!!!!'),nl,
        !.

capture :-
        tangkaptime(1),
        retract(tangkaptime(1)),assert(tangkaptime(0)),
        current_tokemon2(X,P,O,L),
        retract(current_tokemon2(X,P,O,L)),
        random(1,100,R), R>35,
        tokemon(A,B,C,D,E,F,X),
        assertz(inventory(A,B,C,D,E,F,X,1)),
        write(A),write(' added'),write(' to your inventory!'),nl,!.

capture :- 
        write('Gagal mencapture! mohon bersabar, ini ujian.'), nl.
        
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

battle:- 
    retractall(lagi_ketemu(_)), asserta(lagi_ketemu(1)),
    write('anda bertemu tokemon liar dan ganas!'),nl,
    write('fight or run?'),nl,!.