note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Constructor
	make
		do
			i := 0
			create status.make_empty
			status :=  "  ok:  => start new game"
			create player1.make("", 'X')
			create player2.make("", 'O')
			create board.make
			create undo.make
			create redo.make
			first := 1
			valid_play:= false
			game_mode := false
			turn := 0
		end

feature {NONE, ETF_MODEL}-- model attributes
	i : INTEGER
	status : STRING 	--Status of the game
	player1: PLAYER		--Player 1 name
	player2: PLAYER 	--Player 2 name
	board: BOARD		--Board to play on
	valid_play: BOOLEAN
	game_mode: BOOLEAN 	--Can play game?
	turn: INTEGER_32	--Who's turn
	--We create two save_points one for undo and one for redo
	undo: SAVE_POINT --Every time we make a move we put in undo
	redo: SAVE_POINT --Every time we make a move we reset redo and whenwe do undo we push last move to redo
	first: INTEGER_32

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature	-- commands
	new_game(name1: STRING; name2: STRING)
	do
		if name1 ~ name2 then
			status.make_from_string ("  names of players must be different:  => ")
			status.append (whos_next)
		elseif name1.at (1).is_digit or name2.at (1).is_digit then
			status.make_from_string ("  name must start with A-Z or a-z:  => ")
			status.append (whos_next)
		else
			first := 1
			set_players(name1, name2)
			start_game
			status.make_from_string ("  ok: => ")
			status.append (whos_next)
		end
	end

	play(name: STRING; position: INTEGER_32)
	local
		mistake: BOOLEAN
	do
		mistake := false
		if (game_mode and valid_play) then --A game is in progress
			if (turn = 1 and name ~ player1.name and not board.position_taken (position)) then
				make_move(player1, position)
			elseif (turn = 2 and name ~ player2.name and not board.position_taken (position)) then
				make_move(player2, position)
			--Player's name is not right with the turn
			elseif((turn = 2 and name ~ player1.name) or (turn = 1 and name ~ player2.name)) then
				status.make_from_string ("  not this player's turn: => ")
				status.append (whos_next)
				mistake := true --Prevent going to win check
			--Not the right name
			elseif (board.position_taken (position)) then
				status.make_from_string ("  button already taken: => ")
				status.append (whos_next)
				mistake := true --Prevent going to win check
			else
				status.make_from_string ("  no such player: => ")
				status.append (whos_next)
				mistake := true --Prevent going to win check
			end

			if not mistake then
				--Checking for win here
				if board.player1_win then
					status.make_from_string ("  there is a winner: => play again or start new game")
					set_whos_first
					player1.increase_score
					end_game
				elseif board.player2_win then
					status.make_from_string ("  there is a winner: => play again or start new game")
					set_whos_first
					player2.increase_score
					end_game
				elseif board.full then
					status.make_from_string ("  game ended in a tie: => play again or start new game")
					set_whos_first
					end_game
				else
					status.make_from_string ("  ok: => ")
					status.append (whos_next)
				end
			end
		elseif valid_play then
			status.make_from_string ("  game is finished: => play again or start new game")
		else --Need to make a game	
			status.make_from_string ("  no such player:  => ")
			status.append (whos_next)
		end
	end

	play_again
	do
		if valid_play then
			start_game
			status.make_from_string ("  ok: => ")
			status.append (whos_next)
		end
	end

	do_redo
	local
		var: STRING
	do
		if not (redo.load ~ "!NAN!") and game_mode and valid_play then
			var := redo.pop
			if turn = 1 then
				board.move (player1.mark, var.to_integer_32)
			else
				board.move (player2.mark, var.to_integer_32)
			end
			undo.save_string (var)
			reset_turn
			status.make_from_string ("  ok: => ")
			status.append (whos_next)
		end
	end

	do_undo
	local
		var: STRING
	do
		if not (undo.load ~ "!NAN!") and game_mode and valid_play then
			var := undo.pop
			board.reset_move (var.to_integer_32)
			redo.save_string (var)
			reset_turn
			status.make_from_string ("  ok: => ")
			status.append (whos_next)
		end

	end

feature -- queries
	out : STRING
		do --Final printed result after each command
			create Result.make_from_string (status) --Status on top
			Result.append ("%N")
			Result.append (board.to_string) --Board with played positions
			Result.append ("%N")
			Result.append (player1.to_string)
			Result.append ("%N")
			Result.append (player2.to_string)
			if (player1.name ~ "test101" and player2.name ~ "test202") then --test case
				Result.append ("%N")
				Result.append ("UNDO:")
				Result.append (undo.to_string)
				Result.append ("%N")
				Result.append ("REDO:")
				Result.append (redo.to_string)
			end
		end
feature {NONE, ETF_MODEL} --Private commands


feature {NONE, ETF_MODEL} --Private querries

	whos_next: STRING
	do
		if game_mode = true then
			if turn = 1 then
				create Result.make_from_string (player1.name)
			else
				create Result.make_from_string (player2.name)
			end
			Result.append (" plays next")
		else
			Result := "start new game"
		end
	end

	set_players(name1: STRING; name2: STRING)
	do
		valid_play := true
		turn := 1
		create player1.make (name1, 'X')
		create player2.make (name2, 'O')
	end

	start_game --Makes a new board and game state is true
	do
		undo.data_reset
		redo.data_reset
		board.make
		game_mode := true
	end

	end_game
	do
		game_mode := false
	end

	make_move(player: PLAYER; position: INTEGER_32)
	do
		if turn = 1 then
			turn := 2
		else
			turn := 1
		end
		undo.save_int(position)
		redo.data_reset
		board.move (player.get_mark, position)
	end

	reset_turn
	do
		if turn = 1 then
			turn := 2
		else
			turn := 1
		end
	end

	set_whos_first
	do
		if first = 1 then
			first := 2
			turn := first
		else
			first := 1
			turn := first
		end
	end
end




