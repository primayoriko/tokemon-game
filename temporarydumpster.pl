/dari battle.pl/

/* BERISI YANG MEMBIINGUNGKAN AQIL DAN DIPINDAHKAN SEMENTARA*/
run :- lagi_ketemu(1),
       udah_lari(0),
       random(1,100,X),X>35,
       write("Gagal lari!"),
       write("Pilih tokemonmu dengan command pick!"),
       tulis_tokemon,retract(udah_lari),asserta(udah_lari(1)),!.

               
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
    
pick(X) :-  
            battle_status(1),
            check_inv(X),tokemon(X,A,_,_,_,_,Y), 
            retractall(current_tokemon1(_,_,_,_)), retractall(current_tokemon2(_,_,_,_)), 
            random(1,12,Z), tokemon(_,B,_,_,_,_,Z),
            assert(current_tokemon1(Y,A,1)),assert(current_tokemon2(Z,B,1)),
            tulis_battle,!.

    
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

attack :-  battle_status(0),
           write("Kamu tidak sedang bertarung."),nl,!.

attack :-
            battle_status(1),
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,D,_,_), tokemon(_,_,B,_,_,E,Y), current_tokemon2(Y,F,_,_),
            D2 is D-B, F2 is F-A, D2>0, F2>0,
            retractall(current_tokemon1(_,_,_,_)),retractall(current_tokemon2(_,_,_,_)),
            assert(current_tokemon1(X,D2,_)), assert(current_tokemon2(Y,F2,_)),
            calc_health.

/*tokemon(nama, max health, nattack, sattack, namasatack, type, id)*/
attack :-
            battle_status(1),
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,D,_,_), tokemon(_,_,B,_,_,E,Y), current_tokemon2(Y,F,_,_),
            D2 is D-B, F2 is F-A, D2>0, F2=:=0,
            retract(battle_status(1)),assert(battle_status(0)),
            retractall(current_tokemon1(_,_,_,_)),retractall(current_tokemon2(_,_,_,_)),
            assert(current_tokemon1(X,D2,_)), assert(current_tokemon2(Y,F2,_)),
            calc_health.

attack :-
            battle_status(1),
            tokemon(_,_,A,_,_,C,X), current_tokemon1(X,D,_,_), tokemon(_,_,B,_,_,E,Y), current_tokemon2(Y,F,_,_),
            D2 is D-B, F2 is F-A, D2>0, F2=:=0,
            retract(battle_status(1)),assert(battle_status(0)),
            retractall(current_tokemon1(_,_,_,_)),retractall(current_tokemon2(_,_,_,_)),
            assert(current_tokemon1(X,D2,_)), assert(current_tokemon2(Y,F2,_)),
            calc_health.


capture :- 
            /* Kondisi prasyarat tak terpenuhi */
            write('Anda mesti baru saja mengalahkan tokemon untuk capture!!'),nl,!.

capture :- 
            /* Kondisi prasyarat tak terpenuhi krn inven penuh*/
            inventory_used(6),
            write('Inventory penuh!! Drop salah satu tokemon pada inventory!'),nl,!.

capture :- 
            random(1,100,Y),
            ((current_tokemon2(X,_,_), X>12) -> Y < 80 ; Y < 20),
            write('Tokemon gagal di-capture'),nl,!.

capture :-  
            /* aksi di capture  */
            !.

capture :- 
            write('Anda gagal men-capturenya!, better luck next time!!'), nl.