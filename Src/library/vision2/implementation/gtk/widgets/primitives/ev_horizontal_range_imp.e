indexing 
	description: "Eiffel Vision horizontal range. GTK+ implementation."
	status: "See notice at end of class"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_HORIZONTAL_RANGE_IMP

inherit
	EV_HORIZONTAL_RANGE_I
		redefine
			interface
		end

	EV_RANGE_IMP
		redefine
			interface,
			make
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create the horizontal range.
		do
			Precursor (an_interface)
			set_c_object (feature {EV_GTK_EXTERNALS}.gtk_event_box_new)
			visual_widget := feature {EV_GTK_EXTERNALS}.gtk_hscale_new (adjustment)
			feature {EV_GTK_EXTERNALS}.gtk_container_add (c_object, visual_widget)
			feature {EV_GTK_EXTERNALS}.gtk_scale_set_digits (visual_widget, 0)
			feature {EV_GTK_EXTERNALS}.gtk_widget_show (visual_widget)
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_HORIZONTAL_RANGE

end -- class EV_HORIZONTAL_RANGE_IMP

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-2001 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building
--| 360 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support: http://support.eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

