indexing

	description: "Implementation of menu";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class MENU_O 

inherit

	MENU_R_O
		export
			{NONE} all
		end;

	MANAGER_O

feature {NONE}

	abstract_menu: MENU;
			-- Current abstract menu

feature 

	set_title (a_title: STRING) is
			-- Set menu title to `a_title'.
		require
			not_title_void: not (a_title = Void)
		
		local
			ext_title, resource: ANY
		do
			ext_title := a_title.to_c;
			resource :=  Otitle.to_c;
			set_string (screen_object, $ext_title, $resource);
			title := a_title
		end;

	remove_title is
			-- Remove current menu title if any.
		do
			set_title ("")
		end;

	title: STRING;

	allow_recompute_size is do end;

	forbid_recompute_size is do end;
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
