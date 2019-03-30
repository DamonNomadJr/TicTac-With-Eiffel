note
	description: "Summary description for {PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

create
	make

feature -- Variables
	score: INTEGER
	name: STRING
	mark: CHARACTER

feature --Constructor
	make(s: STRING; m: CHARACTER)
	do
		name := s
		mark := m
		score := 0
	end

feature --Commands
	increase_score
	do
		score := score + 1
	end

feature --Querries
	to_string: STRING
	do
		create Result.make_from_string("  ")
		Result.append (score.out)
		Result.append (": score for %"")
		Result.append (name.out)
		Result.append ("%" (as ")
		Result.append (mark.out)
		Result.append (")")
	end

	get_name: STRING
	do
		Result := name
	end

	get_mark: CHARACTER
	do
		Result := mark
	end
end
