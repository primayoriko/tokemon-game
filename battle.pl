:- dynamic(digym/1).
:- dynamic(udahheal/1).
:- dynamic(maucapture/1).
:- dynamic(udah_lari/1).
:- dynamic(lagi_ketemu/1).
:- dynamic(lagi_pick/1).
:- dynamic(battle_status/1).
:- dynamic(finish_battle/1).
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
finish_battle(0).
pick_time(0).

fight :-
        lagi_ketemu(1), retract(lagi_ketemu(1)), assert(lagi_ketemu(0)),
        retract(pick_time(0)),assert(pick_time(1)),
        retract(battle_status(0)), asserta(battle_status(1)),
        write('Pilih tokemonmu dari tokemon yang tersedia!'),
        !.

fight :- 
        lagi_ketemu(0),
        write('Tidak ada Tokemon yang bisa dilawan!'),nl.

          
run :-  lagi_ketemu(0),
        write('Tidak bisa lari jika pertarungannya tidak ada!'),nl,
        write('Jangan mencoba lari dari kenyataan!'),nl,!.

run :-  lagi_ketemu(1),
        write('anda berlari seperti pengecut'), nl,
        retract(lagi_ketemu(1)),asserta(lagi_ketemu(0)),
        retract(current_tokemon2(A,B,C,D)), !.
        


tulis_battle :-  tokemon(A,_,_,_,_,C,X), current_tokemon1(X,D,LV,_), tokemon(B,_,_,_,_,E,Y), current_tokemon2(Y,F,L,_), 
                    write(A),nl, write('Health: '), write(D),nl, write('Type: '), write(C),nl,write('Level : '),write(LV),nl,nl,
                    write(B),nl, write('Health: '), write(F),nl, write('Type: '), write(E),nl,write('Level : '),write(L),nl,nl,!.

pick(X) :- battle_status(0),pick_time(0), write('Tidak ada pertarungan saat ini'),nl,!.

pick(X) :-  battle_status(1),pick_time(1),
            \+check_inv(X), write('Kamu tidak memiliki Tokemon itu!'),nl,
            write('pilih Tokemon lain!'),nl,!.


pick(X) :-
    battle_status(1),
    pick_time(1),
    inventory(X,B,C,D,E,F,G,LV),
    current_tokemon2(AA,BB,CC,DD),
    write('anda memilih '), write(X),nl,
    asserta(current_tokemon1(G,B,LV,C)),
    CC2 is LV,
    retract(current_tokemon2(AA,BB,CC,DD)),
    assert(current_tokemon2(AA,BB,CC2,DD)),
    retract(pick_time(1)), assert(pick_time(0)),
    tulis_battle,!.



see_result(X, Y) :-
            /* melihat outcome dari battle */
            X=\=0, Y=\=0, !.

see_result(X, Y) :-
            /* melihat outcome dari battle */
            Y =:= 0, 
            write('Selamat anda berhasil mengalahkan tokemon!'), nl,
            write('Ingin mencoba untuk mencapture??'), nl,
            retractall(finish_battle(0), finish_battle(1)),
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
            tokemon(N,_,_,_,_,_,A),tokemon(M,_,_,_,_,_,E),
            write(N),write(' used normal attack!'),nl,
            D2 is (D*(1+(C/5))),
            write(M),write(' took '),write(D), write(' damage'), nl,nl,
            B2 is B - H, F2 is F-D2, 
            (
            (F2 > 0) ->(retract(current_tokemon2(E,F,G,H)),asserta(current_tokemon2(E,F2,G,H)),attackenemy,(B2 >= 0 -> (tulis_battle);(write(':((('))));
            ((F2 =< 0) ->  win)
            )
            ,
            
            !.

attackenemy :-
            current_tokemon1(A,B,C,D),current_tokemon2(E,F,G,H),
            tokemon(AA,_,_,_,_,_,E),tokemon(BB,_,_,_,_,_,A),
            B2 is B - H,
            write(AA),write(' used normal attack!'),nl,
            write(BB),write(' took '),write(H),write(' damage'), nl,nl,
            (B2 =< 0 -> lose;(
            retract(current_tokemon1(A,B,C,D)),asserta(current_tokemon1(A,B2,C,D)),!)),!.

            


special :- 
            battle_status(0),
            write('Tidak sedang bertempur mas, mbak'),nl,!.

special :-
            battle_status(1),
            current_tokemon1(A,B,C,D), current_tokemon2(E,F,G,H),
            ((tokemon(N,_,_,S,P,grass,A),tokemon(_,_,_,_,_,water,E));(tokemon(N,_,_,S,P,water,A),tokemon(_,_,_,_,_,fire,E));(tokemon(N,_,_,S,P,fire,A),tokemon(_,_,_,_,_,grass,E))),
            write(N),write(' used '),write(P),write('!'), nl,
            S2 is S*(1+(C/5)),
            B2 is B - H, F2 is (F-(S2*2)), 
            write('ITS SUPER EFFECTIVE'),nl,nl,
            ((B2 >0, F2 > 0) ->
            (retract(current_tokemon2(E,F,G,H)),asserta(current_tokemon2(E,F2,G,H)),attackenemy,tulis_battle) ;(
            ((B2 > 0 , F2 =< 0) ->  win;(
                    (B2 =< 0, F2 > 0) -> (lose,nl) ;seri)
            )))
            ,!.

special :-
            battle_status(1),
            current_tokemon1(A,B,C,D), current_tokemon2(E,F,G,H),
            ((tokemon(N,_,_,S,P,water,A),tokemon(_,_,_,_,_,grass,E));(tokemon(N,_,_,S,P,grass,A),tokemon(_,_,_,_,_,fire,E));(tokemon(N,_,_,S,P,fire,A),tokemon(_,_,_,_,_,water,E))),
            write(N),write(' used '),write(P),write('!'), nl,
            S2 is S*(1+(C/5)),
            B2 is B - H, F2 is (F-(S2*0.5)), 
            write('ITS NOT VERY EFFECTIVE.....'),nl,nl,
            ((B2 >0, F2 > 0) ->
            (retract(current_tokemon2(E,F,G,H)),asserta(current_tokemon2(E,F2,G,H)),attackenemy,tulis_battle) ;(
            ((B2 > 0 , F2 =< 0) ->  win;(
                    (B2 =< 0, F2 > 0) -> (lose,nl) ;seri)
            )))
            ,!.

special :-
            battle_status(1),
            current_tokemon1(A,B,C,D), current_tokemon2(E,F,G,H),
            tokemon(N,_,_,S,P,_,A),tokemon(_,_,_,_,_,_,E),
            write(N),write(' used '),write(P),write('!'), nl,
            S2 is S*(1+(C/5)),
            B2 is B-H, F2 is ((F-S)), 
            write('ITS NORMALLY EFFECTIVE'),nl,nl,
            ((B2 >0, F2 > 0) ->
            (retract(current_tokemon2(E,F,G,H)),
            asserta(current_tokemon2(E,F2,G,H)),attackenemy,tulis_battle) ;(
            ((F2 =< 0) ->  win;(
                    (B2 =< 0, F2 > 0) -> (lose,nl) ;seri)
            )))
            ,!.



lose :- jumlapokemon(1),
        write('you lose'), 
        retract(gameMain(1)),
        asserta(gameMain(0)),
        retract(battle_status(1)),
        asserta(battle_status(0)),
        nl, !.


lose :-
        maxInventory(X),
        X2 is X-1,
        retract(maxInventory(X)),
        assert(maxInventory(X2)),
        current_tokemon1(A,B,C,O),
        inventory(U,M,O,P,J,I,A,LV),
        retract(current_tokemon1(A,B,LV,O)),
        retract(inventory(U,M,O,P,J,I,A,LV)),
        write(U),write(' has died, pick another'),nl,
        retract(pick_time(0)),assert(pick_time(1)),
        !.




win :-  
        write('YOU WONNNNNNN!!'),nl, retract(battle_status(1)), assert(battle_status(0)),
        current_tokemon1(A,B,L,P),
        current_tokemon2(AA,BB,CC,DD),
        tokemon(NA,_,_,_,_,_,AA),
        tokemon(_,HEA,_,_,_,_,A),
        write(NA),write(' has died'), nl,
        LV is L + 1,
        retract(current_tokemon1(A,B,L,P)),
        inventory(D,E,F,G,H,I,A,L),
        B2 is B+((L/5)*HEA),
        retract(inventory(D,E,F,G,H,I,A,L)), asserta(inventory(D,B2,F,G,H,I,A,LV)),
        retract(tangkaptime(0)),assert(tangkaptime(1)),
        write('Do you want to capture the pokemon?, walk away if you dont'), nl, !.

capture :-
        tangkaptime(0),
        write('u need to win a fight'),nl,
        !.

capture :-
        tangkaptime(1),
        maxInventory(X),
        X >= 6,
        write('you have to drop a pokemon, or you can just walk away'),nl,!.

capture :-
        maxInventory(X),
        X < 6,
        tangkaptime(1),
        retract(tangkaptime(1)),assert(tangkaptime(0)),
        current_tokemon2(A,AA,AAA,AAAA),
        tokemon(B,C,D,E,F,G,A),
        retract(current_tokemon2(A,AA,AAA,AAAA)),
        addToInventory(B), !.