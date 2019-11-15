:- include('move.pl').

:- dynamic(game_status/1).
game_status(0).

start :-
	game_status(1),
	write('Game sudah dimulai!'),nl,
	write('Selesaikan dahulu apa yang sudah kamu mulai!'),nl,
	write('Great power comes with great responsibility'),nl,
	!.

start :-
	/*write(' ╔════╗╔═══╗╔╗╔═╗╔═══╗╔═╗╔═╗╔═══╗╔═╗─╔╗'),nl,
	write('	║╔╗╔╗║║╔═╗║║║║╔╝║╔══╝║║╚╝║║║╔═╗║║║╚╗║║'),nl,
	write('	╚╝║║╚╝║║─║║║╚╝╝─║╚══╗║╔╗╔╗║║║─║║║╔╗╚╝║'),nl,
	write('	──║║──║║─║║║╔╗║─║╔══╝║║║║║║║║─║║║║╚╗║║'),nl,
	write('	──║║──║╚═╝║║║║╚╗║╚══╗║║║║║║║╚═╝║║║─║║║'),nl,
	write('	──╚╝──╚═══╝╚╝╚═╝╚═══╝╚╝╚╝╚╝╚═══╝╚╝─╚═╝ '),nl,nl*/
	write('Kamu adalah mahasiswa biasa, normal, dan punya sedikit teman, dan berharap memiliki masa depan yang cerah.'),nl,
	write('Hari-hari berjalan dengan cukup normal, dan dibumbui dengan sedikit perasaan depresi khas mahasiswa.'),nl,
	write('Hingga suatu hari, saat kamu sedang merenung di plaza widya, kamu melihat meteor dengan kecepatan tinggi '),nl,
	write('dan menghantam bumi. Tanah bergetar hebat, dan seketika pandanganmu membuyar.'),nl,nl,
	write('Saat tersadar, kamu didunia yang tidak sama lagi. Dunia dipenuhi makhluk-makhluk aneh. Berkat bantuan'),nl,
	write('Prof. Rila M. yang telah menyelamatkanmu, kamu mengetahui meteor tersebut membawa wabah virus dan mengubah orang-orang'),nl,
	write('menjadi makhluk unik bernama Tokemon. Kini Prof. Rila tengah mengembangkan serum untuk mengatasi wabah dan mengembalikan orang-orang.'),nl,
	write('Kini tugasmu adalah membantu Prof Rila mengalahkan tokemon spesial yang luar biasa kuat dan mengambil sampel darahnya guna '),nl,
	write('pembuatan serum. Kamu dibantu dengan alat hasil penelitian Prof. Rila bisa menjinakkan tokemon-tokemon tersebut'),nl,
	write('sekarang bantu Prof. Rila untuk segera mengalahkan tokemon spesial sebelum korban-korban sulit ditolong kembali!'),nl,nl,nl,
	help,nl,nl,
	legend,nl,nl,
	write('Halo! <story>.'),nl,
	write('Selamat bermain! Good luck!'),nl,nl,
	init_map,
	asserta(game_status(1)),
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
	\+game_status(1),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
map :- !.

	
status :-
	\+game_status(1),
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
