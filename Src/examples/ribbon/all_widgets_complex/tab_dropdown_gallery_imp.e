note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
						]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TAB_DROPDOWN_GALLERY_IMP

inherit
	EV_RIBBON_TAB

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
			create group_dropdown_gallery.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.group_dropdown_gallery>>)

			create groups.make (1)
			groups.extend (group_dropdown_gallery)

		end

feature -- Query
	group_dropdown_gallery: GROUP_DROPDOWN_GALLERY


end

