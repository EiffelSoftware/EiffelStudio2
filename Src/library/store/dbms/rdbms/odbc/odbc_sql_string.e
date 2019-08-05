note
	description: "Summary description for {ODBC_SQL_STRING}."
	author: ""
	date: "$Date: 2015-02-03 23:14:33 +0100 (Tue, 03 Feb 2015) $"
	revision: "$Revision: 96577 $"

class
	ODBC_SQL_STRING

inherit
	SQL_ABSTRACT_STRING

create
	make,
	make_empty,
	make_by_pointer,
	make_by_pointer_and_count,
	make_shared_from_pointer,
	make_shared_from_pointer_and_count,
	own_from_pointer,
	own_from_pointer_and_count

feature -- Measurement

	character_size: INTEGER = 2
			-- Size of a character

feature {NONE} -- Implementation

	c_strlen (ptr: POINTER): INTEGER
			-- | FIXME: This should be refactored into odbc implementation.
		external
			"C macro use %"odbc.h%""
		alias
			"TXTLEN"
		end

end
