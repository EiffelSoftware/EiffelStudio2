
-- Message box with a specific question symbol,
-- it is used to get the answer to a question from the user.
-- A dialog shell is automatically created as its parent.

indexing

	date: "$Date$";
	revision: "$Revision$"

class QUESTION_D 

inherit

	MESSAGE_D
		rename
			make as message_d_make
		redefine
			implementation
		end


creation

	make

	
feature 

	make (a_name: STRING; a_parent: COMPOSITE) is
			-- Create a question dialog with `a_name' as identifier,
			-- `a_parent' as parent and call `set_default'.
		require
			name_not_void: not (a_name = Void);
			parent_not_void: not (a_parent = Void)
		do
			depth := a_parent.depth+1;
			widget_manager.new (Current, a_parent);
			identifier:= clone (a_name);
			implementation:= toolkit.question_d (Current);
			set_default
		ensure
			parent = a_parent;
			identifier.is_equal (a_name)
		end;

	
feature {G_ANY, G_ANY_I, WIDGET_I, TOOLKIT}

	implementation: QUESTION_D_I
			-- Implementation of question dialog

end


--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1989, 1991, 1993, Interactive Software
--|   Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <eiffel@eiffel.com>
--|----------------------------------------------------------------
