﻿note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	$INDEX

inherit
	EV_RIBBON_DROP_DOWN_BUTTON
			redefine
				create_interface_objects
			end
			
feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
			Precursor
$BUTTON_CREATION
			create buttons.make (1)
$BUTTON_REGISTRY
		end

feature -- Query

$BUTTON_DECLARATION

end
