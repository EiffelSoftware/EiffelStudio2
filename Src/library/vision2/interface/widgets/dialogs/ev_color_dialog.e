--| FIXME Not for release
--| FIXME NOT_REVIEWED this file has not been reviewed
indexing 
	description:
		"EiffelVision color selection dialog."
	status: "See notice at end of class"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_COLOR_DIALOG

inherit
	EV_SELECTION_DIALOG
		redefine
			implementation
		end

create
	make

feature {NONE} -- Initialization

	make (par: EV_CONTAINER) is
			-- Create a directory selection dialog with `par' as
			-- parent.
		do
			!EV_COLOR_DIALOG_IMP! implementation.make (par)
			implementation.set_interface (Current)
		end

feature -- Access

	color: EV_COLOR is
			-- Current selected color
		require
		do
			Result := implementation.color
		end

feature -- Element change

	select_color (a_color: EV_COLOR) is
			-- Select `a_color'.
		require
		do
			implementation.select_color (a_color)
		end

feature -- Event - command association

	add_help_command (cmd: EV_COMMAND; arg: EV_ARGUMENT) is
			-- Add `cmd' to the list of commands to be executed when
			-- the "Help" button is pressed.
		require
			valid_command: cmd /= Void
		do
			implementation.add_help_command (cmd, arg)
		end

feature -- Event -- removing command association

	remove_help_commands is
			-- Empty the list of commands to be executed when
			-- "Help" button is pressed.
		require
		do
			implementation.remove_help_commands
		end

feature -- Implementation

	implementation: EV_COLOR_DIALOG_I

end -- class EV_COLOR_DIALOG

--!-----------------------------------------------------------------------------
--! EiffelVision2: library of reusable components for ISE Eiffel.
--! Copyright (C) 1986-2000 Interactive Software Engineering Inc.
--! All rights reserved. Duplication and distribution prohibited.
--! May be used only with ISE Eiffel, under terms of user license. 
--! Contact ISE for any other use.
--!
--! Interactive Software Engineering Inc.
--! ISE Building, 2nd floor
--! 270 Storke Road, Goleta, CA 93117 USA
--! Telephone 805-685-1006, Fax 805-685-6869
--! Electronic mail <info@eiffel.com>
--! Customer support e-mail <support@eiffel.com>
--! For latest info see award-winning pages: http://www.eiffel.com
--!-----------------------------------------------------------------------------

--|-----------------------------------------------------------------------------
--| CVS log
--|-----------------------------------------------------------------------------
--|
--| $Log$
--| Revision 1.11  2000/02/29 18:09:09  oconnor
--| reformatted indexing cluase
--|
--| Revision 1.10  2000/02/22 18:39:49  oconnor
--| updated copyright date and formatting
--|
--| Revision 1.9  2000/02/14 11:40:50  oconnor
--| merged changes from prerelease_20000214
--|
--| Revision 1.8.6.4  2000/02/01 16:13:07  brendel
--| Added FIXME Not for release, since the interface has not been reviewed yet,
--| and is not implemented on any platform.
--|
--| Revision 1.8.6.3  2000/01/28 22:24:22  oconnor
--| released
--|
--| Revision 1.8.6.2  2000/01/27 19:30:49  oconnor
--| added --| FIXME Not for release
--|
--| Revision 1.8.6.1  1999/11/24 17:30:50  oconnor
--| merged with DEVEL branch
--|
--| Revision 1.8.2.3  1999/11/04 23:10:54  oconnor
--| updates for new color model, removed exists: not destroyed
--|
--| Revision 1.8.2.2  1999/11/02 17:20:12  oconnor
--| Added CVS log, redoing creation sequence
--|
--|
--|-----------------------------------------------------------------------------
--| End of CVS log
--|-----------------------------------------------------------------------------
