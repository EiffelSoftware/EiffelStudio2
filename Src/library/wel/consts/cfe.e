indexing
	description: "Char format effect (CFE) constants for the rich edit %
		%control."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WEL_CFE_CONSTANTS

feature -- Access

	Cfe_autocolor: INTEGER is
			-- The text color is the return value of
			-- GetSysColor (COLOR_WINDOWTEXT).
		external
			"C [macro <redit.h>]"
		alias
			"CFE_AUTOCOLOR"
		end

	Cfe_bold: INTEGER is
			-- Characters are bold.
		external
			"C [macro <redit.h>]"
		alias
			"CFE_BOLD"
		end

	Cfe_italic: INTEGER is
			-- Characters are italic.
		external
			"C [macro <redit.h>]"
		alias
			"CFE_ITALIC"
		end

	Cfe_strikeout: INTEGER is
			-- Characters are struck out.
		external
			"C [macro <redit.h>]"
		alias
			"CFE_STRIKEOUT"
		end

	Cfe_underline: INTEGER is
			-- Characters are underlined.
		external
			"C [macro <redit.h>]"
		alias
			"CFE_UNDERLINE"
		end

	Cfe_protected: INTEGER is
			-- Characters are protected; an attempt to modify them
			-- will cause an EN_PROTECTED notification message.
		external
			"C [macro <redit.h>]"
		alias
			"CFE_PROTECTED"
		end

end -- class WEL_CFE_CONSTANTS

--|-------------------------------------------------------------------------
--| Windows Eiffel Library: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1995, Interactive Software Engineering, Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-------------------------------------------------------------------------
