indexing
	description: "Paragraph format mask (PFM) constants for the rich edit %
		%control."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WEL_PFM_CONSTANTS

feature -- Access

	Pfm_startindent: INTEGER is 1
			-- The dxStartIndent member is valid.

	Pfm_rightindent: INTEGER is 2
			-- The dxRightIndent member is valid.

	Pfm_offset: INTEGER is 4
			-- The dxStartIndent member is valid and specifies
			-- a relative value.

	Pfm_alignment: INTEGER is 8
			-- The wAlignment member is valid.

	Pfm_tabstops: INTEGER is 16
			-- The cTabStobs and rgxTabStops members are valid.

	Pfm_numbering: INTEGER is 32
			-- The wNumbering member is valid.
			
	Pfm_spacebefore: INTEGER is 64
			-- The dySpaceBefore member is valid.
			
	Pfm_spaceafter: INTEGER is 128
			-- The dySpaceAfter member is valid.
			
	Pfm_linespacing: INTEGER is 256
			-- The dyLineSpacing member is valid.
			
	Pfm_style: INTEGER is 512
			-- The sStyle member is valid.
			
	Pfm_border: INTEGER is 2048
			-- The wBorderSpace, wBorderWidth and wBorders members are valid.
			
	Pfm_shading: INTEGER is 4096
			-- The wShadingStyle and wShadingWeight members arevalid.
			
	Pfm_numberingstyle: INTEGER is 8092
			-- The wNumberingStyle member is valid.
			
	Pfm_numberingtab: INTEGER is 16384
			-- The wNumberingTab member is valid.
			
	Pfm_numberingstart: INTEGER is 32768
			-- The wNumberingStart member is valid.

	Pfm_offsetindent: INTEGER is -2147483648
			-- The dxOffset member is valid.

end -- class WEL_PFM_CONSTANTS

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

