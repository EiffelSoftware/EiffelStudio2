indexing

	description: 
		"Parent of any graphic application based on the Motif toolkit. %
		%This is an convenience class to automatically setup the %
		%environment for a motif application.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

deferred class
	MEL_APPLICATION

feature {NONE} -- Initialization

	make is
			-- Create the application.
		do
			set_default;
			!! application_context.make;
			!! display.make (application_context, Void, 
				Void, application_name);
			if display.is_valid then
				!! top_level.make (application_name, Void, display.default_screen);
				build;
				top_level.realize;
				application_context.main_loop
			end
		end;

feature -- Access

	top_level: MEL_APPLICATION_SHELL;
			-- Top level of the application

	display: MEL_DISPLAY;
			-- Application display

	application_name: STRING is
			-- Application name
		deferred
		end;

	application_context: MEL_APPLICATION_CONTEXT
			-- Application context

feature -- Basic operations

	exit is
			-- Exit from the application
		do
			application_context.exit
		end;

	main_loop is
			-- Loop the application.
		do
			application_context.main_loop
		end;

feature {NONE} -- Implementation

	set_default is
			-- Define default parameters for the application.
		do
		end;

	build is
			-- Build an application.
		do
		end;

end -- class MEL_APPLICATION

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
