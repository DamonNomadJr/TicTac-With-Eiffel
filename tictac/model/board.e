note
	description: "Summary description for {BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOARD

create
	make

feature {NONE, BOARD} --Attributes
	board : ARRAY[CHARACTER]

feature	--Constructor
	make
	local
		i: INTEGER_32
	do
		create board.make(1, 9)
		from i := 1
		until i = 10
		loop
			board.at (i) := '_'
			i := i + 1
		end
	end

feature --Command
	move (mark: CHARACTER; position: INTEGER_32) --Changes the value at board's `positio` by `mark`
	require
		valid_position: position > 0 and position < 10
		valid_mark: mark ~ 'X' or mark ~ 'O'
	do
		board.at(position) := mark
	end

	reset_move (position: INTEGER_32)
	do
		board.at (position) := '_'
	end

feature
	player1_win: BOOLEAN
	do --Win condition for player 1
		if
			(board.at (1) ~ board.at (2) and board.at (1) ~ board.at (3) and (board.at (1) ~ 'X')) or -- row 1
			(board.at (4) ~ board.at (5) and board.at (4) ~ board.at (6) and (board.at (4) ~ 'X')) or -- row 2
			(board.at (7) ~ board.at (8) and board.at (7) ~ board.at (9) and (board.at (7) ~ 'X')) or -- row 3
			(board.at (1) ~ board.at (4) and board.at (1) ~ board.at (7) and (board.at (1) ~ 'X')) or -- col 1
			(board.at (2) ~ board.at (5) and board.at (2) ~ board.at (8) and (board.at (2) ~ 'X')) or -- col 2
			(board.at (3) ~ board.at (6) and board.at (3) ~ board.at (9) and (board.at (3) ~ 'X')) or -- col 3
			(board.at (1) ~ board.at (5) and board.at (1) ~ board.at (9) and (board.at (1) ~ 'X')) or -- hor 1
			(board.at (3) ~ board.at (5) and board.at (3) ~ board.at (7) and (board.at (3) ~ 'X'))    -- hor 2
		then
			Result := true
		else
			Result := false
		end
	end

	player2_win: BOOLEAN
	do --Win condition for player 2
		if
			(board.at (1) ~ board.at (2) and board.at (1) ~ board.at (3) and (board.at (1) ~ 'O')) or -- row 1
			(board.at (4) ~ board.at (5) and board.at (4) ~ board.at (6) and (board.at (4) ~ 'O')) or -- row 2
			(board.at (7) ~ board.at (8) and board.at (7) ~ board.at (9) and (board.at (7) ~ 'O')) or -- row 3
			(board.at (1) ~ board.at (4) and board.at (1) ~ board.at (7) and (board.at (1) ~ 'O')) or -- col 1
			(board.at (2) ~ board.at (5) and board.at (2) ~ board.at (8) and (board.at (2) ~ 'O')) or -- col 2
			(board.at (3) ~ board.at (6) and board.at (3) ~ board.at (9) and (board.at (3) ~ 'O')) or -- col 3
			(board.at (1) ~ board.at (5) and board.at (1) ~ board.at (9) and (board.at (1) ~ 'O')) or -- hor 1
			(board.at (3) ~ board.at (5) and board.at (3) ~ board.at (7) and (board.at (3) ~ 'O'))    -- hor 2
		then
			Result := true
		else
			Result := false
		end
	end

	full:BOOLEAN
	do
		Result := (board.at (1) ~ 'O' or board.at (1) ~ 'X') and
			(board.at (2) ~ 'O' or board.at (2) ~ 'X') and
			(board.at (3) ~ 'O' or board.at (3) ~ 'X') and
			(board.at (4) ~ 'O' or board.at (4) ~ 'X') and
			(board.at (5) ~ 'O' or board.at (5) ~ 'X') and
			(board.at (6) ~ 'O' or board.at (6) ~ 'X') and
			(board.at (7) ~ 'O' or board.at (7) ~ 'X') and
			(board.at (8) ~ 'O' or board.at (8) ~ 'X') and
			(board.at (9) ~ 'O' or board.at (9) ~ 'X')
	end

	position_taken(position: INTEGER_32): BOOLEAN
	do --Tells the model if the position has been played before
		if not (board.at (position) ~ '_') then
			Result := true --Position is 'X' or 'O'
		else
			Result := false --Position is '_'
		end
	end

feature
	to_string: STRING --Prints a board as [---][---][---] with "  " included in each line
	local
		i : INTEGER
	do
		create Result.make_from_string ("  ")
		from i := 1
		until i = 10
		loop
			Result.append (board.at (i).out)
			if ((i \\ 3 = 0) and not (i = 9)) then
				Result.append("%N  ")
			end
			i := i + 1
		end
	end

feature {BOARD, NONE} -- Private functions

end
