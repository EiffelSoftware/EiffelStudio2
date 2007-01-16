indexing
	description: "Gdi+ font style enumeration."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WEL_GDIP_FONT_STYLE

feature -- Enumerations

    FontStyleRegular: INTEGER is 0
    		-- Regular

    FontStyleBold: INTEGER is 1
    		-- Bold

    FontStyleItalic: INTEGER is 2
    		-- Italic

    FontStyleBoldItalic: INTEGER is 3
    		-- Bold italic

    FontStyleUnderline: INTEGER is 4
    		-- Underline

    FontStyleStrikeout: INTEGER is 8
    		-- Strickout

feature -- Query

	is_valid (a_style: INTEGER): BOOLEAN is
			-- If `a_style' valid?
		do
			Result := a_style = FontStyleRegular or
						a_style = FontStyleBold or
						a_style = FontStyleItalic or
						a_style = FontStyleBoldItalic or
						a_style = FontStyleUnderline or
						a_style = FontStyleStrikeout
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
