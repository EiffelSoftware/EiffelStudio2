indexing

	description: 
		"Representation of an X screen cursor.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	MEL_SCREEN_CURSOR

inherit

	ANY
		undefine
			is_equal
		end;

	MEL_RESOURCE
		rename
			handle as identifier
		end;

	MEL_PIXMAP_CONSTANTS
		undefine
			is_equal
		end;

creation

	make_from_type,
	make_from_pixmap,
	make_from_pixmap_with_colors

feature {NONE} -- Initialization

	make_from_type (a_display: MEL_DISPLAY; a_type: INTEGER) is
			-- Create a cursor font from `a_type' for display
			-- `a_display'. (Cursor types are defined in class
			-- MEL_CURSOR_TYPE).
		require
			valid_display: a_display /= Void and then a_display.is_valid
		do
			display_handle := a_display.handle;
			identifier := x_create_font_cursor (display_handle, a_type);
		end;

	make_from_pixmap (a_pixmap, a_mask: MEL_PIXMAP;
			x_hot, y_hot: INTEGER) is
			-- Create a cursor from `a_pixmap' with `a_mask' with 
			-- white background and black foreground. 
		require
			valid_pixmap: a_pixmap /= Void and then a_pixmap.is_valid;
			is_bitmap: a_pixmap.is_bitmap;
			valid_mask: a_mask /= Void implies a_pixmap.is_valid;
			mask_is_bitmap: a_mask /= Void implies a_mask.is_bitmap;
			pixmaps_same_display: a_mask /= Void implies 
				(a_pixmap.display_handle = a_mask.display_handle)
		local
			a_mask_id: POINTER
		do
			display_handle := a_pixmap.display_handle;
			if a_mask /= Void then
				a_mask_id := a_mask.identifier
			end;
			identifier := x_create_pixmap_cursor
				(display_handle, a_pixmap.identifier, a_mask_id,
						0, 0, 0, 65535, 65535, 65535,
						x_hot, y_hot);
		end;

	make_from_pixmap_with_colors (
			a_pixmap, a_mask: MEL_PIXMAP;
			fg_red, fg_green, fg_blue: INTEGER;
			bg_red, bg_green, bg_blue: INTEGER;
			x_hot, y_hot: INTEGER) is
			-- Create a cursor from `a_pixmap' with `a_mask' for display
			-- `a_display' with background and foreground rgb values.
	   require
			valid_pixmap: a_pixmap /= Void and then a_pixmap.is_valid;
			valid_mask: a_mask /= Void implies a_pixmap.is_valid;
			pixmaps_same_display: a_mask /= Void implies 
				(a_pixmap.display_handle = a_mask.display_handle)
		local
			a_mask_id: POINTER
		do
			display_handle := a_pixmap.display_handle;
			if a_mask /= Void then
				a_mask_id := a_mask.identifier
			end;
			identifier := x_create_pixmap_cursor
				(display_handle, a_pixmap.identifier, a_mask_id,
						fg_red, fg_green, fg_blue,
						bg_red, bg_green, bg_blue,	
						x_hot, y_hot);
		end;

feature -- Removal

	free is
			-- Free the cursor.
		require
			not_destroyed: not is_destroyed
		do
			x_free_cursor (display_handle, identifier);
			identifier := default_pointer
		ensure
			destroyed: is_destroyed
		end;

feature {NONE} -- Implementation

	x_create_font_cursor (a_display: POINTER; a_type: INTEGER): POINTER is
		external
			"C [macro <X11/Xlib.h>] (Display *, unsigned int): EIF_POINTER"
		alias
			"XCreateFontCursor"
		end;

	x_create_pixmap_cursor (a_display: POINTER; 
			a_pix, a_mask: POINTER;
			fg_red, fg_green, fg_blue: INTEGER;
			bg_red, bg_green, bg_blue: INTEGER;
			x_hot, y_hot: INTEGER): POINTER is
		external
			"C"
		end;

	x_free_cursor (a_display: POINTER; a_cursor: POINTER) is
		external
			"C [macro <X11/Xlib.h>] (Display *, Cursor)"
		alias
			"XFreeCursor"
		end;

invariant
	
	valid_display: has_valid_display

end -- class MEL_SCREEN_CURSOR

--|-----------------------------------------------------------------------
--| Motif Eiffel Library: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1996, Interactive Software Engineering, Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-----------------------------------------------------------------------
