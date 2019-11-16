:- include('map.pl').

:- dynamic(digym/1).
:- dynamic(udahheal/1).
:- dynamic(maucapture/1).
:- dynamic(udah_lari/1).
:- dynamic(lagi_ketemu/1).
:- dynamic(lagi_pick/1).
:- dynamic(battle_status/1).

:- dynamic(current_tokemon1/3). 
/*id tokemon kita, c_health, lvl*/
:- dynamic(current_tokemon2/3). 
/*id tokemon musuh, c_health, lvl*/

digym(0).
udahheal(0).
battle_status(0).

fight :- lagi_ketemu(1), retract(lagi_ketemu(1)), assert(lagi_ketemu(0)),
         retract(battle_status(0)), assert(battle_status(1)),
         write('Pilih tokemonmu dari tokemon yang tersedia!'),
         /* list_pokemon */
         /* pick gitu */
         tulis_battle,
         !.

fight :- write("Tidak ada Tokemon yang bisa dilawan!"),nl.

          
run :-  lagi_ketemu(0),
        write("Tidak bisa lari jika pertarungannya tidak ada!"),nl,
        write("Jangan mencoba lari dari kenyataan!"),nl.
        
        
run :- lagi_ketemu(1),
       udah_lari(0),
       random(1,100,X),X>35,
       write("Gagal lari!"),
       write("Pilih tokemonmu dengan command pick!"),
       tulis_tokemon,retract(udah_lari),asserta(udah_lari(1)),!.

run :- udah_lari(1),
       write("Kamu sudah pernah berlari! Tidak boleh berlari lagi!"),
       write("Pilih tokemonmu dengan command pick!"),
       tulis_tokemon,!.
       
roll :- 
    player_position(A,B),
    \+isGym(A,B),
    (digym(1) -> retract(digym(1)),asserta(digym(0)),write('anda telah meninggalkan gym'),nl);
    random(1,100,X),
    (X mod 4 =:= 0 -> write("Ada Tokemon liar!"),nl, write("pilih command fight atau run!"),nl),!.

roll :-
    player_position(A,B),
    isGym(A,B),
    retract(digym(0)),
    asserta(digym(1)),
    write('Selamat datang di Gym, apakah hendak mengheal?'),nl.

heal :-
    digym(0),
    write('anda ga di gym'),nl.

heal :-
    digym(1),
    retract(udahheal(0)),
    asserta(udahheal(1)),
    write('your pokemon has been healed'),nl.

tulis_battle :-  tokemon(A,_,_,_,_,C,X), current_tokemon1(X,D,_), tokemon(B,_,_,_,_,E,Y), current_tokemon2(Y,F,_), 
                    write(A),nl, write("Health: "), write(D),nl, write("Type: "), write(C),nl,nl,
                    write(B),nl, write("Health: "), write(F),nl, write("Type: "), write(E),nl,!.

pick(X) :- battle_status(0), write("Tidak ada pertarungan saat ini"),nl,!.

pick(X) :-  battle_status(1),
            \+check_inv(X), write("Kamu tidak memiliki Tokemon itu!"),nl,
            write("pilih Tokemon lain!"),nl,!.

pick(X) :-  
            battle_status(1),
            check_inv(X),tokemon(X,A,_,_,_,_,Y), 
            retractall(current_tokemon1(_,_,_)), retractall(current_tokemon2(_,_,_)), 
            random(1,12,Z), tokemon(_,B,_,_,_,_,Z),
            assert(current_tokemon1(Y,A,1)),assert(current_tokemon2(Z,B,1)),
            tulis_battle,!.

capture :- 
            /* Kondisi prasyarat tak terpenuhi */
            write('Anda mesti baru saja mengalahkan tokemon untuk capture!!'),nl,!.

capture :- 
            /* Kondisi prasyarat tak terpenuhi krn inven penuh*/
            write('Inventory penuh!! Drop salah satu tokemon pada inventory!'),nl,!.

capture :- 
            random(1,100,Y),
            ((current_tokemon2(X,_,_), X>12) -> Y < 80 ; Y < 20),
            write('Tokemon gagal di-capture'),!.

capture :- 
            /* aksi di capture  */
            !.

capture :- 
            write('Anda gagal men-capturenya!, better luck next time!!'), nl.

see_result(X, Y) :-
            /* melihat outcome dari battle */
            X=\=0, Y=\=0, !.

see_result(X, Y) :-
            /* melihat outcome dari battle */
            Y =:= 0, 
            write('Selamat anda berhasil mengalahkan tokemon!'), nl,
            write('Ingin mencoba untuk mencapture??'), nl,
            !.

see_result(X, Y) :-
            /* melihat outcome dari battle */
            X =:= 0, 
            write('Tokemon anda mati!!'),
            !.
            
calc_health :-
            /* menghitung health setelah suatu attack */
            current_tokemon1(X1,E,Y1), current_tokemon2(X2,F,Y2),
            retractall(current_tokemon1(_,_,_)),retractall(current_tokemon2(_,_,_)),
            (E < 0 ->       ;      ),
            (F < 0 ->       ;        ),
            tulis_battle,
            see_result.

attack :-  battle_status(0),
           write("Kamu tidak sedang bertarung."),nl,!.

attack :-
            battle_status(1),
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,D,_), tokemon(_,_,B,_,_,E,Y), current_tokemon2(Y,F,_),
            D2 is D-B, F2 is F-A, D2>0, F2>0,
            retractall(current_tokemon1(_,_,_)),retractall(current_tokemon2(_,_,_)),
            assert(current_tokemon1(X,D2,_)), assert(current_tokemon2(Y,F2,_)).

/*tokemon(nama, max health, nattack, sattack, namasatack, type, id)*/
attack :-
            battle_status(1),
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,D,_), tokemon(_,_,B,_,_,E,Y), current_tokemon2(Y,F,_),
            D2 is D-B, F2 is F-A, D2>0, F2=:=0,
            retract(battle_status(1)),assert(battle_status(0)),
            retract(maucapture(0)),assert(maucapture(1)), 
            write("Tokemon telah ").

attack :-
            battle_status(1),
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,D,_), tokemon(_,_,B,_,_,E,Y), current_tokemon2(Y,F,_),
            D2 is D-B, F2 is F-A, D2>0, F2=:=0,
            retract(battle_status(1)),assert(battle_status(0)),
            retract(maucapture(0)),assert(maucapture(1)), 
            write("Tokemon telah ").

specialattack :- 
            battle_status(0),
            write('Tidak sedang bertempur mas, mbak'),nl,!.

specialattack :-
            /* super effective condtion */
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,E,_), tokemon(_,_,B,_,_,D,Y), current_tokemon2(Y,F,_),
            (C == "Grass" , D == "Water"; C == "Water" , D == "Fire"; C == "Fire" , D == "Grass"),
            write("Wow! Super Effective."), nl,
            !.

specialattack :- 
            /* less effective condtion */
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,E,_), tokemon(_,_,B,_,_,D,Y), current_tokemon2(Y,F,_),
            (C == "Grass" , D == "Water"; C == "Water" , D == "Fire"; C == "Fire" , D == "Grass"),
            write("So sad! our attack isn't effective."), nl,
            !.

specialattack :-
            /* normal condtion */
            !.

enemyattack :-




            
