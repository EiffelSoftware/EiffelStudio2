indexing
	description:
		"Action sequences for EV_PIXMAP_IMP."
	status: "Generated!"
	keywords: "event, action, sequence"
	date: "Generated!"
	revision: "Generated!"

deferred class
	 EV_PIXMAP_ACTION_SEQUENCES_IMP

inherit
	EV_PIXMAP_ACTION_SEQUENCES_I

EV_ANY_IMP undefine dispose, destroy end

feature -- Event handling

	create_expose_actions: EV_GEOMETRY_ACTION_SEQUENCE is
			-- Create a expose action sequence.
			-- Attach to GTK "expose-event" signal.
		do
			create Result
			--connect_signal_to_actions (Gtk_signal_expose_event, Result, default_translate)
			connect_signal_to_actions ("expose-event", Result, default_translate)
		end

--	Gtk_signal_expose_event: INTEGER is
--		once
--			Result := C.gtk_signal_name ("expose-event")
--		end

end


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

