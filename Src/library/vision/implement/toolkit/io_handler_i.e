indexing

	description:
		"A I/O handler manager. %
		%This class should be used to monitor I/O mechanism without interfering %
		%with events mechanism (like scanning a UNIX pipe or socket)";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

deferred class IO_HANDLER_I 

inherit

	G_ANY_I
		export
			{NONE} all
		end;
	
feature 

	is_call_back_set: BOOLEAN is
			-- Is a call back already set ?
		deferred
		end; -- is_call_back_set

	set_error_call_back (a_file: IO_MEDIUM; a_command: COMMAND; an_argument: ANY) is
			-- Set `a_command' with `argument' to execute when an operation
			-- on `a_file' had raised an I/O error.
			--| the behave of this routine should be examined when other
			--| error handlers are used (such as Eiffel exception mechanism).
		require
			no_call_back_already_set: not is_call_back_set;
			not_a_command_void: not (a_command = Void)
		deferred
		ensure
			is_call_back_set
		end; -- set_error_call_back

	set_no_call_back is
			-- Remove any call-back already set.
		require
			a_call_back_must_be_set: is_call_back_set
		deferred
		ensure
			not is_call_back_set
		end; -- set_no_call_back

	set_read_call_back (a_file: IO_MEDIUM; a_command: COMMAND; an_argument: ANY) is
			-- Set `a_command' with `argument' to execute when `a_file' has
			-- data available.
		require
			no_call_back_already_set: not is_call_back_set;
			not_a_command_void: not (a_command = Void)
		deferred
		ensure
			is_call_back_set
		end; -- set_read_call_back

	set_write_call_back (a_file: IO_MEDIUM; a_command: COMMAND; an_argument: ANY) is
			-- Set `a_command' with `argument' to execute when `a_file' is
			-- available for writing.
		require
			no_call_back_already_set: not is_call_back_set;
			not_a_command_void: not (a_command = Void)
		deferred
		ensure
			is_call_back_set
		end;

	destroy is
		deferred
		end;

end 


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
--| Customer support e-mail <eiffel@eiffel.com>
--|----------------------------------------------------------------
