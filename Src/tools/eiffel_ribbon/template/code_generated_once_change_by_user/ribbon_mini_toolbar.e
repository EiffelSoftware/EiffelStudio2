﻿note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

class
	$INDEX

inherit
	EV_RIBBON_MINI_TOOLBAR
		redefine
			create_interface_objects
		end
		
create
	make_with_command_list

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
$MENU_GROUP_CREATION
			create groups.make (1)
$MENU_GROUP_REGISTRY
		end
		
feature -- Query
$MENU_GROUP_DECLARATION

end
