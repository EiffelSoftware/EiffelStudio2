indexing

	description: "Implementation of override shell";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class OVERRIDE_S_O 

inherit

	OVERRIDE_S_I
		
		export
			{NONE} all
		end;

	POPUP_S_O
		redefine
			popup, popdown
		end

creation

	make

feature 

	make (an_override_shell: OVERRIDE_S) is
			-- Create an override shell.
		local
			ext_name: ANY;
		do
			!!is_poped_up_ref;
			ext_name := an_override_shell.identifier.to_c;
			screen_object := xt_create_override_shell ($ext_name, 
						an_override_shell.parent.implementation.screen_object)
		end;

	popdown is
			-- Popdown an override shell.
		
		do
			if is_poped_up then
				xt_popdown (screen_object)
			end;
			is_poped_up_ref.set_item (False)
		ensure then
			not is_poped_up
		end;

	popup is
			-- Popup an override shell.
		do
			if not is_poped_up then
				inspect
					grab_type
				when 0 then
					xt_popup_none (screen_object)
				when 1 then
					xt_popup_exclusive (screen_object)
				when 2 then
					xt_popup_non_ex (screen_object)
				end;
				is_poped_up_ref.set_item (True)
			end
		ensure then
			is_poped_up
		end

feature {NONE} -- External features

	xt_create_override_shell (name: POINTER; parent: POINTER): POINTER is
		external
			"C"
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
