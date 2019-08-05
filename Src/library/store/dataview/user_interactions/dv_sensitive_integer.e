note
	description: "Sensitive integer provider."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2008-12-29 21:27:11 +0100 (Mon, 29 Dec 2008) $"
	revision: "$Revision: 76420 $"

deferred class
	DV_SENSITIVE_INTEGER

feature -- Access

	value: INTEGER
			-- Selected integer value.
		deferred
		end

feature -- Basic operations

	set_value (i: INTEGER)
			-- Set `i' to integer value.
		deferred
		end

	request_sensitive
			-- Request display sensitive.
		deferred
		end

	request_insensitive
			-- Request display insensitive.
		deferred
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





end -- class DV_SENSITIVE_INTEGER


