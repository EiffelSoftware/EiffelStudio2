indexing
	description: "Screen device context."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WEL_SCREEN_DC

inherit
	WEL_DISPLAY_DC
		redefine
			destroy_item
		end

feature -- Basic operations

	get is
			-- Get the device context
		local
			a_default_pointer: POINTER
		do
			if item = a_default_pointer then
				item := cwin_get_dc (a_default_pointer)
			end
		end

	release is
			-- Release the device context
		local
			a_default_pointer: POINTER
		do
			if item /= a_default_pointer then
				unselect_all
				cwin_release_dc (a_default_pointer, item)
				item := a_default_pointer
			end
		end

	quick_release is
			-- Release the device context
		local
			a_default_pointer: POINTER
		do
			if item /= a_default_pointer then
				cwin_release_dc (a_default_pointer, item)
				item := a_default_pointer
			end
		end

feature {NONE} -- Implementation

	destroy_item is
			-- Delete the current device context.
		local
			a_default_pointer: POINTER	-- Default_pointer
		do
				-- Protect the call to DeleteDC, because `destroy_item' can 
				-- be called by the GC so without assertions.
			if item /= a_default_pointer then
				unselect_all
				cwin_release_dc (a_default_pointer, item)
				item := a_default_pointer
			end
		end

end -- class WEL_SCREEN_DC

--|----------------------------------------------------------------
--| Windows Eiffel Library: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------

