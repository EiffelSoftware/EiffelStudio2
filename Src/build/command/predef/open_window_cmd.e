indexing
	description: "Represents the predefined command Build_open_cmd."
	date: "$Date$"
	id: "$Id$"
	revision: "$Revision$"

class
	OPEN_WINDOW_CMD

inherit
	PREDEF_CMD

creation

	make

feature 

	eiffel_type: STRING is "Build_open_cmd";

	label: STRING is "Open window";

	identifier: INTEGER is
		do
			Result := - open_window_cmd_id
		end;

	arguments: EB_LINKED_LIST [ARG] is
		local
			arg: ARG
		once
			!! Result.make
			!! arg.session_init (context_catalog.perm_wind_type)
			Result.extend (arg)
		end

	labels: EB_LINKED_LIST [CMD_LABEL] is
		local
			lab: CMD_LABEL
		once
			!! Result.make;
			!! lab.make ("open window");
			Result.extend (lab);
		end

end -- class OPEN_WINDOW_CMD
