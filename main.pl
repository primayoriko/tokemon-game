:- include('init.pl').
:- include('map.pl').

start :-
	game_status(mulai),
	write('Game sudah dimulai!'),nl,
	!.

start :-
	write(' ╔════╗╔═══╗╔╗╔═╗╔═══╗╔═╗╔═╗╔═══╗╔═╗─╔╗'),nl,
	write('	║╔╗╔╗║║╔═╗║║║║╔╝║╔══╝║║╚╝║║║╔═╗║║║╚╗║║'),nl,
	write('	╚╝║║╚╝║║─║║║╚╝╝─║╚══╗║╔╗╔╗║║║─║║║╔╗╚╝║'),nl,
	write('	──║║──║║─║║║╔╗║─║╔══╝║║║║║║║║─║║║║╚╗║║'),nl,
	write('	──║║──║╚═╝║║║║╚╗║╚══╗║║║║║║║╚═╝║║║─║║║'),nl,
	write('	──╚╝──╚═══╝╚╝╚═╝╚═══╝╚╝╚╝╚╝╚═══╝╚╝─╚═╝ '),nl,
	help,nl,nl,
	legend,
	write('Halo! <story>.'),nl,
	write('Selamat bermain! Good luck!'),nl,
	init_map,
	retract(game_status(_)), asserta(game_status(mulai)),
	!.

help :-
	write('Daftar Command : '),nl,
	write('1. start : Untuk memulai permainan.'),nl,
	write('2. map : Menampilkan peta beserta posisi pemain dan gym saat ini.'),nl,
	write('3. heal : Mengobati tokemon yang dimiliki player saat ini(Hanya bisa di Gym Center "G").'),nl,
	write('4. w : Bergerak kearah Utara(atas).'),nl,
	write('5. s : Bergerak kearah Timur(kanan).'),nl,
	write('6. a : Bergerak kearah Barat(kiri).'),nl,
	write('7. d : Bergerak kearah Selatan(bawah).'),nl,
	write('8. quit : Keluar dari permainan.'),nl,
	write('9. pick(tokemon) : Memilih tokemon yang akan digunakan untuk bertarung(hanya dalam battle).'),nl,
	write('10. attack : Melakukan serangan normal ke tokemon musuh(hanya dalam battle).'),nl,
	write('11. run : Melarikan diri dari battle saat ini(hanya dalam battle).'),nl,
	write('12. specialattack : Menyerang tokemon musuh dengan serangan spesial(hanya dalam battle).'),nl,
	write('13. drop(tokemon) : Melepaskan tokemon yang dipilih dari inventori pemain.'),nl,
	write('14. status : Melihat status tokemon yang dimiliki dan tokemon legendaris yang harus dikalahkan.'),nl,
	write('15. save(filename) : Menyimpan permainan pemain(belum).'),nl,
	write('16. loads(filename) : Membuka save-an pemain(belum).'),nl,
	write('17. help : Menampilkan daftar command.'),nl,
  	write('Catatan : Semua command di atas diakhiri titik (Misal : "help.")'), nl, !.
	
legend :-
	write('Legenda Peta: '),nl,
	write('-  X = Pagar '),nl,
	write('-  P = Player '),nl,
	write('-  G = Gym Center '),nl, !.
	

map :-
	\+game_status(mulai),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
map :- !.

	
status :-
	\+game_status(mulai),
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
		  	))*/!.
	
/*loads(_) :-
	game_status(mulai),
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
	\+game_status(mulai),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
save(FileName):- !. 
*/
