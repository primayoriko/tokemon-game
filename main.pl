/*update :-
	sudahMenang(Menang),Menang == true,
	write('     my story   '),nl,
	quit,!.

update :- !. */

start :-
	gameMain(_),
	write('Kamu tidak bisa memulai game ketika game sudah dimulai.'), nl, !.

start :-
	write('  my story '),nl,
	write('Game Mulai'),nl,
	asserta(gameMain(1)),
	init_map,
	!.

map :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
map :- !.

status :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
	
status :- 
	write('Stat/Inventori:         '), nl,
	write('Kapasitas inventori:    '), write('6 slot'),nl,
	write('Sisa inventori:         '), nl,
	write('Jumlah Koleksi Tokemon: '), nl,
	write('Koleksi:                '), nl,
		  /*tokemon(_,_,_)->( # fact tokemon(nama, health, tipe)
			write('Tokemon Anda:')
			forall(tokemon(Nama,Health,Tipe),
			(
				(write(Nama),nl);
				(write(Health),nl);
				(write(Tipe),nl);
			),nl,nl
			));!,*/
        write('Blacklist Legendary Tokemon:    '),
		  /*legendaryTokemon(_,_,_)->( # fact legendaryTokemon(nama, health, tipe)
		  	forall(legendaryTokemon(Nama,Health,Tipe),
		  	(
		  		(write(Nama),nl);
		  		(write(Health),nl);
		  		(write(Tipe),nl);
		  	),nl,nl
		  	))*/
!.
help :- !.

/*loads(_) :-
	gameMain(_),
	write('Kamu tidak bisa memulai game lainnya ketika ada game yang sudah dimulai.'), nl, !.
    
loads(FileName):-
	\+file_exists(FileName),
	write('File tersebut tidak ada.'), nl, !.

loads(FileName):-
	open(FileName, read, Str),
    read_file_lines(Str,Lines),
    close(Str),
    assertaList(Lines), !.

save(_):-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.

save(FileName):- !. 

*/


