indexing
	description: "EiffelVision Any, implementation interface."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_ANY_I

feature -- Status report

	destroyed: BOOLEAN is
			-- Is Current object destroyed?
		deferred
		end

	is_valid (object: EV_ANY): BOOLEAN is
			-- Is Current object valid?
		do
			Result := object /= Void and then not object.destroyed
		end

feature -- Status setting

	destroy is
			-- Destroy actual object.
		require
			exist: not destroyed
		deferred
		end

end -- class EV_ANY_I

--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-1998 Interactive Software Engineering Inc.
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
