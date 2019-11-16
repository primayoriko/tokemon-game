:- include('map.pl').
:- include('player.pl').

:- dynamic(battle_status/1).
:- dynamic(current_tokemon1/3). /*id tokemon kita, c_health, lvl*/
:- dynamic(current_tokemon2/3). /*id tokemon musuh, c_health, lvl*/
:- dynamic(udah_lari/1).
:- dynamic(lagi_ketemu/1).
:- dynamic(lagi_pick/1).
:- dynamic(digym/1).
:- dynamic(udahheal/1).
:- dynamic(maucapture/1).

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


attack :- battle_status(0),
          write("Kamu tidak sedang bertarung."),nl,!.

attack :-
            battle_status(1),
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,D,_), tokemon(_,_,B,_,_,E,Y), current_tokemon2(Y,F,_),
            D2 is D-B, F2 is F-A, D2>0, F2>0,
            retractall(current_tokemon1(_,_,_)),retractall(current_tokemon2(_,_,_)),
            assert(current_tokemon1(X,D2,_)), assert(current_tokemon2(Y,F2,_)).

attack :-
            battle_status(1),
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,D,_), tokemon(_,_,B,_,_,E,Y), current_tokemon2(Y,F,_),
            D2 is D-B, F2 is F-A, D2>0, F2=:=0,
            retract(battle_status(1)),assert(battle_status(0)),
            retract(maucapture(0)),assert(maucapture(1)), 
            write("Tokemon telah ").


