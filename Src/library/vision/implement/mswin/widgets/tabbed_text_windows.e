indexing
	description: "Text in Scrolled Window which can have tabs set";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class
	TABBED_TEXT_WINDOWS

inherit
	TABBED_TEXT_I

	SCROLLED_TEXT_WINDOWS
		rename
			make as make_text
		redefine
			realize,
			tab_length
		end

creation
	make

feature -- Initialization

	make (a_scrolled_text: TABBED_TEXT; man: BOOLEAN; oui_parent: COMPOSITE) is
		do
			make_text (a_scrolled_text, man, oui_parent);
			tab_length := 8
			private_text := ""
		end

	realize is
			-- Realize current widget
		local
			fw: FONT_WINDOWS
			wc: WEL_COMPOSITE_WINDOW
		do
			if not realized then
				if width = 0 then
					set_width (200)
				end
				if height = 0  then 
					if private_font /= Void then
						fw ?= font.implementation
						set_height (fw.string_height (Current, "I"))
					end
				end
				resize_for_shell
				wc ?= parent
				wel_make (wc, text, x, y, width, height, id_default)
				set_control_options
				set_text_limit (90000)
				set_tab_length (tab_length)
				if private_background_color /= Void then
					set_background_color (private_background_color)
				end
				enable_standard_notifications
				if private_font /= Void then
					set_font (private_font)
				end
				set_text (private_text)
				if maximum_size > 0 then
					set_maximum_size (maximum_size)
				end
				set_cursor_position (private_cursor_position)
				if margin_width + margin_height > 0 then
					set_margins (margin_width, margin_height)
				end
				if is_multi_line_mode then
					set_top_character_position (private_top_character_position)
				end
				if not managed then
					wel_hide
				elseif parent.shown then
					shown := true
				end
				if private_is_read_only then
					set_read_only
				end
			end
		end

feature -- Status setting

	set_tab_length (new_length: INTEGER) is
			-- Set `tab_length' to `new_length'.
		do
			tab_length := new_length
			if exists then
				set_tab_stops (tab_length * 124)
				invalidate
			end
		end

feature -- Status report

	tab_length: INTEGER
			-- Size for each tabulation

end -- class TABBED_TEXT_WINDOWS


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
