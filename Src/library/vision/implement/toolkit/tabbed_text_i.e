indexing

	description: "Text in Scrolled Window which can have tabs set";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

deferred class

	TABBED_TEXT_I

inherit

	SCROLLED_T_I

feature -- Status report

	tab_length: INTEGER is
			-- Size of tabulation
		deferred
		ensure
			result_greater_than_one: Result > 1
		end

feature -- Status setting

	set_tab_length (new_length: INTEGER) is
			-- Set `tab_length' to `new_length'.
		require
			valid_new_length: new_length > 1
		deferred
		ensure
			set: tab_length = new_length
		end

end -- class TABBED_TEXT_I

--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1989, 1991, 1993, 1994, Interactive Software
--|   Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|----------------------------------------------------------------

