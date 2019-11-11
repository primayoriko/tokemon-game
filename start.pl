/* game start */

include('init.pl')


start:-
	game_status(started),
	write("game sudah dimulai!"),nl,!.

start:-
	game_status(not_started),
	assert(game_status(started)),
	write("..........."),nl.

write_inv:-
	write_inv1(),
	write_inv2(),
	write_inv3(),
	write_inv4(),
	write_inv5(),
	write_inv6().

status:-
	write_inv().

run:-
	player_status(in_battle),
	


