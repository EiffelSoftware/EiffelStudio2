note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TAB_TOGGLE_BUTTON_IMP

inherit
	EV_RIBBON_TAB

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
			create group_toggle_button.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.group_toggle_button>>)

			create groups.make (1)
			groups.extend (group_toggle_button)

		end

feature -- Query
	group_toggle_button: GROUP_TOGGLE_BUTTON


end

