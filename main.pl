:- include('map.pl').
:- include('player.pl').

:- dynamic(legendmati/1).
:- dynamic(game_status/1).

game_status(0).

start :-
	game_status(1),
	write('Game sudah dimulai!'),nl,
	write('Selesaikan dahulu apa yang sudah kamu mulai!'),nl,
	write('Great power comes with great responsibility'),nl,
	!.

start :-
	nl,
	write('88888 .d88b. 8  dP 8888 8b   d8 .d88b. 8b  8 '),nl,
	write('  8   8P  Y8 8wdP  8www 8YbmdP8 8P  Y8 8Ybm8 '),nl,
	write('  8   8b  d8 88Yb  8    8  "  8 8b  d8 8  "8 '),nl,
	write('  8    Y88P  8  Yb 8888 8     8  Y88P  8   8 '),nl,nl,nl,
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
	help,nl,nl,nl,
	assert(legendmati(0)),
	legend,nl,nl,nl,
	retract(game_status(0)),asserta(game_status(1)),
	write('Selamat bermain! Good luck!'),nl,nl,
	init_player, init_map,
	!.

quit :-
	game_status(0),
	write('Belum juga mulai gamenya -_-'),nl,!.
   
quit :-
	game_status(1),retract(game_status(1)),assert(game_status(0)),
	(udahheal(_)->retractall(udahheal(_))),assert(udahheal(0)),retract(tangkaptime(_)),assert(tangkaptime(0)),
	retract(pick_time(_)),assert(pick_time(0)),
	(lebarPeta(_)->retract(lebarPeta(_))),(tinggiPeta(_)->retract(tinggiPeta(_))),(posisiGym(_,_)->retractall(posisiGym(_,_))),(rintangan(_,_)->retractall(rintangan(_,_))),(ctrheal(_)->retractall(ctrheal(_))),
	(player_position(_,_)->retract(player_position(_,_))),(inventory(_,_,_,_,_,_,_,_)->retractall(inventory(_,_,_,_,_,_,_,_))),(maxInventory(_)->retract(maxInventory(_))),(gameMain(_)->retractall(gameMain(_))),
	write('Terima Kasih telah bermain!'),nl,
	write('Sampai jumpa lagi!'),nl,!.

help :-
	write('Daftar Command : '),nl,
	write('1. start : Untuk memulai permainan.'),nl,
	write('2. map : Menampilkan peta beserta posisi pemain dan gym saat ini.'),nl,
	write('3. heal : Mengobati tokemon yang dimiliki player saat ini(Hanya bisa di Gym Center "G").'),nl,
	write('4. n : Bergerak kearah Utara(atas).'),nl,
	write('5. e : Bergerak kearah Timur(kanan).'),nl,
	write('6. w : Bergerak kearah Barat(kiri).'),nl,
	write('7. s : Bergerak kearah Selatan(bawah).'),nl,
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


	
status :-
	\+game_status(1),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
	
	
status :- 
	write('Stat/Inventori:         '), nl,
	write('Kapasitas inventori:    '), write('6 slot'),nl,
	maxInventory(X),
	Y is 6-X,
	write('Sisa inventori:         '), write(Y), write(' slot'),nl,
	write('Jumlah Koleksi Tokemon: '), write(X), write(' tokemon'),nl,
	write('Koleksi:                '), nl,
	printInventory,
	writeln('List Legendary Tokemon liar:    '),
	printLegendaryTokemon(inkmon),
	printLegendaryTokemon(yorikomon),
	printLegendaryTokemon(iqbalmon),
	printLegendaryTokemon(malmon),
	printLegendaryTokemon(ascalon),
	printLegendaryTokemon(tokeqil),
	printLegendaryKosong,
	!.

printLegendaryKosong :-
	findall(Tokemon,(tokemon(Tokemon,_,_,_,_,_,X),
	X > 12,inventory(Tokemon,_,_,_,_,_,_,_)),ListLegendary),
    length(ListLegendary, Panjang),
	Panjang =\= 6,
	!.

printLegendaryKosong :-
	findall(Tokemon,(tokemon(Tokemon,_,_,_,_,_,X),
	X > 12,inventory(Tokemon,_,_,_,_,_,_,_)),ListLegendary),
    length(ListLegendary, Panjang),
	Panjang =:= 5,
	writeln('Tidak ada legendary tokemon liar'),
	!.


printLegendaryTokemon(Tokemon):-
	tokemon(Tokemon,_,_,_,_,_,X),
	X > 12,
	inventory(Tokemon,_,_,_,_,_,_,_),
	!.
printLegendaryTokemon(Tokemon):-
	tokemon(Tokemon,A,B,C,D,E,X),
	X > 12,
	\+inventory(Tokemon,_,_,_,_,_,_,_),
	posisiLegendary(Tokemon,XX,YY),
	write('Tokemon: '), writeln(Tokemon),
	write('   Health: '),writeln(A),
	write('   Normal attack: '),writeln(B),
	write('   Special attack: '),writeln(C),
	write('   Nama special attack: '),writeln(D),
	write('   Type: '),writeln(E),
	write('   ID: '),writeln(X),
	write('   Posisi: '),write(XX),write(','),write(YY),nl,
	!.

save(_):-
	\+game_status(1),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
save(FileName):- 
	tell(FileName),
		forall(game_status(X), (write(game_status(X)),write('.'),nl)),
		forall(legendmati(X), (write(legendmati(X)),write('.'),nl)),
		
		forall(tinggiPeta(L), (write(tinggiPeta(L)),write('.'),nl)),
		forall(lebarPeta(L), (write(lebarPeta(L)),write('.'),nl)),
		forall(ctrheal(C), (write(ctrheal(C)),write('.'),nl)),
		forall(rintangan(X,Y),(write(rintangan(X,Y)),write('.'),nl )),
		forall(posisiGym(X,Y),(write(posisiGym(X,Y)),write('.'),nl )),
		forall(posisiLegendary(N,X,Y),(write(posisiLegendary(N,X,Y)),write('.'),nl )),

		forall(player_position(Xp,Yp), (write(player_position(Xp,Yp)),write('.'),nl)),
		forall(maxInventory(M), (write(maxInventory(M)),write('.'),nl)),
		forall(inventory(A,B,C,D,E,F,G,H), (write(inventory(A,B,C,D,E,F,G,H)),write('.'),nl)),
		forall(gameMain(C), (write(gameMain(C)),write('.'),nl)),
		
		forall(digym(X), (write(digym(X)),write('.'),nl)),
		forall(udahheal(X), (write(udahheal(X)),write('.'),nl)),
		forall(maucapture(X), (write(maucapture(X)),write('.'),nl)),
		forall(udah_lari(X), (write(udah_lari(X)),write('.'),nl)),
		forall(lagi_ketemu(X), (write(lagi_ketemu(X)),write('.'),nl)),
		forall(lagi_pick(X), (write(lagi_pick(X)),write('.'),nl)),
		forall(battle_status(X), (write(battle_status(X)),write('.'),nl)),
		forall(finish_battle(X), (write(finish_battle(X)),write('.'),nl)),
		forall(tangkaptime(X), (write(tangkaptime(X)),write('.'),nl)),
		forall(pick_time(X), (write(pick_time(X)),write('.'),nl)),
		forall(specials(X), (write(specials(X)),write('.'),nl)),		
		forall(current_tokemon1(X,Y,Z,W),(write(current_tokemon1(X,Y,Z,W)),write('.'),nl)),
		forall(current_tokemon2(X,Y,Z,W),(write(current_tokemon2(X,Y,Z,W)),write('.'),nl)),
	told, !.

load(_) :-
	game_status(1),
	write('Kamu tidak bisa memulai game lainnya ketika ada game yang sudah dimulai.'), nl, !.
    
load(FN):-
	\+exists_file(FN),
	write('File tersebut tidak ada.'), nl, !.

load(FN):-
	retractall(game_status(_)),
    open(FN, read, Str),
  	read_file(Str,Lines),
  	close(Str),
	assertaList(Lines),
  	write('File has been loaded!'), nl.

read_file(Stream, Lines) :-
    read(Stream, Line),               
    ( at_end_of_stream(Stream) -> Lines = [] ;  Lines = [Line|NewLines],       
       read_file(Stream, NewLines)).

/*source:
	load file : https://stackoverflow.com/questions/37573618/how-to-read-a-file-in-prolog/37574687#37574687
*/


/* Dump File : */

/*(posisiLegendary(_,_,_)->retractall(posisiLegendary(_,_,_))),*/
	/*(udah_lari(_) -> retract(udah_lari(_))), (lagi_ketemu(_) -> retract(lagi_ketemu(_))),(battle_status(_) -> retract(battle_status(_))),
	(digym(_)->retract(digym(_))),(maucapture(_)->retractall(maucapture(_))),(lagi_pick(_)->retractall(lagi_pick(_))),(finish_battle(_)->retractall(finish_battle(_))),
	(current_tokemon1(_,_,_,_)-> retract(current_tokemon1(_,_,_,_))),(current_tokemon2(_,_,_,_) -> retract(current_tokemon2(_,_,_,_))),
	(player_status(_)->retract(player_status(_))),*/

% printListLegendaryTokemon:-
% 	forall(tokemon(Tokemon,A,B,C,D,E,X),
% 	forall(X > 12,forall(posisiLegendary(Tokemon,XX,YY),forall(\+inventory(Tokemon,_,_,_,_,_,_,_),(
% 			write('Tokemon: '), writeln(Tokemon),
% 			write('   Health: '),writeln(A),
% 			write('   Normal attack: '),writeln(B),
% 			write('   Special attack: '),writeln(C),
% 			write('   Nama special attack: '),writeln(D),
% 			write('   Type: '),writeln(E),
% 			write('   ID: '),writeln(X),
% 			write('   Posisi: '),write(XX),write(','),write(YY),nl)
% 		))
% 	)),!.