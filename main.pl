:- include('map.pl').
:- include('player.pl').

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
	write(' 	╔════╗╔═══╗╔╗╔═╗╔═══╗╔═╗╔═╗╔═══╗╔═╗─╔╗'),nl,
	write('	║╔╗╔╗║║╔═╗║║║║╔╝║╔══╝║║╚╝║║║╔═╗║║║╚╗║║'),nl,
	write('	╚╝║║╚╝║║─║║║╚╝╝─║╚══╗║╔╗╔╗║║║─║║║╔╗╚╝║'),nl,
	write('	──║║──║║─║║║╔╗║─║╔══╝║║║║║║║║─║║║║╚╗║║'),nl,
	write('	──║║──║╚═╝║║║║╚╗║╚══╗║║║║║║║╚═╝║║║─║║║'),nl,
	write('	──╚╝──╚═══╝╚╝╚═╝╚═══╝╚╝╚╝╚╝╚═══╝╚╝─╚═╝ '),nl,
	help,nl,nl,
	legend,nl,nl,
	write('Halo! <story>.'),nl,
	write('Selamat bermain! Good luck!'),nl,nl,
	init_map,
	init_player,
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
	printLegendaryKosong,
	!.


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
