indexing
	description: "Palette entry flag constants."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WEL_PC_CONSTANTS

feature -- Access

	Pc_reserved: INTEGER is
		external
			"C [macro %"wel.h%"]"
		alias
			"PC_RESERVED"
		end

	Pc_explicit: INTEGER is
		external
			"C [macro %"wel.h%"]"
		alias
			"PC_EXPLICIT"
		end

	Pc_nocollapse: INTEGER is
		external
			"C [macro %"wel.h%"]"
		alias
			"PC_NOCOLLAPSE"
		end

end -- class WEL_PC_CONSTANTS


--|----------------------------------------------------------------
--| Windows Eiffel Library: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-2001 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building
--| 360 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support: http://support.eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

