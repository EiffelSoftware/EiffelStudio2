indexing

	description: "Rectangle which displays an option menu when armed";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

deferred class OPTION_B_I 

inherit

	BUTTON_I
    
feature 

	selected_button: BUTTON is
            -- Current Push Button selected in the option menu
        deferred
        end; -- selected_button

    set_selected_button (button: BUTTON) is
            -- Set `selected_button' to `button'
        require
            button_exists: not (button = Void)
        deferred
        ensure
            button = selected_button
        end; -- set_selected_button

	attach_menu (a_menu: OPT_PULL) is
			-- Attach menu `a_menu' to the menu button, it will
			-- be the menu which will appear when the button
			-- is armed.
		require
			menu_not_void: not (a_menu = Void)
		deferred
		end; -- attach_menu

	title: STRING is
		deferred
		end;

	set_title (a_title: STRING) is
		deferred
		end;

	remove_title is
		deferred
		end;
	
	title_width: INTEGER is
		deferred
		end;

feature

	add_activate_action (a_command: COMMAND; argument: ANY) is
		deferred
		end;

	add_arm_action (a_command: COMMAND; argument: ANY) is
		deferred
		end;

	add_release_action (a_command: COMMAND; argument: ANY) is
		deferred
		end;

	remove_activate_action (a_command: COMMAND; argument: ANY) is
		deferred
		end;

	remove_arm_action (a_command: COMMAND; argument: ANY) is
		deferred
		end;

	remove_release_action (a_command: COMMAND; argument: ANY) is
		deferred
		end;

end --class OPTION_B_I


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
