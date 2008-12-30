note
	description: "Control interfaces. Help file: "
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	WIRE_CLIPFORMAT_ALIAS

inherit
	X_USER_CLIPFORMAT_RECORD

create
	make_from_alias,
	make,
	make_by_pointer

feature {NONE}  -- Initialization

	make_from_alias (an_alias: X_USER_CLIPFORMAT_RECORD)
			-- Create from alias
		require
			non_void_alias: an_alias /= Void
		do
			make_by_pointer (an_alias.item)
			an_alias.set_shared
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




end -- WIRE_CLIPFORMAT_ALIAS

