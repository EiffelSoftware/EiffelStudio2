indexing
	description:
		"Facility to access a standard output medium"

	status:	"See note at end of class"
	date: "$Date$"
	revision: "$Revision$"

class 
	STANDARD_OUTPUT_FACILITY

feature -- Status report

	has_standard_output: BOOLEAN is
			-- Has a standard output been set?
		do
			Result := (standard_output /= Void)
		end
		
feature -- Status setting

	set_standard_output (o: IO_MEDIUM) is
			-- Set standard output to `o'.
		do
			standard_output := o
		ensure
			medium_set: standard_output = o
		end
		
feature {NONE} -- Implementation

	standard_output: IO_MEDIUM
			-- Standard output medium

end -- class STANDARD_OUTPUT_FACILITY

--|----------------------------------------------------------------
--| EiffelTest: Reusable components for developing unit tests.
--| Copyright (C) 2000 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------
