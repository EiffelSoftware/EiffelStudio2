note

	description:
		"Information given by EiffelVision when a toggle button's value has been %
		%changed"
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class TOGGLE_DATA 

obsolete
	"Use class CONTEXT_DATA instead."

inherit 

	CONTEXT_DATA
		rename
			make as context_data_make
		end

create

	make

feature 

	state: BOOLEAN;
			-- New state of toggle button

	make (a_widget: WIDGET; a_state: BOOLEAN)
			-- Create a context_data for `value changed' action.
		do
			widget := a_widget;
			state := a_state
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end

