indexing
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SHORTCUTS_DIALOG_IMP

inherit
	EV_DIALOG
		redefine
			initialize, is_in_default_state
		end
			
	CONSTANTS
		undefine
			is_equal, default_create, copy
		end

-- This class is the implementation of an EV_DIALOG generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_DIALOG}
			initialize_constants
			
				-- Create all widgets.
			create l_ev_vertical_box_1
			create accelerator_list
			create l_ev_horizontal_separator_1
			create l_ev_horizontal_box_1
			create l_ev_label_1
			create keys_combo
			create l_ev_label_2
			create tag_text_field
			create add_button
			create dummy_cancel_button
			
				-- Build_widget_structure.
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (accelerator_list)
			l_ev_vertical_box_1.extend (l_ev_horizontal_separator_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (l_ev_label_1)
			l_ev_horizontal_box_1.extend (keys_combo)
			l_ev_horizontal_box_1.extend (l_ev_label_2)
			l_ev_horizontal_box_1.extend (tag_text_field)
			l_ev_horizontal_box_1.extend (add_button)
			l_ev_horizontal_box_1.extend (dummy_cancel_button)
			
			l_ev_vertical_box_1.set_padding_width (5)
			l_ev_vertical_box_1.set_border_width (2)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_separator_1)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.set_padding_width (5)
			l_ev_horizontal_box_1.set_border_width (2)
			l_ev_horizontal_box_1.disable_item_expand (l_ev_label_1)
			l_ev_horizontal_box_1.disable_item_expand (keys_combo)
			l_ev_horizontal_box_1.disable_item_expand (l_ev_label_2)
			l_ev_horizontal_box_1.disable_item_expand (add_button)
			l_ev_horizontal_box_1.disable_item_expand (dummy_cancel_button)
			l_ev_label_1.set_text ("Ctrl + ")
			l_ev_label_2.set_text (" = ")
			add_button.set_text ("Add")
			dummy_cancel_button.set_minimum_width (0)
			dummy_cancel_button.set_minimum_height (0)
			set_minimum_width (dialog_width)
			set_minimum_height (dialog_height)
			set_title ("Shortcut Configuration")
			
				--Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	keys_combo: EV_COMBO_BOX
	accelerator_list: EV_MULTI_COLUMN_LIST
	l_ev_horizontal_separator_1: EV_HORIZONTAL_SEPARATOR
	add_button: EV_BUTTON
	dummy_cancel_button: EV_BUTTON
	l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
	l_ev_vertical_box_1: EV_VERTICAL_BOX
	l_ev_label_1: EV_LABEL
	l_ev_label_2: EV_LABEL
	tag_text_field: EV_TEXT_FIELD

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state?
		do
			-- Re-implement if you wish to enable checking
			-- for `Current'.
			Result := True
		end
	
	user_initialization is
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end
	
end -- class SHORTCUTS_DIALOG_IMP
