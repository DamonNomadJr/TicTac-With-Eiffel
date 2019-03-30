note
	description: "Summary description for {SAVE_POINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAVE_POINT

create -- create command
	make

feature {SAVE_POINT} -- attributes
	data_save: ARRAYED_LIST[STRING]

feature {NONE} -- constructor
	make
	do
		create data_save.make (0)
	end

feature -- public commands
	-- Here we are able to save all types of data to our save
	save_string(x: STRING)
	require not x.is_empty
	do
		data_save.force (x.out)
	end

	save_char(x: CHARACTER)
	do
		data_save.force (x.out)
	end

	save_int(x: INTEGER_32)
	do
		data_save.force (x.out)
	end

	save_boolean(x: BOOLEAN)
	do
		data_save.force (x.out)
	end

	save_double(x: DOUBLE)
	do
		data_save.force (x.out)
	end

	data_reset
	do
		data_save.wipe_out
	end

feature --public querries

	to_string: STRING
	do
		create Result.make_from_string("  ")
		from data_save.start
		until data_save.after
		loop
			Result.append(data_save.item)
			Result.append(", ")
			data_save.forth
		end
	end
	load: STRING
	-- require
	--	not data_save.is_empty
	do
		if data_save.is_empty then
			Result := "!NAN!"
		else
			Result := data_save.at (data_save.count)
		end
	end

	pop: STRING
	do
		if data_save.is_empty then
			Result := "!NAN!"
		else
			Result := data_save.at (data_save.count)
			data_save.go_i_th (data_save.count)
			data_save.remove
		end
	end


end
