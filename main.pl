/*update :-
	sudahMenang(Menang),Menang == true,
	write('     my story   '),nl,
	quit,!.

update :- !. */

start :- !.


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


