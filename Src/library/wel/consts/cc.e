indexing
	description: "Curves capabilities (CC) constants."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WEL_CURVES_CAPABILITIES_CONSTANTS

feature -- Access

	Cc_none: INTEGER is
			-- Supports curves
		external
			"C [macro <wel.h>]"
		alias
			"CC_NONE"
		end

	Cc_circles: INTEGER is
			-- Supports circles
		external
			"C [macro <wel.h>]"
		alias
			"CC_CIRCLES"
		end

	Cc_pie: INTEGER is
			-- Supports pie wedges
		external
			"C [macro <wel.h>]"
		alias
			"CC_PIE"
		end

	Cc_chord: INTEGER is
			-- Supports chords
		external
			"C [macro <wel.h>]"
		alias
			"CC_CHORD"
		end

	Cc_ellipses: INTEGER is
			-- Supports ellipses
		external
			"C [macro <wel.h>]"
		alias
			"CC_ELLIPSES"
		end

	Cc_wide: INTEGER is
			-- Supports wide borders
		external
			"C [macro <wel.h>]"
		alias
			"CC_WIDE"
		end

	Cc_styled: INTEGER is
			-- Supports styled borders
		external
			"C [macro <wel.h>]"
		alias
			"CC_STYLED"
		end

	Cc_wide_styled: INTEGER is
			-- Supports wide, styled borders
		external
			"C [macro <wel.h>]"
		alias
			"CC_WIDESTYLED"
		end

	Cc_interiors: INTEGER is
			-- Supports interiors
		external
			"C [macro <wel.h>]"
		alias
			"CC_INTERIORS"
		end

	Cc_round_rect: INTEGER is
			-- Supports rectangles with rounded corners
		external
			"C [macro <wel.h>]"
		alias
			"CC_ROUNDRECT"
		end

end -- class WEL_CURVES_CAPABILITIES_CONSTANTS

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
