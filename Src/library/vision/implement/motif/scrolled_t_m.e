indexing

	description: 
		"EiffelVision implementation of a Motif scrolled text widget.";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class 
	SCROLLED_T_M

inherit

	SCROLLED_T_I;

	PRIMITIVE_COMPOSITE_M
		undefine
			set_no_event_propagation
		redefine
			set_size, set_height, set_width
		end;

	TEXT_M
		undefine
			mel_text_make, make_from_existing,
			height, real_x, real_y, realized, shown, width,
			x, y, hide, lower, propagate_event, raise,
			realize, set_x, set_x_y, set_y, show, unrealize,
			set_no_event_propagation, clean_up, object_clean_up
		redefine
			make, make_word_wrapped,
			set_background_color_from_imp,
			set_managed, set_size, set_height,
			set_width, parent
		end;

	MEL_SCROLLED_TEXT
		rename
			make as mel_text_make,
			foreground_color as mel_foreground_color,
			set_foreground_color as mel_set_foreground_color,
			background_color as mel_background_color,
			background_pixmap as mel_background_pixmap,
			set_background_color as mel_set_background_color,
			set_background_pixmap as mel_set_background_pixmap,
			destroy as mel_destroy,
			screen as mel_screen,
			set_editable as mel_set_editable,
			pos_to_x as x_coordinate,
			pos_to_y as y_coordinate,
			xy_to_pos as character_position,
			resize_height as is_height_resizable,
			resize_width as is_width_resizable,
			word_wrap as is_word_wrap_mode,
			verify_bell as is_bell_enabled,
			string as text,
			set_string as set_text,
			max_length as maximum_size,
			set_max_length as set_maximum_size,
			top_character as top_character_position,
			set_top_character as set_top_character_position,
			clear_selection as clear_selecton_with_time,
			clear_selection_with_current_time as clear_selection,
			set_selection as set_selecton_with_time,
			set_selection_with_current_time as set_selection,
			insert as mel_insert,
			is_scroll_vertical as is_vertical_scrollbar,
			is_scroll_horizontal as is_horizontal_scrollbar,
			is_shown as shown
		undefine
			height, real_x, real_y, realized, width,
			x, y, hide, lower, propagate_event, raise,
			realize, set_x, set_x_y, set_y, show, unrealize
		redefine
			set_height, set_width, set_size, parent
		select
			mel_text_make, make_from_existing
		end

creation

	make, make_word_wrapped

feature {NONE} -- Initialization

	make (a_scrolled_text: TEXT; man: BOOLEAN; oui_parent: COMPOSITE) is
			-- Create a motif scrolled text.
		local
			mc: MEL_COMPOSITE
		do
			mc ?= oui_parent.implementation;
			widget_index := widget_manager.last_inserted_position;
			mel_text_make (a_scrolled_text.identifier, mc, man);
			a_scrolled_text.set_font_imp (Current);
			set_multi_line_mode;
		end;

	make_word_wrapped (a_scrolled_text: TEXT; man: BOOLEAN; oui_parent:
COMPOSITE) is
			-- Create a motif scrolled text enabling word wrap.
		local
			mc: MEL_COMPOSITE
		do
			mc ?= oui_parent.implementation;
			widget_index := widget_manager.last_inserted_position;
			make_detailed (a_scrolled_text.identifier, mc, 
					man, False, True, False, False);
			a_scrolled_text.set_font_imp (Current);
			set_single_line_mode;
			set_word_wrap (True);
		end;

feature -- Access

	parent: MEL_SCROLLED_WINDOW;
			-- Scrolled window parent

	main_widget: MEL_WIDGET is
			-- Main widget which is the scrolled window
		do
			Result := parent
		end

feature -- Status setting

	set_size (new_width:INTEGER; new_height: INTEGER) is
			-- Set both width and height to `new_width'
			-- and `new_height'.
		local
			was_unmanaged: BOOLEAN
		do
			if not managed then
				manage;
				was_unmanaged := True
			end;
			main_widget.set_size (new_width, new_height)
			if was_unmanaged then
				unmanage
			end
		end;

	set_width (new_width :INTEGER) is
			-- Set width to `new_width'.
		local
			was_unmanaged: BOOLEAN
		do
			if not managed then
				manage;
				was_unmanaged := True
			end;
			main_widget.set_width (new_width)
			if was_unmanaged then
				unmanage;
			end
		end;

	set_height (new_height: INTEGER) is
			-- Set height to `new_height'.
		local
			was_unmanaged: BOOLEAN
		do
			if not managed then
				manage;
				was_unmanaged := True
			end;
			main_widget.set_height (new_height)
			if was_unmanaged then
				unmanage;
			end
		end;

	set_managed (flag: BOOLEAN) is
			-- Enable geometry managment on screen widget implementation,
			-- by window manager of parent widget if `flag', disable it
			-- otherwise.
		do
			if flag then
				main_widget.manage
				manage
			else
				main_widget.unmanage
				unmanage
			end
		end;

	hide_horizontal_scrollbar is
			-- Make horizontal scrollbar invisible.
		local
			w: MEL_WIDGET
		do
			w := parent.horizontal_scroll_bar
			if w /= Void then
				w.unmanage
			end;
		end;

	hide_vertical_scrollbar is
			-- Make vertical scrollbar invisible.
		local
			w: MEL_WIDGET
		do
			w := parent.vertical_scroll_bar
			if w /= Void then
				w.unmanage
			end;
		end;

	show_horizontal_scrollbar is
			-- Make horizontal scrollbar visible.
		local
			w: MEL_WIDGET
		do
			w := parent.horizontal_scroll_bar
			if w /= Void then
				w.manage
			end;
		end;

	show_vertical_scrollbar is
			-- Make vertical scrollbar visible.
		local
			w: MEL_WIDGET
		do
			w := parent.vertical_scroll_bar
			if w /= Void then
				w.manage
			end
		end;

	set_background_color_from_imp (color_imp: COLOR_X) is
			-- Set the background color from implementation `color_imp'.
		local
			w: MEL_WIDGET
		do
			mel_set_background_color (color_imp);
			update_colors;
			parent.set_background_color (color_imp);
			w := parent.vertical_scroll_bar;
			if w /= Void then
				w.set_background_color (color_imp);	
				w.update_colors
			end;
			w := parent.horizontal_scroll_bar;
			if w /= Void then
				w.set_background_color (color_imp);
				w.update_colors
			end;
			if private_foreground_color /= Void then
				update_foreground_color
			end
		end;

end -- class SCROLLED_T_M

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
