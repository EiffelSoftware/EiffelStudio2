indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEXT_FIELD_TAB

inherit
	ANY_TAB
		redefine
			make,
			current_widget
		end

creation
	make

feature -- Initialization

	make (par: EV_CONTAINER) is
			-- Create the tab and initialise objects.
		local
			cmd1,cmd2: EV_ROUTINE_COMMAND
				--Commands used by the tab.
		do
		{ANY_TAB} Precursor (Void)
			
		create cmd1.make (~set_maximum_text_length)
		create cmd2.make (~get_maximum_text_length)
		create f1.make (Current, "Maximum Text Length", cmd1, cmd2)	

		set_parent (par)
		end

feature -- Access

	name:STRING is
			-- Returns the name of the tab.
		do
			Result:="Text Field"
		end

	current_widget: EV_TEXT_FIELD
			-- Current feature we are working on.
	
	f1: TEXT_FEATURE_MODIFIER
		-- A feature for viewing and modifying values.

feature -- Execution Feature

	set_maximum_text_length (arg: EV_ARGUMENT; data: EV_EVENT_DATA) is
			-- Set the maximum text length allowed.
		do
			if f1.get_text.is_integer and
			f1.get_text.to_integer>=1 then
				current_widget.set_maximum_text_length (f1.get_text.to_integer)
			end
		end

	get_maximum_text_length (arg: EV_ARGUMENT; data: EV_EVENT_DATA) is
			-- Get the maximum text length allowed.
		do
			f1.set_text(current_widget.get_maximum_text_length.out)
		end
	
end -- class TEXT_FIELD_TAB
